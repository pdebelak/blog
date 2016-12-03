import assert from 'assert';
import { fakeStorage, fakeHtmlNode } from './mocks';

import { setName, saveName, storageKey } from '../../web/static/js/comments';

describe('setName', () => {
  describe('when no input is passed', () => {
    it('does not blow up', () => {
      setName(null, fakeStorage());
    });
  });

  describe('when nothing is in storage', () => {
    it('sets input value to empty string', () => {
      const input = {};
      setName(input, fakeStorage());
      assert.equal(input.value, '');
    });
  });

  describe('when a value is in storage', () => {
    it('sets the input value to the storage value', () => {
      const storage = fakeStorage();
      storage.setItem(storageKey, 'value');
      const input = {};
      setName(input, storage);
      assert.equal(input.value, 'value');
    });
  });
});

describe('saveName', () => {
  describe('when form is not present', () => {
    it('does not blow up', () => {
      const input = {};
      saveName(null, input, fakeStorage());
    });
  });

  describe('when input is not present', () => {
    it('does not blow up when form is submitted', () => {
      const form = fakeHtmlNode();
      saveName(form, null, fakeStorage());
      form.trigger('submit');
    });
  });

  describe('when all are present', () => {
    it('saves the value of the input in storage', () => {
      const input = { value: 'value' };
      const form = fakeHtmlNode();
      const storage = fakeStorage();
      saveName(form, input, storage);
      form.trigger('submit');
      assert.equal(storage.getItem(storageKey), 'value');
    });
  });
});
