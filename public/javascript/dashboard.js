document.addEventListener("DOMContentLoaded", function () {
  showProjectList();
  showDissimilarList();
  showAssociatedrList();
});

function showProjectList() {
  fetch(`/dashboard/project-list`)
    .then((response) => response.text())
    .then((html) => {
      document.getElementById("project-list").innerHTML = html;
    })
    .catch((error) => console.error("Error:", error));
}

function showMoreProjects(pageNumber) {
  fetch(`/dashboard/project-list?page=${parseInt(pageNumber)}`)
    .then((response) => response.text())
    .then((html) => {
      document.getElementById("project-list").innerHTML = html;
    })
    .catch((error) => console.error("Error:", error));
}

function showDissimilarList() {
  fetch(`/dashboard/dissimilar-list`)
    .then((response) => response.text())
    .then((html) => {
      document.getElementById("dissimilar-list").innerHTML = html;
    })
    .catch((error) => console.error("Error:", error));
}

function showAssociatedrList() {
  fetch(`/dashboard/associated-list`)
    .then((response) => response.text())
    .then((html) => {
      document.getElementById("associated-list").innerHTML = html;
    })
    .catch((error) => console.error("Error:", error));
}

function validateAssociateRiskForm(IDRiesgo) {
  const form = document.getElementById(`associateForm${IDRiesgo}`);
  const medidas = document.getElementById(`medidas${IDRiesgo}`);
  const ponderacion = document.getElementById(`ponderacion${IDRiesgo}`);

  if (!medidas.value || !ponderacion.value) {
    alert("Todos los campos son requeridos.");
    return;
  } else if (medidas.value.length > 512) {
    alert("Las meididas no puede exceder los 512 caracteres.");
    return;
  } else if (isNaN(ponderacion.value)) {
    alert("La ponderacion solo puede contener numeros");
    return;
  } else if (ponderacion.value > 100 || ponderacion.value < 0) {
    alert("La ponderacion solo puede estar en un rango de 100");
    return;
  }

  form.submit();
}

function validateEditRiskForm(IDRiesgo) {
  const form = document.getElementById(`editForm${IDRiesgo}`);
  const medidas = document.getElementById(`editMedidas${IDRiesgo}`);
  const ponderacion = document.getElementById(`editPonderacion${IDRiesgo}`);

  if (!medidas.value || !ponderacion.value) {
    alert("Todos los campos son requeridos.");
    return;
  } else if (medidas.value.length > 512) {
    alert("Las meididas no puede exceder los 512 caracteres.");
    return;
  } else if (isNaN(ponderacion.value)) {
    alert("La ponderacion solo puede contener numeros");
    return;
  } else if (ponderacion.value > 100 || ponderacion.value < 0) {
    alert("La ponderacion solo puede estar en un rango de 100");
    return;
  }

  form.submit();
}

