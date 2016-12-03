import assert from 'assert';
import { fakeHtmlNode } from './mocks';

import { deleteButton, navToggle } from '../../web/static/js/bulma-interaction';

describe('deleteButton', () => {
  it('removes its parent when clicked', () => {
    const del = fakeHtmlNode(3);
    deleteButton([del]);
    del.trigger('click');
    assert.equal(del.parentNode.child, null);
  });
});

describe('navToggle', () => {
  it('toggles is-active on the nav', () => {
    const toggle = fakeHtmlNode();
    navToggle([toggle]);
    toggle.trigger('click');
    assert.ok(toggle.classList.includes('is-active'));
    assert.ok(toggle.parentNode.querySelector('.nav-menu').classList.includes('is-active'));
    toggle.trigger('click');
    assert.ok(!toggle.classList.includes('is-active'));
    assert.ok(!toggle.parentNode.querySelector('.nav-menu').classList.includes('is-active'));
  });
});
