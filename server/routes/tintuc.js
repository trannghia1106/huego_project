const express = require('express');
const router = express.Router();
const tintucController = require('../controllers/tintucController');

// Đặt các route con lên trước
router.get('/hot', tintucController.getTinHot);
router.get('/search', tintucController.searchTinTuc);

// Route gốc đặt ở cuối cùng
router.get('/', tintucController.getAllTinTuc);

module.exports = router;