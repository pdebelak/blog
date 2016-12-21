export function navToggle(toggles) {
  for (let i = 0; i < toggles.length; i++) {
    const toggle = toggles[i];
    toggle.addEventListener('click', () => {
      const menu = toggle.parentNode.querySelector('.nav-menu');
      toggle.classList.toggle('is-active');
      menu.classList.toggle('is-active');
    });
  }
}

export default function init() {
  const toggles = document.querySelectorAll('.nav-toggle');
  navToggle(toggles);
}
