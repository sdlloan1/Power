'use strict';

const formEl = document.getElementById('search-form');
const queryEl = document.getElementById('query');
const gridEl = document.getElementById('stock-grid');
const resultEl = document.getElementById('stock-result');
const emptyEl = document.getElementById('stock-empty');
const pagerEl = document.getElementById('pager');
const pageLabelEl = document.getElementById('page-label');
const prevEl = document.getElementById('prev-page');
const nextEl = document.getElementById('next-page');
const setupEl = document.getElementById('setup-panel');

const state = {
  query: '',
  page: 1,
  perPage: 24,
  totalHits: 0,
  hits: [],
  loading: false,
  configured: true,
};
const QUALITY_LABELS = { large: 'Large', medium: 'Medium', small: 'Small', tiny: 'Tiny' };

function formatDuration(seconds) {
  const total = Math.round(seconds || 0);
  const mins = Math.floor(total / 60);
  const secs = total % 60;
  return `${mins}:${String(secs).padStart(2, '0')}`;
}

function buildCard(hit) {
  const card = document.createElement('article');
  card.className = 'card';

  const preview = document.createElement('div');
  preview.className = 'preview';
  const video = document.createElement('video');
  video.src = hit.preview;
  video.poster = hit.thumbnail;
  video.controls = true;
  video.preload = 'none';
  video.muted = true;
  video.playsInline = true;
  preview.append(video);

  const body = document.createElement('div');
  body.className = 'card-body';

  const name = document.createElement('div');
  name.className = 'name';
  name.textContent = hit.tags || `Video ${hit.id}`;

  const meta = document.createElement('div');
  meta.className = 'meta';
  meta.textContent = `by ${hit.user} · ${formatDuration(hit.duration)}`;

  const foot = document.createElement('div');
  foot.className = 'card-foot';

  const durations = document.createElement('span');
  durations.className = 'size';
  durations.textContent = 'Download:';

  const buttons = document.createElement('div');
  buttons.className = 'quality-row';

  const ordered = ['large', 'medium', 'small', 'tiny']
    .map((key) => hit.sizes.find((size) => size.key === key))
    .filter(Boolean);

  for (const size of ordered) {
    const link = document.createElement('a');
    link.className = 'download';
    link.href = `/api/stock/download?url=${encodeURIComponent(size.url)}&quality=${size.key}&id=${hit.id}`;
    link.setAttribute('download', '');
    link.textContent = QUALITY_LABELS[size.key] || size.key;
    link.title = `${size.width}×${size.height}`;
    buttons.append(link);
  }

  foot.append(durations, buttons);
  body.append(name, meta, foot);
  card.append(preview, body);
  return card;
}

function updatePager() {
  const pages = Math.max(Math.ceil(state.totalHits / state.perPage), 1);
  pagerEl.hidden = state.totalHits === 0;
  pageLabelEl.textContent = `Page ${state.page} of ${pages}`;
  prevEl.disabled = state.page <= 1;
  nextEl.disabled = state.page >= pages;
}

function render() {
  gridEl.replaceChildren(...state.hits.map(buildCard));
  emptyEl.hidden = !(state.configured && state.hits.length === 0 && !state.loading && state.query !== '');
  updatePager();
}

async function search(page) {
  if (state.loading) return;
  state.loading = true;
  state.query = queryEl.value.trim();
  state.page = page || 1;

  resultEl.textContent = state.query ? 'Searching…' : '';
  emptyEl.hidden = true;

  const params = new URLSearchParams({ q: state.query, page: String(state.page) });

  try {
    const response = await fetch(`/api/stock/search?${params}`);
    const data = await response.json();

    state.configured = data.configured !== false;
    setupEl.hidden = state.configured;
    state.perPage = data.perPage || 24;

    if (data.configured === false) {
      gridEl.replaceChildren();
      pagerEl.hidden = true;
      resultEl.textContent = '';
      emptyEl.hidden = true;
      return;
    }

    if (data.error) {
      resultEl.textContent = data.error;
      gridEl.replaceChildren();
      emptyEl.hidden = true;
      pagerEl.hidden = true;
      return;
    }

    state.totalHits = data.totalHits || 0;
    state.hits = data.hits || [];
    resultEl.textContent = state.query
      ? `${state.totalHits.toLocaleString()} videos for “${state.query}”`
      : 'Type a keyword to search the catalogue.';
    render();
  } catch (error) {
    resultEl.textContent = 'Could not load results. Check the server logs.';
    console.error(error);
  } finally {
    state.loading = false;
    emptyEl.hidden = !(state.configured && state.hits.length === 0 && state.query !== '');
  }
}

formEl.addEventListener('submit', (event) => {
  event.preventDefault();
  search(1);
});

prevEl.addEventListener('click', () => search(state.page - 1));
nextEl.addEventListener('click', () => search(state.page + 1));

search(1);
