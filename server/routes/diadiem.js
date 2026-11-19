const express = require("express");
const router = express.Router();

const diadiemController = require("../controllers/diadiemController");

// GET /api/diadiem
router.get("/", diadiemController.getAllDiaDiem);

module.exports = router;