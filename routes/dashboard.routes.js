/* Dependencies */
const express = require("express");
const router = express.Router();
const isAuth = require("./isAuth");
const hasPermit = require("./hasPermit");
/*------------*/

/* Including Controller */
const controller = require("../controllers/dashboard.controller");
/*------------*/

/* GET methods */
router.get("/", isAuth, controller.get_dashboard);
router.get("/associate", isAuth, hasPermit, controller.get_associate);
router.get("/project-list", isAuth, controller.get_project_list);
router.get(
  "/dissimilar-list",
  isAuth,
  hasPermit,
  controller.get_dissimilar_risks
);
router.get(
  "/associated-list",
  isAuth,
  hasPermit,
  controller.get_associated_risks
);
router.get("/project-risks", isAuth, controller.get_project_risks);
router.get("/risk-types", isAuth, controller.get_risks_types);
router.get("/pdf", isAuth, controller.generate_dashboard_pdf);
/*------------*/

/* POST methods */
router.post(
  "/unassociate-risk",
  isAuth,
  hasPermit,
  controller.post_unassociate_risk
);
router.post(
  "/associate-risk",
  isAuth,
  hasPermit,
  controller.post_associate_risk
);
router.post(
  "/edit-associated-risk",
  isAuth,
  hasPermit,
  controller.post_edit_associated_risk
);
/*------------*/

module.exports = router;
