import assert from 'assert';
import { fakeHtmlNode } from './mocks';

import { PreviewPost } from '../../web/static/js/preview-post';

describe('toggleTabs', () => {
  it('toggles hidden and is-active', () => {
    const previewTab = fakeHtmlNode();
    const writeTab = fakeHtmlNode();
    const previewContainer = fakeHtmlNode();
    const form = fakeHtmlNode();
    writeTab.parentNode.classList.toggle('is-active');
    previewContainer.classList.toggle('is-hidden');
    const previewPost = new PreviewPost(previewTab, previewContainer, writeTab, form);
    previewPost.toggleTabs();
    assert.ok(previewTab.parentNode.classList.includes('is-active'));
    assert.ok(!writeTab.parentNode.classList.includes('is-active'));
    assert.ok(form.classList.includes('is-hidden'));
    assert.ok(!previewContainer.classList.includes('is-hidden'));
  });
});
