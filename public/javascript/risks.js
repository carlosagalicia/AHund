function toggleRisksList() {
  actions.TOGGLE(RISKS.RISK_LIST_TOGGLE, "collapse"); // Toggle collapse class on risk list button
  actions.TOGGLE(RISKS.RISKS_LIST_CONTAINER, "hide"); // Toggle hide class on risks list
  actions.TOGGLE(RISKS.RISK_DESCRIPTION_CONTAINER, "collapse"); // Toggle collapse class on risk content
}

function showRisk(IDRiesgo) {
  fetch(`/risks/risk-info?id=${IDRiesgo}`)
    .then((response) => response.text())
    .then((html) => {
      RISKS.RISK_DESCRIPTION_CONTAINER.innerHTML = html;
      if (window.innerWidth <= 880) {
        toggleRisksList();
      }
    })
    .catch((error) => console.error("Error:", error));
}

function editRisk(IDRiesgo) {
  fetch(`/risks/edit-risk?id=${IDRiesgo}`)
    .then((response) => response.text())
    .then((html) => {
      RISKS.RISK_DESCRIPTION_CONTAINER.innerHTML = html;
      setupCharacterCount();
    })
    .catch((error) => console.error("Error:", error));
}

document.addEventListener("DOMContentLoaded", function () {
  const addRiskButton = document.querySelector(".add-new-risk button");
  if (addRiskButton) {
    addRiskButton.addEventListener("click", displayAddRiskForm);
  }
});

async function displayAddRiskForm(event) {
  fetch("/risks/add-risk")
    .then((response) => response.text())
    .then((html) => {
      RISKS.RISK_DESCRIPTION_CONTAINER.innerHTML = html;
      setupCharacterCount();
    })
    .catch((error) => console.error("Error:", error));
}

function setupCharacterCount() {
  const descripcionInput = document.getElementById("descripcion");
  const charCount = document.getElementById("charCount");

  if (descripcionInput && charCount) {
    descripcionInput.addEventListener("input", function () {
      const remaining = 512 - descripcionInput.value.length;
      charCount.textContent = remaining;
    });
  }
}

function validateRiskForm() {
  const form = document.getElementById("riskForm");
  const nombreRiesgo = document.getElementById("nombreRiesgo");
  const descripcion = document.getElementById("descripcion");
  const tipo = document.getElementById("tipo");

  if (!nombreRiesgo.value || !descripcion.value || !tipo.value) {
    alert("Todos los campos son requeridos.");
    return;
  } else if (descripcion.value.length > 512) {
    alert("La descripción no puede exceder los 512 caracteres.");
    return;
  } else if (nombreRiesgo.value.length > 80) {
    alert("El nombre del riesgo no puede exceder los 80 caracteres.");
    return;
  } else if (tipo.value.length > 32) {
    alert("El tipo de riesgo no puede exceder los 32 caracteres.");
    return;
  }

  form.submit();
}
