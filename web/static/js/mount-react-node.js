import React from 'react';
import ReactDOM from 'react-dom';

import Notification from './bulma/notification.jsx';
import PostForm from './post-form.jsx';

const nodeMapping = {
	Notification,
  PostForm,
};

export default function init() {
  const nodes = document.querySelectorAll('[data-react]');
  for (let i = 0; i < nodes.length; i++) {
    mountNode(nodes[i]);
  }
}

function mountNode(node) {
  const Component = nodeMapping[node.dataset.component];
  const props = JSON.parse(node.dataset.props) || {};
  ReactDOM.render(<Component {...props} />, node);
}
