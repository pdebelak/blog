import React from 'react';
import {shallow} from 'enzyme';

import Modal from './modal';

it('closes when close button is clicked', () => {
  let closeCalled = false;
  const modal = shallow(
    <Modal closeModal={() => { closeCalled = true; }} />,
  );
  modal.find('.modal-close').simulate('click');
  expect(closeCalled).toEqual(true);
});

it('closes when background is clicked', () => {
  let closeCalled = false;
  const modal = shallow(
    <Modal closeModal={() => { closeCalled = true; }} />,
  );
  modal.find('.modal-background').simulate('click');
  expect(closeCalled).toEqual(true);
});
