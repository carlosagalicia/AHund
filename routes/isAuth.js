// Redirect to login if the user is no authenticated
// Move this to utils before

module.exports = async (req, res, next) => {
  if (!req.session.isLoggedIn) {
    return res.redirect("/login");
  }

  next();
};
