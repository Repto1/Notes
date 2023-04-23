const router = require("express").Router();

const noteController = require("../controllers/noteController");

router.route("/notes").post((req, res) => noteController.create(req, res));

router.route("/notes").get((req, res) => noteController.getAll(req, res));

router.route("/notes/:id").get((req, res) => noteController.get(req, res));

router
  .route("/notes/:id")
  .delete((req, res) => noteController.delete(req, res));

router.route("/notes/:id").put((req, res) => noteController.update(req, res));

module.exports = router;
