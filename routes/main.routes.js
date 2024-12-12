/* Dependencies */
const express = require("express");
const router = express.Router();
const isAuth = require("./isAuth");
const hasPermit = require("./hasPermit");
/*------------*/

/* Including Controller */
const controller = require("../controllers/main.controller");
/*------------*/

/* GET methods */
router.get("/", isAuth, controller.get_projects);
router.get("/edit-profile", isAuth, controller.get_edit_profile);
router.get(
  "/register-project",
  isAuth,
  hasPermit,
  controller.get_register_project
);
router.get("/edit-project", isAuth, hasPermit, controller.get_edit_project);
router.get("/project-risks", isAuth, controller.get_project_risks);
router.get("/client", isAuth, controller.get_client);
/*------------*/

/* POST methods */
router.post("/post-edit-profile", isAuth, controller.post_edit_profile);
router.post("/delete-project", isAuth, hasPermit, controller.delete_project);
router.post(
  "/post-register-project",
  isAuth,
  hasPermit,
  controller.post_register_project
);
router.post(
  "/post-edit-project",
  isAuth,
  hasPermit,
  controller.post_edit_project
);
router.post("/archive-project", isAuth, hasPermit, controller.archive_project);
router.post(
  "/unarchive-project",
  isAuth,
  hasPermit,
  controller.unarchive_project
);
router.post("/highlight-project", isAuth, controller.highlight_project);
/*------------*/

module.exports = router;
