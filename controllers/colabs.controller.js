const Colabs = require("../models/colab.model");
const bcrypt = require("bcryptjs");

exports.get_register_colab = (req, res) => {
  const isAdmin = req.session.permits.some(
    (permit) => permit.Nombre === "Administrador"
  );

  res.render("register-colab", {
    successMsgINSERT: req.flash("successINSERT"),
    failMsgINSERT: req.flash("failINSERT"),
    isAdmin: isAdmin,
  });
};

exports.post_register_colab = async (req, res) => {
  try {
    const isAdmin =
      req.session.permits &&
      req.session.permits.some((permit) => permit.Nombre === "Administrador");

    const row = await Colabs.fetchUser(req.body.email);
    if (!row[0] || row[0].length === 0) {
      const hashedPassword = await bcrypt.hash(req.body.password, 12);
      await Colabs.save(
        req.session.userID,
        req.body.Usuario,
        hashedPassword,
        req.body.name,
        req.body.Apaterno,
        req.body.Amaterno,
        req.body.email
      );

      const alertMsg = "El colaborador se registró correctamente.";
      req.flash("successINSERT", alertMsg);
      res.status(200).render("register-colab", {
        successMsgINSERT: req.flash("successINSERT"),
        failMsgINSERT: req.flash("failINSERT"),
        isAdmin: isAdmin,
      });
    } else {
      console.log(row[0]);
      const alertMsg = "El colaborador ya existe.";
      req.flash("failINSERT", alertMsg);
      res.status(200).render("register-colab", {
        successMsgINSERT: req.flash("successINSERT"),
        failMsgINSERT: req.flash("failINSERT"),
        isAdmin: isAdmin,
      });
    }
  } catch (err) {
    console.log(err);
    res.status(500).send("Error al registrar al colaborador.");
  }
};

exports.get_colab = async (req, res) => {
  try {
    const filter = req.query.filter || null;
    const isAdmin = req.session.permits.some(
      (permit) => permit.Nombre === "Administrador"
    );

    const [rows] =
      filter === "name(A-Z)"
        ? await Colabs.fetchAll()
        : filter === "name(Z-A)"
        ? await Colabs.fetchByNameDESC()
        : await Colabs.fetchAll();

    res.render("colaboradores", {
      colaboradores: rows,
      successMsgDELETE: req.flash("successDELETE"),
      successMsgPUT: req.flash("successPUT"),
      filter: filter,
      isAdmin: isAdmin,
    });
  } catch (err) {
    console.log(err);
    res.status(500).send("Error al obtener los colaboradores");
  }
};

exports.modify_colab = (req, res) => {
  Colabs.addPermit(req.session.userID, req.body._email)
    .then(() => {
      const alertMsg = "El colaborador se actualizó correctamente.";
      req.flash("successPUT", alertMsg);
      res.status(200);
      res.redirect("/colaboradores");
    })
    .catch((err) => {
      console.log(err);
      res.status(500).send("Error al actualizar al colaborador.");
    });
};

exports.delete_colab = (req, res) => {
  Colabs.delete(req.session.userID, req.body._email)
    .then(() => {
      const alertMsg = "El colaborador se eliminó correctamente.";
      req.flash("successDELETE", alertMsg);
      res.status(200);
      res.redirect("/colaboradores");
    })
    .catch((err) => {
      console.log(err);
      res.status(500).send("Error al eliminar el colaborador.");
    });
};
