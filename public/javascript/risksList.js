// Function to toggle visibility of risks list elements
function toggleRisksList(idRiskListButton) {
  const { RISK_LIST_BUTTON, RISKS_LIST, RISK_CONTENT } =
    RISK_CONSTANTS(idRiskListButton); // Destructure elements from the returned object
  actions.TOGGLE(RISK_LIST_BUTTON, "collapse"); // Toggle collapse class on risk list button
  actions.TOGGLE(RISKS_LIST, "hide"); // Toggle hide class on risks list
  actions.TOGGLE(RISK_CONTENT, "collapse"); // Toggle collapse class on risk content
}
