const express = require('express');
const router = express.Router();
const yeuthichController = require('../controllers/yeuthichController');

// GET: /api/yeuthich/1 (Lấy danh sách ID đã thích của user 1)
router.get('/:maNguoiDung', yeuthichController.getFavoritesByUser);

// POST: /api/yeuthich (Thêm địa điểm yêu thích)
router.post('/', yeuthichController.addFavorite);

// DELETE: /api/yeuthich?maNguoiDung=1&maDiaDiem=2 (Xóa yêu thích)
router.delete('/', yeuthichController.removeFavorite);

module.exports = router;