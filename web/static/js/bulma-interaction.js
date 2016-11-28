function deleteButton() {
  const deletes = document.querySelectorAll('button.delete');

  for (let i = 0; i < deletes.length; i++) {
    deletes[i].addEventListener('click', () => {
      const parent = deletes[i].parentNode;
      parent.parentNode.removeChild(parent);
    });
  }
}

function navToggle() {
  const toggles = document.querySelectorAll('.nav-toggle');

  for (let i = 0; i < toggles.length; i++) {
    toggles[i].addEventListener('click', () => {
      const toggle = toggles[i];
      const menu = toggle.parentNode.querySelector('.nav-menu');
      toggle.classList.toggle('is-active');
      menu.classList.toggle('is-active');
    });
  }
}

deleteButton();
navToggle();
