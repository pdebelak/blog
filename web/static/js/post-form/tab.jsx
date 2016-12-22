import React from 'react';

export default ({ active, name, tabClicked }) =>
  <li className={name === active ? 'is-active' : ''}>
    <a onClick={() => tabClicked(name)}>{name}</a>
  </li>;
