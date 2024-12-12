// Function to handle toggling of collapsed navigation
function handleToggleCollapsedNav() {
  actions.TOGGLE(NAV_CONSTANTS.COLLAPSED_NAV, "collapse");
  toggleCollapsedToggleClass();
}

// Function to handle window resize event
function handleWindowResize() {
  if (window.innerWidth > 780) {
    // If window width is greater than 780 pixels
    // Reset classes for NAV_CONSTANTS to their default state
    actions.REMOVE(NAV_CONSTANTS.COLLAPSED_NAV, "collapse");
    actions.REMOVE(NAV_CONSTANTS.MAIN, "collapsed");
    actions.ADD(NAV_CONSTANTS.SIDEBAR, "collapsed");
    actions.ADD(NAV_CONSTANTS.TOPBAR, "collapsed");
    actions.REMOVE(NAV_CONSTANTS.COLLAPSED_TOGGLE, "fa-minus");
    actions.ADD(NAV_CONSTANTS.COLLAPSED_TOGGLE, "fa-plus");
  }
}

// Function to toggle the CSS class of the collapsed toggle button
function toggleCollapsedToggleClass() {
  if (NAV_CONSTANTS.COLLAPSED_TOGGLE.classList.contains("fa-plus")) {
    actions.REMOVE(NAV_CONSTANTS.COLLAPSED_TOGGLE, "fa-plus");
    actions.ADD(NAV_CONSTANTS.COLLAPSED_TOGGLE, "fa-minus");
  } else {
    actions.REMOVE(NAV_CONSTANTS.COLLAPSED_TOGGLE, "fa-minus");
    actions.ADD(NAV_CONSTANTS.COLLAPSED_TOGGLE, "fa-plus");
  }
}

// Event listener for window resize event
window.addEventListener("resize", handleWindowResize);
