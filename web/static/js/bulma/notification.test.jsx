import React from 'react';
import {shallow} from 'enzyme';
import Notification from './notification';

it('displays content with right class', () => {
  const notification = shallow(
    <Notification notificationClass="is-info" content="Flash message!" />,
  );

  expect(notification.html()).toMatch('is-info');
  expect(notification.text()).toEqual('Flash message!');
});

it('removes itself on delete click', () => {
  const notification = shallow(
    <Notification notificationClass="is-info" content="Flash message!" />,
  );
  notification.find('.delete').simulate('click');
  expect(notification.html()).toBeNull();
});
