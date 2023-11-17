// automatic collapse and expand of the sidebar based on location
document.addEventListener('DOMContentLoaded', function() {

  var directories = document.querySelectorAll('li[data-issection="1"]');

  directories.forEach(function(directory) {
    var submenu = directory.querySelector('ul');

    // Add click event listener to each directory
    directory.addEventListener('click', function(event) {
      // Check if the clicked target is a descendant of the directory but not a link in the submenu
      if (!event.target.closest('ul') && event.target !== directory.querySelector('a')) {
        event.preventDefault();
        submenu.style.display = submenu.style.display === 'none' ? 'block' : 'none';
        if (submenu.style.display === 'none') {
          directory.classList.remove('expanded');
        } else {
          directory.classList.add('expanded');
        }
      }
    });
  });

  // Expand current directory (and its parents, if any)
  var currentLink = document.querySelector(`a[href="${window.location.pathname}"]`);
  console.log('current link:', currentLink ? currentLink.getAttribute('href') : 'not found');

  var currentDirectory = currentLink ? currentLink.closest('li[data-issection="1"]') : null;
  console.log('current directory:', currentDirectory ? currentDirectory.querySelector('a').getAttribute('href') : 'not found');

  while (currentDirectory) {
    var submenu = currentDirectory.querySelector('ul');

    // Only proceed if submenu is not null
    if (submenu) {
      console.log('expanding directory:', currentDirectory.querySelector('a').getAttribute('href'));
      submenu.style.display = 'block';
      currentDirectory.classList.add('expanded');
      console.log('directory expanded:', currentDirectory.querySelector('a').getAttribute('href'));
    }

    currentDirectory = currentDirectory.parentElement.closest('li[data-issection="1"]');
    console.log('moving to parent directory:', currentDirectory ? currentDirectory.querySelector('a').getAttribute('href') : 'none');
  }
});

document.querySelectorAll('a.direct-page').forEach(function(link) {
  link.addEventListener('click', function(event) {
    // Allow the default action
  });
});



document.addEventListener('DOMContentLoaded', function() {

  var sidebar = document.getElementById('sidebar');
  var toggleButton = document.getElementById('sidebar-toggle');
  var isTouchDevice = false;

  function toggleSidebarAndAnimateButton() {
    // Toggle the sidebar visibility
    sidebar.classList.toggle('visible');

    // Add spin animation and remove after animation completes
    toggleButton.classList.add('spin');
    setTimeout(function() {
      toggleButton.classList.remove('spin');
    }, 300); // 300ms to match the duration of the spin animation
  }

  toggleButton.addEventListener('click', function(e) {
    // if (!isTouchDevice) {
      toggleSidebarAndAnimateButton();
    // }
  });

  // toggleButton.addEventListener('touchstart', function(e) {
  //   isTouchDevice = true;
  //   toggleSidebarAndAnimateButton();
  //   e.preventDefault(); // Prevents the click event from firing
  // });
  toggleButton.addEventListener('touchstart', function(e) {
    isTouchDevice = true;
    toggleSidebarAndAnimateButton();
  }, { passive: true });

});