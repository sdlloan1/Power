'use strict';

const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');
const stock = require('./stock');

const ROOT = path.resolve(process.env.MEDIA_ROOT || path.join(__dirname, '..'));
const PORT = Number(process.env.PORT || 3000);
const PUBLIC_DIR = path.join(__dirname, 'public');

// Directories that never contain media, or that belong to the dashboard itself.
const SKIP_DIRS = new Set([
  '.git', 'node_modules', 'dashboard', 'lib', 'META-INF',
  'com', 'google', 'kotlin', 'okhttp3', 'org',
  'groverconfig5278830133449762670',
]);

const CATEGORIES = [
  { key: 'video', label: 'Videos', exts: new Set(['.mp4', '.webm', '.mov', '.m4v']) },
  { key: 'music', label: 'Music', exts: new Set(['.m4a', '.mp3', '.aac', '.wav', '.ogg', '.flac']) },
  { key: 'image', label: 'Images', exts: new Set(['.jpg', '.jpeg', '.png', '.webp', '.gif']) },
];

const MIME = {
  '.mp4': 'video/mp4', '.webm': 'video/webm', '.mov': 'video/quicktime', '.m4v': 'video/x-m4v',
  '.m4a': 'audio/mp4', '.mp3': 'audio/mpeg', '.aac': 'audio/aac', '.wav': 'audio/wav',
  '.ogg': 'audio/ogg', '.flac': 'audio/flac',
  '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg', '.png': 'image/png', '.webp': 'image/webp', '.gif': 'image/gif',
  '.html': 'text/html; charset=utf-8', '.js': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8', '.svg': 'image/svg+xml',
};

function listMedia() {
  const buckets = {};
  for (const category of CATEGORIES) buckets[category.key] = [];

  const walk = (dir) => {
    let entries;
    try {
      entries = fs.readdirSync(dir, { withFileTypes: true });
    } catch {
      return;
    }
    for (const entry of entries) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        if (!SKIP_DIRS.has(entry.name)) walk(full);
        continue;
      }
      const ext = path.extname(entry.name).toLowerCase();
      const category = CATEGORIES.find((item) => item.exts.has(ext));
      if (!category) continue;
      let size = 0;
      try {
        size = fs.statSync(full).size;
      } catch {
        continue;
      }
      const rel = path.relative(ROOT, full).split(path.sep).join('/');
      buckets[category.key].push({ rel, name: entry.name, ext, size });
    }
  };

  walk(ROOT);

  for (const key of Object.keys(buckets)) {
    buckets[key].sort((a, b) => a.rel.localeCompare(b.rel));
  }
  return buckets;
}

const LIBRARY = listMedia();

const COUNTS = Object.fromEntries(
  CATEGORIES.map((category) => [category.key, LIBRARY[category.key].length]),
);

const fileUrl = (rel) => '/media/' + rel.split('/').map(encodeURIComponent).join('/');
const downloadUrl = (rel) => '/download/' + rel.split('/').map(encodeURIComponent).join('/');

function resolveInside(relPath) {
  let decoded;
  try {
    decoded = decodeURIComponent(relPath);
  } catch {
    return null;
  }
  const full = path.resolve(ROOT, '.' + path.sep + decoded);
  if (!full.startsWith(ROOT + path.sep)) return null;
  return full;
}

function json(res, status, payload) {
  const body = JSON.stringify(payload);
  res.writeHead(status, {
    'Content-Type': 'application/json; charset=utf-8',
    'Content-Length': Buffer.byteLength(body),
    'Cache-Control': 'no-store',
  });
  res.end(body);
}

function sendFile(req, res, full, attachment) {
  fs.stat(full, (err, stat) => {
    if (err || !stat.isFile()) {
      res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
      res.end('Not found');
      return;
    }

    const type = MIME[path.extname(full).toLowerCase()] || 'application/octet-stream';
    const headers = {
      'Content-Type': type,
      'Accept-Ranges': 'bytes',
      'Cache-Control': 'no-cache',
    };
    if (attachment) {
      const parent = path.basename(path.dirname(full));
      const safeName = `${parent}_${path.basename(full)}`.replace(/["\\\r\n]/g, '');
      headers['Content-Disposition'] = `attachment; filename="${safeName}"`;
    }

    const range = req.headers.range;
    if (range && /^bytes=\d*-\d*$/.test(range)) {
      let [startRaw, endRaw] = range.replace('bytes=', '').split('-');
      let start = startRaw === '' ? null : Number(startRaw);
      let end = endRaw === '' ? null : Number(endRaw);

      if (start === null && end !== null) {
        start = Math.max(stat.size - end, 0);
        end = stat.size - 1;
      } else {
        start = start ?? 0;
        end = end === null ? stat.size - 1 : Math.min(end, stat.size - 1);
      }

      if (start > end || start >= stat.size) {
        res.writeHead(416, { 'Content-Range': `bytes */${stat.size}` });
        res.end();
        return;
      }

      headers['Content-Range'] = `bytes ${start}-${end}/${stat.size}`;
      headers['Content-Length'] = end - start + 1;
      res.writeHead(206, headers);
      fs.createReadStream(full, { start, end }).pipe(res);
      return;
    }

    headers['Content-Length'] = stat.size;
    res.writeHead(200, headers);
    if (req.method === 'HEAD') {
      res.end();
      return;
    }
    fs.createReadStream(full).pipe(res);
  });
}

function servePublic(res, name) {
  const full = path.join(PUBLIC_DIR, name);
  fs.readFile(full, (err, buffer) => {
    if (err) {
      res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
      res.end('Not found');
      return;
    }
    res.writeHead(200, {
      'Content-Type': MIME[path.extname(name).toLowerCase()] || 'text/plain; charset=utf-8',
      'Content-Length': buffer.length,
      'Cache-Control': 'no-cache',
    });
    res.end(buffer);
  });
}

function handleMediaQuery(url, res) {
  const params = url.searchParams;
  const categoryKey = params.get('category') || 'video';
  const bucket = LIBRARY[categoryKey];
  if (!bucket) {
    json(res, 400, { error: 'Unknown category' });
    return;
  }

  const query = (params.get('q') || '').trim().toLowerCase();
  const items = query
    ? bucket.filter((item) => item.rel.toLowerCase().includes(query))
    : bucket;

  const offset = Math.max(Number(params.get('offset') || 0) || 0, 0);
  const limit = Math.min(Math.max(Number(params.get('limit') || 60) || 60, 1), 200);
  const page = items.slice(offset, offset + limit);

  json(res, 200, {
    category: categoryKey,
    counts: COUNTS,
    total: items.length,
    offset,
    limit,
    items: page.map((item) => ({
      ...item,
      url: fileUrl(item.rel),
      downloadUrl: downloadUrl(item.rel),
    })),
  });
}

const server = http.createServer((req, res) => {
  const url = new URL(req.url, 'http://localhost');

  if (req.method !== 'GET' && req.method !== 'HEAD') {
    res.writeHead(405, { Allow: 'GET, HEAD' });
    res.end();
    return;
  }

  const pathname = url.pathname;

  if (pathname === '/') return servePublic(res, 'index.html');
  if (pathname === '/app.js') return servePublic(res, 'app.js');
  if (pathname === '/styles.css') return servePublic(res, 'styles.css');
  if (pathname === '/stock') return servePublic(res, 'stock.html');
  if (pathname === '/stock.js') return servePublic(res, 'stock.js');
  if (pathname === '/api/media') return handleMediaQuery(url, res);
  if (pathname.startsWith('/api/stock/')) {
    stock.handle(req, res, pathname, url).catch(() => {
      if (!res.headersSent) res.writeHead(500).end();
    });
    return;
  }

  if (pathname.startsWith('/media/') || pathname.startsWith('/download/')) {
    const attachment = pathname.startsWith('/download/');
    const relPath = pathname.replace(attachment ? '/download/' : '/media/', '');
    const full = resolveInside(relPath);
    if (!full) {
      res.writeHead(403, { 'Content-Type': 'text/plain; charset=utf-8' });
      res.end('Forbidden');
      return;
    }
    return sendFile(req, res, full, attachment);
  }

  res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
  res.end('Not found');
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`media dashboard on http://0.0.0.0:${PORT} (root: ${ROOT})`);
  console.log(`videos: ${COUNTS.video}, music: ${COUNTS.music}, images: ${COUNTS.image}`);
});
