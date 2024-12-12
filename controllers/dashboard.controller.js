const Projects = require("../models/main.model");
const puppeteer = require("puppeteer");
const ejs = require("ejs");
const path = require("path");
const Risks = require("../models/risks.model");

exports.get_dashboard = async (req, res) => {
  try {
    const isAdmin = req.session.permits.some(
      (permit) => permit.Nombre === "Administrador"
    );
    const status = req.session.status;
    let IDProyecto = req.query.IDProyecto;

    if (!IDProyecto) {
      try {
        const [firstProject, metadata] = await Projects.fetchFirstProject(
          status === "actives"
        );
        if (firstProject && firstProject.length > 0) {
          IDProyecto = firstProject[0].IDProyecto;
          req.session.IDProyecto = IDProyecto;
        } else {
          req.flash("inexistentProjects");
          return res.redirect("/");
        }
      } catch (error) {
        console.error("Error fetching the first project:", error);
        req.flash("error", "Hubo un error al obtener el proyecto.");
        return res.redirect("/");
      }
    } else {
      req.session.IDProyecto = IDProyecto;
    }

    const [project, metadata1] = await Projects.fetchProject(IDProyecto);
    if (!project) {
      return res.status(404).send("Proyecto no encontrado");
    }

    const [ponderacion] = await Projects.getProjectPonderationData(
      IDProyecto,
      project[0].FechaInicio
    );

    const [risksOfProject, metadata2] = await Projects.fetchRisksOfProject(
      IDProyecto
    );

    res.render("dashboard", {
      isAdmin: isAdmin,
      project: project[0],
      projectData: ponderacion,
      successMsg: req.flash("success"),
      risksOfProject,
      status: status,
    });
  } catch (err) {
    console.error(err);
    const statusCode = err.message === "Proyecto no encontrado" ? 404 : 500;
    res
      .status(statusCode)
      .send(statusCode === 404 ? err.message : "Error al cargar el tablero");
  }
};

exports.get_project_list = async (req, res) => {
  try {
    let pageNumber = req.query.page || 1;
    const filter = "assigned";
    const status = req.session.status;
    const userID = req.session.userID;
    const pageSize = 6;
    let offset = (pageNumber - 1) * pageSize;

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
    }

    const [rows, metadata1] = await Projects.fetchAll(
      status === "actives",
      filter,
      pageSize,
      offset,
      userID
    );

    res.render("dashboard-project-list", {
      projects: rows[0],
      pageNumber: parseInt(pageNumber),
      totalPages: totalPages,
      status: status,
      filter: filter,
    });
  } catch (err) {
    console.error(err);
    res.status(500).send("Error al obtener los proyectos");
  }
};

exports.get_project_risks = async (req, res) => {
  try {
    const IDProyecto = req.session.IDProyecto;
    const [risksOfProject, metadata1] = await Projects.fetchRisksOfProject(
      IDProyecto
    );

    res.status(200).json(risksOfProject);
  } catch (err) {
    console.log(err);
    res.status(500).send("Error al obtener los riesgos.");
  }
};

exports.get_risks_types = async (req, res) => {
  try {
    const IDProyecto = req.session.IDProyecto;
    const [risksByType, metadata1] = await Projects.countRisks(IDProyecto);

    res.status(200).json(risksByType);
  } catch (err) {
    console.log(err);
    res.status(500).send("Error al obtener los tipos de riesgo.");
  }
};

exports.get_dissimilar_risks = async (req, res) => {
  try {
    const IDProyecto = req.session.IDProyecto;
    const [assntRisks, metadata1] = await Risks.fetchDissimilar(IDProyecto);

    res.status(200).render("dashboard-dissimilar-list", { risks: assntRisks });
  } catch (err) {
    console.error(err);
    res.status(500).send("Error al obtener los riesgos");
  }
};

exports.post_associate_risk = async (req, res) => {
  try {
    const IDRiesgo = req.body._IDRiesgo;
    const IDProyecto = req.session.IDProyecto;
    const medidas = req.body.medidas;
    const ponderacion = req.body.ponderacion;

    const fechaAsignacion = new Date().toISOString().split("T")[0];

    await Risks.associateRisk(
      IDRiesgo,
      IDProyecto,
      fechaAsignacion,
      ponderacion,
      medidas
    );

    req.flash("success", "Riesgo asociado correctamente");

    res.redirect("back");
  } catch (err) {
    console.error(err);
    res.status(500).send("Error al asociar el riesgo");
  }
};

exports.get_associated_risks = async (req, res) => {
  try {
    const IDProyecto = req.session.IDProyecto;
    const [assRisks, metadata1] = await Risks.fetchAssociated(IDProyecto);

    res.status(200).render("dashboard-associated-list", { risks: assRisks });
  } catch (err) {
    console.error(err);
    res.status(500).send("Error al obtener los riesgos");
  }
};

exports.post_unassociate_risk = async (req, res) => {
  try {
    const IDRiesgo = req.body._IDRiesgo;
    const IDProyecto = req.session.IDProyecto;

    Risks.unassociateRisk(IDRiesgo, IDProyecto);

    req.flash("success", "Riesgo desasociado correctamente");

    res.redirect("back");
  } catch (err) {
    console.error(err);
    res.status(500).send("Error al desasociar el riesgo");
  }
};

exports.get_associate = (req, res) => {
  const isAdmin = req.session.permits.some(
    (permit) => permit.Nombre === "Administrador"
  );

  res.render("associate", {
    isAdmin: isAdmin,
  });
};

exports.generate_dashboard_pdf = async (req, res) => {
  try {
    const isAdmin = req.session.permits.some(
      (permit) => permit.Nombre === "Administrador"
    );
    const status = req.session.status;
    let IDProyecto = req.query.IDProyecto;

    if (!IDProyecto) {
      const [firstProject, metadata] = await Projects.fetchFirstProject(
        status === "actives"
      );
      if (firstProject && firstProject.length > 0) {
        IDProyecto = firstProject[0].IDProyecto;
        req.session.IDProyecto = IDProyecto;
      } else {
        req.flash("inexistentProjects");
        return res.redirect("/");
      }
    } else {
      req.session.IDProyecto = IDProyecto;
    }

    const [project, metadata1] = await Projects.fetchProject(IDProyecto);
    if (!project) {
      return res.status(404).send("Proyecto no encontrado");
    }

    const [ponderacion] = await Projects.getProjectPonderationData(
      IDProyecto,
      project[0].FechaInicio
    );

    const [risksOfProject, metadata2] = await Projects.fetchRisksOfProject(
      IDProyecto
    );

    const html = await ejs.renderFile(
      path.join(__dirname, "../views/dashboard-pdf.ejs"),
      {
        isAdmin: isAdmin,
        project: project[0],
        projectData: ponderacion,
        successMsg: req.flash("success"),
        risksOfProject,
        status: status,
      }
    );

    // Convertir HTML a PDF usando Puppeteer
    const browser = await puppeteer.launch({
      headless: true,
      args: [
        "--no-sandbox",
        "--disable-setuid-sandbox",
        "--disable-dev-shm-usage",
        "--disable-accelerated-2d-canvas",
        "--disable-gpu",
      ],
      timeout: 30000, // 30 segundos de timeout
    });
    const page = await browser.newPage();
    await page.setContent(html);
    const pdfBuffer = await page.pdf({ format: "A4", printBackground: true });

    await browser.close();

    // Enviar el PDF como respuesta
    res.set({
      "Content-Type": "application/pdf",
      "Content-Disposition": 'attachment; filename="project.pdf"',
    });
    res.send(pdfBuffer);
  } catch (err) {
    console.error(err);
    const statusCode = err.message === "Proyecto no encontrado" ? 404 : 500;
    res
      .status(statusCode)
      .send(statusCode === 404 ? err.message : "Error al generar el PDF");
  }
};
exports.post_edit_associated_risk = async (req, res) => {
  try {
    const { riskId, medidas, ponderacion } = req.body;
    const IDProyecto = req.session.IDProyecto;

    await Risks.updateRiskDetails(riskId, IDProyecto, medidas, ponderacion);

    // Redirect to a success page or send a success message
    res.redirect("/dashboard");
  } catch (error) {
    console.error("Error updating risk details:", error);
    // Handle errors appropriately, e.g., redirect to an error page or send an error message
    res.status(500).send("Error updating risk details");
  }
};
