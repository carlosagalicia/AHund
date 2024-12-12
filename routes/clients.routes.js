/* Dependencies */
const express = require("express");
const router = express.Router();
const isAuth = require("./isAuth");
/*------------*/

/* Including Controller */
const controller = require("../controllers/clients.controller");
/*------------*/

/* GET methods */
router.get("/", isAuth, controller.get_clients);
/*------------*/

/* POST methods */
/*------------*/

module.exports = router;
