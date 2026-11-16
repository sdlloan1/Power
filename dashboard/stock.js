'use strict';

const { Readable } = require('node:stream');

const PIXABAY_KEY = process.env.PIXABAY_API_KEY || '';
const PIXABAY_VIDEO_ENDPOINT = 'https://pixabay.com/api/videos/';
const ALLOWED_DOWNLOAD_HOSTS = new Set(['cdn.pixabay.com']);
const PER_PAGE = 24;

function sendJson(res, status, payload) {
  const body = JSON.stringify(payload);
  res.writeHead(status, {
    'Content-Type': 'application/json; charset=utf-8',
    'Content-Length': Buffer.byteLength(body),
    'Cache-Control': 'no-store',
  });
  res.end(body);
}

function mapHit(hit) {
  const sizes = Object.entries(hit.videos || {})
    .filter(([, variant]) => variant && variant.url)
    .map(([key, variant]) => ({
      key,
      url: variant.url,
      width: variant.width,
      height: variant.height,
      size: variant.size,
    }));

  const preview = hit.videos?.small || hit.videos?.medium || hit.videos?.tiny;

  return {
    id: hit.id,
    tags: hit.tags,
    duration: hit.duration,
    user: hit.user,
    pageURL: hit.pageURL,
    thumbnail: preview?.thumbnail || '',
    preview: preview?.url || '',
    sizes,
  };
}

async function search(params, res) {
  const query = (params.get('q') || '').trim();
  const page = Math.max(Number(params.get('page') || 1) || 1, 1);

  if (!PIXABAY_KEY) {
    sendJson(res, 200, { configured: false, query, page, totalHits: 0, hits: [] });
    return;
  }
  if (!query) {
    sendJson(res, 200, { configured: true, query, page, totalHits: 0, hits: [] });
    return;
  }

  const upstream = new URL(PIXABAY_VIDEO_ENDPOINT);
  upstream.searchParams.set('key', PIXABAY_KEY);
  upstream.searchParams.set('q', query);
  upstream.searchParams.set('page', String(page));
  upstream.searchParams.set('per_page', String(PER_PAGE));
  upstream.searchParams.set('safesearch', 'true');

  try {
    const response = await fetch(upstream, { headers: { Accept: 'application/json' } });
    const payload = await response.json().catch(() => null);

    if (!response.ok || !payload) {
      sendJson(res, 200, {
        configured: true,
        query,
        page,
        totalHits: 0,
        error: payload?.message || `Pixabay responded with ${response.status}`,
        hits: [],
      });
      return;
    }

    sendJson(res, 200, {
      configured: true,
      query,
      page,
      perPage: PER_PAGE,
      totalHits: payload.totalHits || 0,
      hits: (payload.hits || []).map(mapHit),
    });
  } catch (error) {
    sendJson(res, 502, {
      configured: true,
      query,
      page,
      totalHits: 0,
      error: 'Could not reach Pixabay.',
      hits: [],
    });
  }
}

async function download(params, res) {
  const rawUrl = params.get('url') || '';
  const quality = (params.get('quality') || 'file').replace(/[^a-z0-9-]/gi, '');
  const id = (params.get('id') || 'video').replace(/[^a-z0-9-]/gi, '');

  let target;
  try {
    target = new URL(rawUrl);
  } catch {
    sendJson(res, 400, { error: 'Invalid download url' });
    return;
  }

  if (target.protocol !== 'https:' || !ALLOWED_DOWNLOAD_HOSTS.has(target.hostname)) {
    sendJson(res, 403, { error: 'Only Pixabay media can be downloaded here' });
    return;
  }

  try {
    const upstream = await fetch(target);
    if (!upstream.ok || !upstream.body) {
      sendJson(res, 502, { error: `Download failed with ${upstream.status}` });
      return;
    }

    const headers = {
      'Content-Type': upstream.headers.get('content-type') || 'video/mp4',
      'Content-Disposition': `attachment; filename="pixabay-${id}-${quality}.mp4"`,
      'Cache-Control': 'no-store',
    };
    const length = upstream.headers.get('content-length');
    if (length) headers['Content-Length'] = length;

    res.writeHead(200, headers);
    Readable.fromWeb(upstream.body).pipe(res);
  } catch {
    if (!res.headersSent) sendJson(res, 502, { error: 'Download failed' });
    else res.end();
  }
}

async function handle(req, res, pathname, url) {
  if (pathname === '/api/stock/search') {
    await search(url.searchParams, res);
    return;
  }
  if (pathname === '/api/stock/download') {
    await download(url.searchParams, res);
    return;
  }
  sendJson(res, 404, { error: 'Not found' });
}

module.exports = { handle, isConfigured: () => Boolean(PIXABAY_KEY) };
