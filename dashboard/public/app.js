'use strict';

const TABS = [
  { key: 'video', label: 'Videos' },
  { key: 'music', label: 'Music' },
  { key: 'image', label: 'Images' },
];

const PAGE_SIZE = 60;

const state = {
  category: 'video',
  query: '',
  offset: 0,
  items: [],
  total: 0,
  counts: {},
  loading: false,
};

const tabsEl = document.getElementById('tabs');
const searchEl = document.getElementById('search');
const gridEl = document.getElementById('grid');
const resultLineEl = document.getElementById('result-line');
const emptyEl = document.getElementById('empty');
const moreEl = document.getElementById('more');

function formatSize(bytes) {
  if (bytes < 1024) return `${bytes} B`;
  const units = ['KB', 'MB', 'GB'];
  let value = bytes / 1024;
  let unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit += 1;
  }
  return `${value < 10 ? value.toFixed(1) : Math.round(value)} ${units[unit]}`;
}

function renderTabs() {
  tabsEl.replaceChildren(
    ...TABS.map((tab) => {
      const button = document.createElement('button');
      button.type = 'button';
      button.className = 'tab';
      button.setAttribute('role', 'tab');
      button.setAttribute('aria-selected', String(tab.key === state.category));
      button.append(tab.label);

      const count = document.createElement('span');
      count.className = 'count';
      count.textContent = state.counts[tab.key] ? String(state.counts[tab.key]) : '';
      button.append(count);

      button.addEventListener('click', () => {
        if (state.category === tab.key) return;
        state.category = tab.key;
        state.query = '';
        searchEl.value = '';
        renderTabs();
        reload();
      });

      return button;
    }),
  );
}

function buildPreview(item) {
  const wrap = document.createElement('div');
  wrap.className = 'preview';

  if (state.category === 'video') {
    const video = document.createElement('video');
    video.src = item.url;
    video.controls = true;
    video.preload = 'metadata';
    video.playsInline = true;
    wrap.append(video);
    return wrap;
  }

  if (state.category === 'music') {
    const audio = document.createElement('audio');
    audio.src = item.url;
    audio.controls = true;
    audio.preload = 'metadata';
    wrap.append(audio);
    return wrap;
  }

  const img = document.createElement('img');
  img.src = item.url;
  img.alt = item.name;
  img.loading = 'lazy';
  wrap.append(img);
  return wrap;
}

function buildCard(item) {
  const card = document.createElement('article');
  card.className = 'card';

  const body = document.createElement('div');
  body.className = 'card-body';

  const name = document.createElement('div');
  name.className = 'name';
  name.textContent = item.name;

  const meta = document.createElement('div');
  meta.className = 'meta';
  meta.textContent = item.rel;

  const foot = document.createElement('div');
  foot.className = 'card-foot';

  const size = document.createElement('span');
  size.className = 'size';
  size.textContent = formatSize(item.size);

  const link = document.createElement('a');
  link.className = 'download';
  link.href = item.downloadUrl;
  link.setAttribute('download', `${item.name}`);
  link.textContent = 'Download';

  foot.append(size, link);
  body.append(name, meta, foot);
  card.append(buildPreview(item), body);
  return card;
}

function updateResultLine() {
  if (state.loading && state.items.length === 0) {
    resultLineEl.textContent = 'Loading…';
    return;
  }
  const shown = state.items.length;
  const label = TABS.find((tab) => tab.key === state.category)?.label ?? 'files';
  const filter = state.query ? ` matching “${state.query}”` : '';
  resultLineEl.textContent = `${shown} of ${state.total} ${label.toLowerCase()}${filter}`;
}

function renderItems(reset) {
  if (reset) gridEl.replaceChildren();
  const fragment = document.createDocumentFragment();
  const start = reset ? 0 : gridEl.childElementCount;
  for (let i = start; i < state.items.length; i += 1) {
    fragment.append(buildCard(state.items[i]));
  }
  gridEl.append(fragment);
  emptyEl.hidden = !(state.items.length === 0 && !state.loading);
  moreEl.hidden = state.items.length >= state.total;
  updateResultLine();
}

async function load(reset) {
  if (state.loading) return;
  state.loading = true;
  if (reset) state.offset = 0;
  updateResultLine();

  const params = new URLSearchParams({
    category: state.category,
    q: state.query,
    offset: String(state.offset),
    limit: String(PAGE_SIZE),
  });

  try {
    const response = await fetch(`/api/media?${params}`);
    if (!response.ok) throw new Error(`request failed: ${response.status}`);
    const data = await response.json();

    state.counts = data.counts || state.counts;
    state.total = data.total;
    state.items = reset ? data.items : state.items.concat(data.items);
    state.offset = data.offset + data.items.length;

    renderTabs();
    renderItems(reset);
  } catch (error) {
    resultLineEl.textContent = 'Could not load the library. Check the server logs and reload.';
    console.error(error);
  } finally {
    state.loading = false;
    moreEl.hidden = state.items.length >= state.total;
    emptyEl.hidden = !(state.items.length === 0 && state.total === 0);
  }
}

function reload() {
  state.items = [];
  state.total = 0;
  return load(true);
}

let searchTimer;
searchEl.addEventListener('input', () => {
  clearTimeout(searchTimer);
  searchTimer = setTimeout(() => {
    state.query = searchEl.value.trim();
    reload();
  }, 250);
});

moreEl.addEventListener('click', () => load(false));

renderTabs();
reload();
