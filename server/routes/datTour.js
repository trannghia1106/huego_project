const express = require('express');
const router = express.Router();
const datTourController = require('../controllers/datTourController');

// Route POST: Đặt tour
router.post('/', datTourController.taoDonDatTour);

// Route GET: Lấy lịch sử đặt tour
router.get('/lich-su/:maNguoiDung', datTourController.layLichSuDatTour);

// Route GET: Lấy chi tiết đơn đặt tour
router.get('/chi-tiet/:maDatTour', datTourController.layChiTietDonTour);

module.exports = router;