const Risks = require("../models/risks.model");

exports.get_risks = async (req, res) => {
  try {
    const isAdmin = req.session.permits.some(
      (permit) => permit.Nombre === "Administrador"
    );
    const type = req.query.type || null;
    const inexistentType = "Filtro inexistente";

    const [riskTypes, metadata3] = await Risks.fetchRiskTypes();

    if (type && !riskTypes.some((riskType) => riskType.Tipo === type)) {
      req.flash("inexistentType", inexistentType);
    }

    const [risks, fieldData2] = type
      ? await Risks.fetchBy(type)
      : await Risks.fetchAll();

    res.render("risks", {
      isAdmin: isAdmin,
      risks: risks,
      riskTypes: riskTypes,
      successMsg: req.flash("success"),
      inexistentType: req.flash("inexistentType"),
      errorMsg: req.flash("error"),
      type: type,
    });
  } catch (err) {
    console.error(err);
    res.status(500).send("Error al obtener los riesgos");
  }
};

exports.delete_risk = async (req, res) => {
  try {
    const IDRiesgo = req.body._IDRiesgo;
    const alertMsg = "El riesgo se eliminó correctamente.";
    const referer = req.headers.referer;

    await Risks.deleteRisk(IDRiesgo);

    req.flash("success", alertMsg);
    res.redirect(referer);
  } catch (error) {
    console.error("Error al eliminar el proyecto", error);
    res.status(500).json({ error: "Error al eliminar el riesgo" });
  }
};

exports.add_risk = async (req, res) => {
  const isAdmin = req.session.permits.some(
    (permit) => permit.Nombre === "Administrador"
  );

  res.render("add-risk", {
    isAdmin: isAdmin,
  });
};

exports.get_risk_info = async (req, res) => {
  try {
    const riskId = req.query.id;
    const [risk, metadata] = await Risks.fetchRisk(riskId);
    const [riskInfo, metadata1] = await Risks.fetchRiskInfo(riskId);
    let riskOverview = [];

    riskOverview.push(risk[0]);
    riskOverview.push(riskInfo);

    res.render("risk", { riskOverview });
  } catch (error) {
    console.error("Error al obtener los datos del riesgo", error);
    res.status(500).json({ error: "Error al obtener los datos del riesgo" });
  }
};

exports.post_register_risk = async (req, res) => {
  try {
    const nombre = req.body.nombreRiesgo;
    const descripcion = req.body.descripcion;
    const tipo = req.body.tipo;
    const successMsg = "El riesgo se registró correctamente.";
    const reqMsg = "Todos los campos son requeridos.";

    if (!nombre || !descripcion || !tipo) {
      req.flash("error", reqMsg);
      return res.status(500);
    }

    const risk = new Risks(nombre, descripcion, tipo);

    await risk.save();

    req.flash("success", successMsg);
    res.status(201).redirect("/risks");
  } catch (error) {
    const existMsg = "El riesgo ya existe.";
    const errorMsg = "Error registrando el riesgo.";
    console.error("Error registrando el riesgo:", error);
    if (error.sqlState === "45000") {
      req.flash("error", existMsg);
    } else {
      req.flash("error", errorMsg);
    }
    res.status(500).redirect("/risks");
  }
};

exports.get_edit_risk = async (req, res) => {
  try {
    const riskId = req.query.id;
    const [risk] = await Risks.fetchRisk(riskId);

    if (risk.length === 0) {
      return res.status(404).send("No se encontraron riesgos");
    }

    const isAdmin = req.session.permits.some(
      (permit) => permit.Nombre === "Administrador"
    );

    res.render("edit-risk", {
      csrfToken: req.csrfToken(),
      risk: risk[0],
      isAdmin: isAdmin,
    });
  } catch (error) {
    console.error("Error buscando riesgos para editar:", error);
    res.status(500).json({ error: "Error buscando riesgos para editar" });
  }
};

exports.post_edit_risk = async (req, res) => {
  try {
    const { riskId, nombreRiesgo, tipo, descripcion } = req.body;
    const successMsg = "El riesgo se actualizó correctamente.";
    const reqMsg = "Todos los campos son requeridos.";

    if (!nombreRiesgo || !tipo || !descripcion) {
      req.flash("error", reqMsg);
      return res.status(400).redirect(`/risks/edit-risk?id=${riskId}`);
    }

    await Risks.updateRisk(riskId, nombreRiesgo, tipo, descripcion);

    req.flash("success", successMsg);
    res.redirect("/risks");
  } catch (error) {
    const errorMsg = "Error actualizando el riesgo.";
    console.error("Error actualizando riesgo:", error);
    req.flash("error", errorMsg);
    res.status(500).redirect(`/risks/edit-risk?id=${req.body.riskId}`);
  }
};
