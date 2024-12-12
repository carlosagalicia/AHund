/* Dependencies */
const express = require("express");
const router = express.Router();
const isAuth = require("./isAuth");
const hasPermit = require("./hasPermit");
/*------------*/

/* Including Controller */
const controller = require("../controllers/risks.controller");
/*------------*/

/* GET methods */
router.get("/", isAuth, controller.get_risks);
router.get("/add-risk", isAuth, hasPermit, controller.add_risk);
router.get("/risk-info", isAuth, controller.get_risk_info);
router.get("/edit-risk", isAuth, hasPermit, controller.get_edit_risk);
/*------------*/

/* POST methods */
router.post("/add-risk", isAuth, hasPermit, controller.post_register_risk);
router.post("/delete-risk", isAuth, hasPermit, controller.delete_risk);
router.post("/edit-risk", isAuth, hasPermit, controller.post_edit_risk);
/*------------*/

module.exports = router;
