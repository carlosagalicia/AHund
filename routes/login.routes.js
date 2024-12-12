/* Dependencies */
const express = require("express");
const router = express.Router();
/*------------*/

/* Including Controller */
const controller = require("../controllers/login.controller");
/*------------*/

/* GET methods */
router.get("/", controller.get_login_view);
router.get("/logout", controller.logout);
/*------------*/

/* POST methods */
router.post("/", controller.post);
/*------------*/

module.exports = router;
