import React from 'react';

import Tab from './tab';

export default ({ active, tabNames, tabClicked }) =>
  <div className="tabs">
    <ul>
      <Tab active={active} name="Write" tabClicked={tabClicked} />
      <Tab active={active} name="Preview" tabClicked={tabClicked} />
    </ul>
  </div>;
