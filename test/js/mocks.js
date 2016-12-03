export function fakeStorage() {
  return {
    store: {},
    getItem(key) {
      return this.store[key];
    },
    setItem(key, value) {
      this.store[key] = value;
    },
  };
}

function createClassList() {
  const classList = [];
  classList.toggle = function(className) {
    if (classList.includes(className)) {
      const index = classList.indexOf(className);
      classList.splice(index, 1);
    } else {
      classList.push(className);
    }
  }
  return classList;
}

// fakeHtmlNode is meant to act like an html node in a non-browser environment.
// It currently only supports the functions explicitly needed in the tests. It
// takes a depth parameter to know how many `parentNode`s to create.
export function fakeHtmlNode(depth = 2) {
  if (depth === 0) { return; }

  return {
    child: 'value',
    classList: createClassList(),
    removeChild(node) {
      node.child = null;
    },
    parentNode: fakeHtmlNode(depth - 1),
    callbacks: {},
    addEventListener(event, callback) {
      this.callbacks[event] = callback;
    },
    trigger(event) {
      if (this.callbacks[event]) {
        this.callbacks[event]();
      }
    },
    queried: {},
    querySelector(selector) {
      if (this.queried[selector]) {
        return this.queried[selector];
      }
      this.queried[selector] = fakeHtmlNode();
      return this.queried[selector];
    },
  };
}
