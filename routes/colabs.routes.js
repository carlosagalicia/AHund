/* Dependencies */
const express = require("express");
const bodyParser = require("body-parser");
const router = express.Router();
const isAuth = require("./isAuth");
const hasPermit = require("./hasPermit");

router.use(bodyParser.urlencoded({ extended: true }));
/*------------*/

/* Including Controller */
const controller = require("../controllers/colabs.controller");
/*------------*/

/* GET methods */
router.get("/", isAuth, hasPermit, controller.get_colab);
router.get(
  "/registrar-colaborador",
  isAuth,
  hasPermit,
  controller.get_register_colab
);
/*------------*/

/* DELETE methods and PUT methods*/
router.post("/modify", isAuth, hasPermit, controller.modify_colab);
router.post("/delete", isAuth, hasPermit, controller.delete_colab);
router.post(
  "/registrar-colaborador",
  isAuth,
  hasPermit,
  controller.post_register_colab
);
/*------------*/

module.exports = router;
