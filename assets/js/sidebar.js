document.addEventListener('DOMContentLoaded', function() {
  var directories = document.querySelectorAll('.directory');

  directories.forEach(function(directory) {
    var submenu = directory.nextElementSibling;

    // Initial setup: collapse all submenus
    submenu.style.display = 'none';

    // Add click event listener to each directory
    directory.addEventListener('click', function(event) {
      event.preventDefault();
      submenu.style.display = submenu.style.display === 'none' ? 'block' : 'none';
    });
  });

  // Expand current directory (and its parents, if any)
  var currentLink = document.querySelector(`a[href="${window.location.pathname}"]`);
  var currentDirectory = currentLink.closest('.directory');
  while (currentDirectory) {
    currentDirectory.nextElementSibling.style.display = 'block';
    currentDirectory = currentDirectory.parentElement.closest('.directory');
  }
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

  toggleButton.addEventListener('touchstart', function(e) {
    isTouchDevice = true;
    toggleSidebarAndAnimateButton();
    e.preventDefault(); // Prevents the click event from firing
  });
});