// TODO: this isn't working likely due to not setting sibling
// document.addEventListener('DOMContentLoaded', (event) => {

//   const directories = document.querySelectorAll('.directory');
//   directories.forEach(directory => {
//     const subMenu = directory.nextElementSibling;
//     subMenu.style.display = 'none'; // Collapse all menus by default
//     directory.addEventListener('click', (event) => {
//       event.preventDefault();
//       subMenu.style.display = subMenu.style.display === 'none' ? 'block' : 'none';
//     });
//   });

//   // Expand current item and its parent directory
//   const currentPath = window.location.pathname;
//   const links = document.querySelectorAll('a');
//   links.forEach(link => {
//     const linkPath = new URL(link.href).pathname;
//     if (linkPath === currentPath) {
//       const parentSubMenu = link.closest('.sub-menu');
//       if (parentSubMenu) {
//         parentSubMenu.style.display = 'block'; // Expand parent submenu
//       }
//     }
//   });
// });