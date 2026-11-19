const express = require("express");
const router = express.Router();

const nguoidungController = require("../controllers/nguoidungController");

// POST /api/auth/login Đăng nhập thường
router.post("/login", nguoidungController.login);

// Đăng nhập Google
router.post("/google-login", nguoidungController.loginGoogle);

module.exports = router;