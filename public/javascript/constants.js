// Define constant elements representing various DOM elements
const NAV_CONSTANTS = Object.freeze({
  SIDEBAR: document.querySelector(".sidebar"), // Sidebar element
  TOPBAR: document.querySelector(".topbar"), // Topbar element
  COLLAPSED_NAV: document.querySelector(".nav-collapsed"), // Collapsed navigation element
  MAIN: document.querySelector("main"), // Main content element
  NAV_LOGO: document.querySelector(".nav-logo"), // Navigation logo element
  COLLAPSED_TOGGLE: document.querySelector("#collapsed-nav-toggle"), // Toggle button for collapsed navigation
});

const DROPDOWN_CONSTANTS = Object.freeze(
  (dropdownContentId, iconElementId) => ({
    DROPDOWN_CONTENT: document.getElementById(dropdownContentId),
    ICON_ELEMENT: document.getElementById(iconElementId),
  })
);

const PROJECTS_CONSTANTS = Object.freeze({
  PROJECTS: document.querySelectorAll(".project-card"),
});

const RISK_LIST_CONSTANTS = Object.freeze((projectID) => ({
  RISK_LIST: document.getElementById(`risks-list${projectID}`),
}));

const MODAL_CONSTANTS = Object.freeze({
  MODAL: document.getElementById("confirmation-Modal"),
});

document.addEventListener('DOMContentLoaded', function() {
  const RISKS = Object.freeze({
    RISK_CONTAINER: document.querySelector(".risks-container"),
    RISK_DESCRIPTION_CONTAINER: document.querySelector(".risk-description-container"),
    RISKS_LIST_CONTAINER: document.querySelector(".risks-list-container"),
    RISK_LIST_TOGGLE: document.querySelector(".risks-list-toggle"),
  });

  // Expose RISKS to the global scope
  window.RISKS = RISKS;
});

