const Colabs = require("../models/colab.model");
const bcrypt = require("bcryptjs");

exports.get = (req, res) => {
  res.render("login", {
    failMsgLOGIN: req.flash("failLOGIN"),
  });
};

exports.post = async (req, res) => {
  try {
    const [row] = await Colabs.fetchUser(req.body.email);

    //usuario no detectado
    if (!row || row.length === 0) {
      const alertMsg = "Usuario o contraseña incorrectos";
      req.flash("failLOGIN", alertMsg);
      return res.status(401).render("login", {
        failMsgLOGIN: req.flash("failLOGIN"),
      });
    }

    // no inputs
    else if (!req.body.password || !row[0].Contrasena) {
      const alertMsg = "Todos los campos son obligatorios.";
      req.flash("failLOGIN", alertMsg);

      return res.status(400).render("login", {
        failMsgLOGIN: req.flash("failLOGIN"),
      });
    }

    const user = row[0];
    const doMatch = await bcrypt.compare(req.body.password, user.Contrasena);

    if (doMatch) {
      req.session.isLoggedIn = true;
      req.session.userID = user.IDUsuario;
      const [permits] = await Colabs.getPermits(user.IDUsuario);
      req.session.permits = permits;

      // console.log(`Welcome ${user.Usuario}`);
      // console.log(req.sessionID);
      // console.log(req.session.userID);
      // console.log(req.session.permits);

      res.status(200).redirect("/");
    } else {
      const alertMsg = "Usuario o contraseña incorrectos";
      req.flash("failLOGIN", alertMsg);
      res.status(401).redirect("/login");
    }
  } catch (err) {
    console.log(err);
    res.status(500).send("Error al iniciar sesión.");
  }
};

exports.get_login_view = (req, res) => {
  res.render("login", {
    failMsgLOGIN: req.flash("failLOGIN"),
  });
};

exports.logout = (req, res) => {
  req.session.destroy((err) => {
    if (err) {
      return res.status(500).send("Error al cerrar la sesión");
    }
    res.clearCookie("connect.sid");
    res.redirect("/login");
  });
};
