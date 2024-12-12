// Define constant actions representing different actions on DOM elements
const actions = Object.freeze({
  TOGGLE: function (element, attributeName) {
    // Function to toggle a CSS class on an element
    element.classList.toggle(attributeName);
  },
  ADD: function (element, attributeName) {
    // Function to add a CSS class to an element
    element.classList.add(attributeName);
  },
  REMOVE: function (element, attributeName) {
    // Function to remove a CSS class from an element
    element.classList.remove(attributeName);
  },
  GET_DATASET: function (element, attributeName) {
    return element.dataset[attributeName];
  },
  DISPLAY: function (element, attributeName) {
    element.style.display = attributeName;
  },
});
