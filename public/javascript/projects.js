document.addEventListener("DOMContentLoaded", function () {
  PROJECTS_CONSTANTS.PROJECTS.forEach(function (project) {
    getRisks(actions.GET_DATASET(project, "id"));
    getClient(actions.GET_DATASET(project, "id"));
  });
});

function getRisks(IDProyecto) {
  fetch(`/project-risks?id=${IDProyecto}`)
    .then((response) => response.text())
    .then((html) => {
      document.getElementById(`risks-list${IDProyecto}`).innerHTML = html;
    })
    .catch((error) => console.error("Error:", error));
}

function getClient(IDProyecto) {
  fetch(`/client?id=${IDProyecto}`)
    .then((response) => response.text())
    .then((html) => {
      document.getElementById(`dropcontent${IDProyecto}`).innerHTML = html;
    })
    .catch((error) => console.error("Error:", error));
}

// Register project validation
function validateRegisterProjectForm() {
  var nombre_proyecto = document.getElementById("nombreProyecto").value;
  var tipo_proyecto = document.getElementById("tipoProyecto").value;
  var fecha_inicio = document.getElementById("fechaInicio").value;
  var fecha_final = document.getElementById("fechaFin").value;
  var nombre_cliente = document.getElementById("nombreCliente").value;
  var email_cliente = document.getElementById("emailCliente").value;
  var tel_cliente = document.getElementById("telefonoCliente").value;
  var descripcion_cliente = document.getElementById("descripcionCliente").value;

  var today = new Date().toISOString().split("T")[0];

  const options = { method: "GET" };

  fetch(
    `https://emailvalidation.abstractapi.com/v1/?api_key=5e36d2526cd6454f87c546fa668c66fd&email=${email_cliente}`,
    options
  )
    .then((response) => response.json())
    .then((response) => {
      if (!response.is_smtp_valid.value && !response.is_valid_format.value) {
        alert("El dominio del correo no es valido ");
        return false;
      }
    })
    .catch((err) => console.error(err));

  // project name length
  if (nombre_proyecto.length > 80) {
    alert("El nombre del proyecto no puede tener más de 80 caracteres");
    return false;
  }

  // date validation
  if (fecha_inicio > fecha_final) {
    alert("La fecha de inicio no puede ser mayor a la fecha de fin");
    return false;
  }

  // date not in the past
  if (fecha_inicio < today) {
    alert("La fecha de inicio no puede ser una fecha pasada");
    return false;
  }

  // client name length
  if (nombre_cliente.length > 64) {
    alert("El nombre del cliente es demasiado extenso! (max 64 caracteres)");
    return false;
  }

  // email length
  if (email_cliente.length > 255) {
    alert("El email no puede tener más de 255 caracteres");
    return false;
  }

  // phone number validation (only digits)
  var telefonoRegex = /^[0-9]+$/;
  if (!telefonoRegex.test(tel_cliente)) {
    alert("El número de teléfono solo debe contener números.");
    return false;
  }

  if (descripcion_cliente.length > 512) {
    alert("La descripción no puede sobrepasar los 512 caracteres");
    return false;
  }

  //required fields
  if (
    !nombre_proyecto ||
    !tipo_proyecto ||
    !fecha_inicio ||
    !fecha_final ||
    !nombre_cliente ||
    !email_cliente ||
    !descripcion_cliente
  ) {
    alert("Todos los campos son requeridos");
    return false;
  }

  return true;
}

// Edit project validation
function validateEditProjectForm() {
  var nombre_proyecto = document.getElementById("nombreProyecto").value;
  var tipo_proyecto = document.getElementById("tipoProyecto").value;
  var fecha_inicio = document.getElementById("fechaInicio").value;
  var fecha_final = document.getElementById("fechaFin").value;
  var nombre_cliente = document.getElementById("nombreCliente").value;
  var email_cliente = document.getElementById("emailCliente").value;
  var tel_cliente = document.getElementById("telefonoCliente").value;
  var descripcion_cliente = document.getElementById("descripcionCliente").value;

  var today = new Date().toISOString().split("T")[0];

  const options = { method: "GET" };

  fetch(
    `https://emailvalidation.abstractapi.com/v1/?api_key=5e36d2526cd6454f87c546fa668c66fd&email=${email_cliente}`,
    options
  )
    .then((response) => response.json())
    .then((response) => {
      if (!response.is_smtp_valid.value && !response.is_valid_format.value) {
        alert("El dominio del correo no es valido ");
        return false;
      }
    })
    .catch((err) => console.error(err));

  // project name length
  if (nombre_proyecto.length > 80) {
    alert("El nombre del proyecto no puede tener más de 80 caracteres");
    return false;
  }

  // date validation
  if (fecha_inicio > fecha_final) {
    alert("La fecha de inicio no puede ser mayor a la fecha de fin");
    return false;
  }

  // client name length
  if (nombre_cliente.length > 64) {
    alert("El nombre del cliente es demasiado extenso! (max 64 caracteres)");
    return false;
  }

  // email length
  if (email_cliente.length > 255) {
    alert("El email no puede tener más de 255 caracteres");
    return false;
  }

  // phone number validation (only digits)
  var telefonoRegex = /^[0-9]+$/;
  if (!telefonoRegex.test(tel_cliente)) {
    alert("El número de teléfono solo debe contener números.");
    return false;
  }

  if (descripcion_cliente.length > 512) {
    alert("La descripción no puede sobrepasar los 512 caracteres");
    return false;
  }

  //required fields
  if (
    !nombre_proyecto ||
    !tipo_proyecto ||
    !fecha_inicio ||
    !fecha_final ||
    !nombre_cliente ||
    !email_cliente ||
    !descripcion_cliente
  ) {
    alert("Todos los campos son requeridos");
    return false;
  }

  return true;
}
