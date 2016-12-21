export default function request(url, options = { method: 'GET' }) {
  return new Promise((resolve, reject) => {
    const xhr = new XMLHttpRequest();
    xhr.open(options.method, url);
    if (options.contentType) {
      xhr.setRequestHeader('Content-Type', options.contentType);
    }
    xhr.onload = function() {
      if (this.status >= 200 && this.status < 300) {
        resolve(xhr.response);
      } else {
        requestError(this, xhr, reject);
      }
    };
    xhr.onerror = function() { requestError(this, xhr, reject); }
    xhr.send(options.data);
  });
}

function requestError(obj, xhr, reject) {
  reject({
    status: obj.status,
    statusText: xhr.statusText,
  });
}

export function postForm(url, form) {
  return request(url, {
    method: 'POST',
    data: new FormData(form),
  });
}
