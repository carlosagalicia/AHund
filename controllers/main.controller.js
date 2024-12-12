const Projects = require("../models/main.model");
const User = require("../models/user.model");
const bcrypt = require("bcryptjs");

exports.get_projects = async (req, res) => {
  try {
    let pageNumber = req.query.page || 1;
    const filter = req.query.filter || "assigned";
    const status = req.query.status === "archived" ? "archived" : "actives";
    const userID = req.session.userID;
    const isAdmin = req.session.permits.some(
      (permit) => permit.Nombre === "Administrador"
    );
    const pageSize = 6;
    let offset = (pageNumber - 1) * pageSize;

    const inexistentProjects = "No se encontró nada";
    const inexistentPage = "Página inexistente";
    const inexistentFilter = "Filtro inexistente";

    const [totalProjects, metadata] = await Projects.countProjects(
      status === "actives"
    );

    const totalPages = Math.ceil(totalProjects[0].NumActivos / pageSize);

    if (
      isNaN(pageNumber) ||
      pageNumber < 1 ||
      (pageNumber > totalPages && totalPages != 0)
    ) {
      pageNumber = 1;
      offset = (pageNumber - 1) * pageSize;
      req.flash("inexistentPage", inexistentPage);
    }

    const [rows, metadata1] = await Projects.fetchAll(
      status === "actives",
      filter,
      pageSize,
      offset,
      userID
    );

    if (filter && !["higher", "older", "recent", "assigned"].includes(filter)) {
      req.flash("inexistentFilter", inexistentFilter);
    } else if (rows[0].length < 1) {
      req.flash("inexistentProjects", inexistentProjects);
    }

    if (status) {
      req.session.status = status;
    }

    res.render("projects", {
      projects: rows[0],
      pageNumber: parseInt(pageNumber),
      totalPages: totalPages,
      status: status,
      successMsg: req.flash("success"),
      inexistentPage: req.flash("inexistentPage"),
      inexistentProjects: req.flash("inexistentProjects"),
      inexistentFilter: req.flash("inexistentFilter"),
      filter: filter,
      isAdmin: isAdmin,
    });
  } catch (err) {
    console.error(err);
    res.status(500).send("Error al obtener los proyectos");
  }
};

exports.get_project_risks = async (req, res) => {
  try {
    const IDProyecto = req.query.id;

    const [risks, metadata3] = await Projects.fetchProjectRisks(IDProyecto);
    res.render("project-risk-list", { risks });
  } catch (error) {
    console.error("Error al obtener riesgos:", error);
    res.status(500).json({ error: "Error al obtener los riesgos" });
  }
};

exports.get_client = async (req, res) => {
  try {
    const IDProyecto = req.query.id;
    const [client, metadata4] = await Projects.fetchClient(IDProyecto);
    res.render("project-client-content", { client: client[0] });
  } catch (error) {
    console.error("Error al obtener riesgos:", error);
    res.status(500).json({ error: "Error al obtener los datos del cliente" });
  }
};

exports.get_edit_profile = async (req, res) => {
  try {
    const userId = req.session.userID;
    const [user] = await User.findById(userId);
    if (!user) {
      req.flash("error", "Usuario no encontrado");
      return res.redirect("/");
    }

    res.render("edit-profile", {
      user: user[0],
      successMsg: req.flash("success"),
    });
  } catch (error) {
    console.error("Error al obtener datos del usuario:", error);
    res.status(500).json({ error: "Error al obtener datos del usuario" });
  }
};

exports.post_edit_profile = async (req, res) => {
  try {
    const userId = req.session.userID;
    let updatedData = req.body;

    if (updatedData.userPassword != updatedData.checkPassword)
      res.status(500).json({ error: "Error al actualizar perfil" });

    if (updatedData.userPassword != ``) {
      const hashedPassword = await bcrypt.hash(updatedData.userPassword, 12);
      updatedData.userPassword = hashedPassword;
    } else {
      updatedData.userPassword = null;
    }

    await User.updateById(userId, updatedData);

    req.flash("success", "Perfil actualizado correctamente");
    res.redirect("/edit-profile");
  } catch (error) {
    console.error("Error al actualizar perfil:", error);
    res.status(500).json({ error: "Error al actualizar perfil" });
  }
};

exports.get_register_project = async (req, res) => {
  const isAdmin = req.session.permits.some(
    (permit) => permit.Nombre === "Administrador"
  );

  res.render("register-project", {
    successMsg: req.flash("success"),
    isAdmin: isAdmin,
    errorMsg: req.flash("error"),
    filter: null,
  });
};

exports.get_edit_project = async (req, res) => {
  const isAdmin = req.session.permits.some(
    (permit) => permit.Nombre === "Administrador"
  );
  const IDProyecto = req.query.IDProyecto;

  const [project, metadata1] = await Projects.fetchProject(IDProyecto);
  const [client, metadata2] = await Projects.fetchClient(IDProyecto);
  const data = [];

  if (!project || !client) {
    return res.status(404).send("No se encontró el proyecto o el cliente");
  }

  const formatDate = (dateString) => {
    const date = new Date(dateString);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`;
  };

  project[0].FechaInicio = formatDate(project[0].FechaInicio);
  project[0].FechaFinal = formatDate(project[0].FechaFinal);

  data.push(project[0]);
  data.push(client[0]);

  res.render("edit-project", {
    successMsg: req.flash("success"),
    isAdmin: isAdmin,
    errorMsg: req.flash("error"),
    project: data,
  });
};

exports.post_register_project = async (req, res) => {
  try {
    const nombre = req.body.nombreProyecto;
    const f_inicio = new Date(req.body.fechaInicio);
    const f_final = new Date(req.body.fechaFin);
    const tipo = req.body.tipoProyecto;
    const estado = 1; // Setea por default el estado de un proyecto a activo al momento de registrarse
    const nombreCliente = req.body.nombreCliente;
    const emailCliente = req.body.emailCliente;
    const telefonoCliente = req.body.telefonoCliente;
    const descripcionCliente = req.body.descripcionCliente;
    const alertMsg = "El proyecto se registró correctamente.";

    // Validación de fechas
    if (f_inicio > f_final) {
      req.flash(
        "error",
        "La fecha de inicio no puede ser mayor a la fecha de fin."
      );
      return res.status(400).redirect("/register-project");
    }

    // Validación del número de teléfono
    const telefonoRegex = /^[0-9]+$/;
    if (!telefonoRegex.test(telefonoCliente)) {
      req.flash("error", "El número de teléfono solo debe contener números.");
      return res.status(400).redirect("/register-project");
    }

    const project = new Projects(
      nombre,
      f_inicio,
      f_final,
      tipo,
      estado,
      nombreCliente,
      emailCliente,
      telefonoCliente,
      descripcionCliente
    );

    await project.save();

    req.flash("success", alertMsg);
    res.status(201).redirect("/register-project"); // Se ha creado con exito y nos recarga la pagina
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error registrando proyecto!" });
  }
};

exports.post_edit_project = async (req, res) => {
  try {
    const IDProyecto = req.body.IDProyecto;
    const IDCliente = req.body.IDCliente;
    const nombre = req.body.nombreProyecto;
    const f_inicio = new Date(req.body.fechaInicio);
    const f_final = new Date(req.body.fechaFin);
    const tipo = req.body.tipoProyecto;
    const estado = 1; // Setea por default el estado de un proyecto a activo al momento de registrarse
    const nombreCliente = req.body.nombreCliente;
    const emailCliente = req.body.emailCliente;
    const telefonoCliente = req.body.telefonoCliente;
    const descripcionCliente = req.body.descripcionCliente;
    const alertMsg = "El proyecto se editó correctamente.";

    // Validación de fechas
    if (f_inicio > f_final) {
      req.flash(
        "error",
        "La fecha de inicio no puede ser mayor a la fecha de fin."
      );
      return res.status(400).redirect("/register-project");
    }

    // Validación del número de teléfono
    const telefonoRegex = /^[0-9]+$/;
    if (!telefonoRegex.test(telefonoCliente)) {
      req.flash("error", "El número de teléfono solo debe contener números.");
      return res.status(400).redirect("/register-project");
    }

    const project = {
      IDProyecto,
      IDCliente,
      nombre,
      f_inicio,
      f_final,
      tipo,
      estado,
      nombreCliente,
      emailCliente,
      telefonoCliente,
      descripcionCliente,
    };

    await Projects.updateProjectWithClient(project);

    req.flash("success", alertMsg);
    res.status(201).redirect("/"); // Se ha creado con exito y nos recarga la pagina
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error editando proyecto!" });
  }
};

exports.archive_project = async (req, res) => {
  try {
    const IDProyecto = req.body.IDProyecto;
    const alertMsg = "El proyecto se archivó correctamente.";
    const referer = req.headers.referer;
    await Projects.archiveProject(IDProyecto);

    req.flash("success", alertMsg);
    res.redirect(referer);
  } catch (error) {
    console.error("Error al archivar proyecto:", error);
    res.status(500).json({ error: "Error al archivar proyecto" });
  }
};

exports.unarchive_project = async (req, res) => {
  try {
    const IDProyecto = req.body.IDProyecto;
    const alertMsg = "El proyecto se desarchivó correctamente.";
    const referer = req.headers.referer;
    await Projects.unarchiveProject(IDProyecto);

    req.flash("success", alertMsg);
    res.redirect(referer);
  } catch (error) {
    console.error("Error al dearchivar proyecto:", error);
    res.status(500).json({ error: "Error al desarchivar proyecto" });
  }
};

exports.highlight_project = async (req, res) => {
  try {
    const IDProyecto = req.body._IDProyecto;
    const userID = req.session.userID;
    const referer = req.headers.referer;
    await Projects.highlightProject(IDProyecto, userID);

    res.redirect(referer);
  } catch (error) {
    console.error("Error al modificar proyecto:", error);
    res.status(500).json({ error: "Error al modificar proyecto" });
  }
};

exports.delete_project = async (req, res) => {
  try {
    const IDProyecto = req.body._IDProyecto;
    const referer = req.headers.referer;
    await Projects.deleteById(IDProyecto);
    req.flash("success", "El proyecto se eliminó correctamente");
    res.status(200).redirect(referer);
  } catch (error) {
    console.error("Error al eliminar proyecto:", error);
    res.status(500).json({ error: "Error al eliminar proyecto" });
  }
};
