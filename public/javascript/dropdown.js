// Function to toggle the dropdown
function toggleDropdown(dropdownContentId, iconElementId) {
  const { DROPDOWN_CONTENT, ICON_ELEMENT } = DROPDOWN_CONSTANTS(
    dropdownContentId,
    iconElementId
  ); // Destructure elements from the returned object
  actions.TOGGLE(DROPDOWN_CONTENT, "show");
  if (ICON_ELEMENT) {
    actions.TOGGLE(ICON_ELEMENT, "fa-caret-down");
  }
}
