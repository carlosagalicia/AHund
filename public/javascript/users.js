function validateEditProfileForm() {
  var user_email = document.getElementById("userEmail").value;
  var user_name = document.getElementById("name").value;
  var apellido_paterno = document.getElementById("aPaterno").value;
  var apellido_materno = document.getElementById("aMaterno").value;
  var user_password = document.getElementById("userPassword").value;
  var confirmed_password = document.getElementById("checkPassword").value;

  // userEmail appix validation
  if (!user_email.endsWith("@appix.mx")) {
    alert("El correo no tiene dominio de appix. Intenta de nuevo.");
    return false;
  }

  // userEmail length validation
  if (user_email.length > 32) {
    alert("El correo del usuario no puede ser mayor a 32 caracteres");
    return false;
  }

  // user name length validation
  if (user_name.length > 40) {
    alert("El nombre del usuario no puede ser mayor a 40 caracteres");
    return false;
  }

  // apellido paterno length validation
  if (apellido_paterno.length > 40) {
    alert("El apellido paterno del usuario no puede ser mayor a 40 caracteres");
    return false;
  }

  // apellido materno length validation
  if (apellido_materno.length > 40) {
    alert("El apellido materno del usuario no puede ser mayor a 40 caracteres");
    return false;
  }

  // passwords validation 2
  if (user_password != confirmed_password) {
    alert("Las contraseñas no coinciden. Intenta de nuevo");
    return false;
  }

  // password validation length
  if (user_password.length > 24) {
    alert("La contraseña debe ser menor a 24 caracteres");
    return false;
  }

  //required fields
  if (!user_email || !user_name || !apellido_paterno || !apellido_materno) {
    alert("Llena los campos necesarios para editar perfil");
    return false;
  }

  return true;
}
