// Función para mostrar el modal de confirmación y ejecutar confirmAction
let form;

function openConfirmationModal(formID, text) {
  const confirmationText = document.getElementById("confirmation-Text");
  confirmationText.innerText = text;

  const inputContent = document.getElementById("input-Modal-Content");

  if(inputContent) inputContent.innerHTML = '';

  document.getElementById("confirmation-Modal").style.display = "block";
  form = document.getElementById(formID);
}


// Función para cerrar el modal de confirmación y resetear checkboxes
function closeConfirmationModal() {
  MODAL_CONSTANTS.MODAL.style.display = "none";
}

// Función para ejecutar la acción de confirmación
function confirmAction() {
  form.submit();
}