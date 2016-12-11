let req;

const errorMessage = '<div class="notification is-danger has-margin-bottom">Sorry, something went wrong generating your preview</div>'

export class PreviewPost {
  constructor(previewTab, previewContainer, writeTab, form) {
    this.previewTab = previewTab;
    this.previewContainer = previewContainer;
    this.writeTab = writeTab;
    this.form = form;
  }

  listen() {
    if (!this.previewTab) { return; }

    this.previewTab.addEventListener('click', (e) => {
      e.preventDefault();
      req = new XMLHttpRequest();
      const data = new FormData(this.form);
      req.onreadystatechange = this.loadPreview();
      req.open('POST', '/admin/post-preview', true);
      req.send(data);
    });
    this.previewContainer.addEventListener('click', e => e.preventDefault());
    this.writeTab.addEventListener('click', () => {
      this.toggleTabs();
    });
  }

  toggleTabs() {
    this.previewTab.parentNode.classList.toggle('is-active');
    this.writeTab.parentNode.classList.toggle('is-active');
    this.previewContainer.classList.toggle('is-hidden');
    this.form.classList.toggle('is-hidden');
  }

  loadPreview() {
    return () => {
      if (req.readyState !== XMLHttpRequest.DONE) { return; }
      let response;
      if (req.status === 200) {
        response = req.responseText;
      } else {
        response = errorMessage;
      }
      this.previewContainer.innerHTML = response;
      this.toggleTabs();
    }
  }
}

export default function init() {
  const previewTab = document.getElementById('preview-tab');
  const writeTab = document.getElementById('write-tab');
  const previewContainer = document.getElementById('preview-container')
  const form = document.getElementById('post-form');
  new PreviewPost(previewTab, previewContainer, writeTab, form).listen();
}
