module.exports = async (req, res, next) => {
  const isAdmin = req.session.permits.some(
    (permit) => permit.Nombre === "Administrador"
  );

  if (isAdmin) {
    next();
  } else {
    return res.redirect("/");
  }
};
