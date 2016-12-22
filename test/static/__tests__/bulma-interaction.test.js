import { navToggle } from '../../../web/static/js/bulma-interaction';

it('toggles is-active on the nav', () => {
  const toggle = document.createElement('div');
  const menu = document.createElement('div');
  menu.className = 'nav-menu';
  const container = document.createElement('div');
  container.appendChild(toggle);
  container.appendChild(menu);
  navToggle([toggle]);
  toggle.click();
  expect(toggle.className).toEqual('is-active');
  expect(menu.className).toEqual('nav-menu is-active');
  toggle.click();
  expect(toggle.className).toEqual('');
  expect(menu.className).toEqual('nav-menu');
});
