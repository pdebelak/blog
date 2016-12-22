import React from 'react';
import {shallow} from 'enzyme';

import Tab from '../../../web/static/js/post-form/tab';

describe('when not active', () => {
  it('doesn\'t have is-active class', () => {
    const tab = shallow(
      <Tab active="hello" name="goodbye" tabClicked={() => {}} />,
    );
    expect(tab.html()).not.toMatch('is-active');
  });
});

describe('when active', () => {
  it('has the is-active class', () => {
    const tab = shallow(
      <Tab active="goodbye" name="goodbye" tabClicked={() => {}} />,
    );
    expect(tab.html()).toMatch('is-active');
  });
});
