const Clients = require("../models/clients.model");
const bcrypt = require("bcryptjs");

exports.get_clients = async (req, res, next) => {
  try{
    const filter = req.query.filter || null;
    const isAdmin = req.session.permits.some(
      (permit) => permit.Nombre === "Administrador"
    );

    const [rows] =
      filter === "name(A-Z)"
        ? await Clients.fetchAll()
        : filter === "name(Z-A)"
        ? await Clients.fetchByNameDESC()
        : filter === "correo(A-Z)"
        ? await Clients.fetchByEmailASC()
        : filter === "correo(Z-A)"
        ? await Clients.fetchByEmailDESC()
        : await Clients.fetchAll();

    res.render("clientes",{
    clientes: rows,
    isAdmin: isAdmin,
    filter: filter,

    });
  } catch (err) {
    console.log(err);
    res.status(500).send("Error al obtener los colaboradores");
  }

};
