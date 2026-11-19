const YeuThich = require('../models/yeuthichModel');

// Lấy danh sách địa điểm đã thích theo MaNguoiDung
exports.getFavoritesByUser = (req, res) => {
  const { maNguoiDung } = req.params;

  YeuThich.getByUserId(maNguoiDung, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    // Trả về mảng danh sách ID đơn giản: [1, 3, 9]
    const favoriteIds = results.map(row => row.MaDiaDiem);
    res.json(favoriteIds);
  });
};

// Thêm yêu thích
exports.addFavorite = (req, res) => {
  const { maNguoiDung, maDiaDiem } = req.body;

  if (!maNguoiDung || !maDiaDiem) {
    return res.status(400).json({ message: 'Thiếu maNguoiDung hoặc maDiaDiem' });
  }

  YeuThich.add(maNguoiDung, maDiaDiem, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ message: 'Thêm vào yêu thích thành công' });
  });
};

// Xóa yêu thích
exports.removeFavorite = (req, res) => {
  const { maNguoiDung, maDiaDiem } = req.query;

  if (!maNguoiDung || !maDiaDiem) {
    return res.status(400).json({ message: 'Thiếu maNguoiDung hoặc maDiaDiem' });
  }

  YeuThich.remove(maNguoiDung, maDiaDiem, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'Đã xóa khỏi danh sách yêu thích' });
  });
};