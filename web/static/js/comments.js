const storageKey = 'comment_name';
export function setName(input, localStorage) {
  if (!input) { return; }
  const name = localStorage.getItem(storageKey);
  input.value = name || '';
}

export function saveName(form, input, localStorage) {
  if (!(form && input)) { return; }
  form.addEventListener('submit', () => {
    const name = input.value;
    localStorage.setItem(storageKey, name);
  });
}

export default function init() {
  const nameInput = document.getElementById('commenter_name');
  setName(nameInput, window.localStorage);
  const commentForm = document.getElementById('commenter_form');
  saveName(commentForm, nameInput, window.localStorage);
}
