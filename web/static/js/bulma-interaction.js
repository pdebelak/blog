export function deleteButton(deletes) {
  for (let i = 0; i < deletes.length; i++) {
    deletes[i].addEventListener('click', () => {
      const parent = deletes[i].parentNode;
      parent.parentNode.removeChild(parent);
    });
  }
}

export function navToggle(toggles) {
  for (let i = 0; i < toggles.length; i++) {
    toggles[i].addEventListener('click', () => {
      const toggle = toggles[i];
      const menu = toggle.parentNode.querySelector('.nav-menu');
      toggle.classList.toggle('is-active');
      menu.classList.toggle('is-active');
    });
  }
}

export default function init() {
  const deletes = document.querySelectorAll('button.delete');
  deleteButton(deletes);

  const toggles = document.querySelectorAll('.nav-toggle');
  navToggle(toggles);
}
