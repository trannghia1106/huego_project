const db = require('../config/database');

const YeuThich = {
  // 1. Lấy danh sách MaDiaDiem mà User đã thích
  getByUserId: (maNguoiDung, callback) => {
    const sql = 'SELECT MaDiaDiem FROM YeuThich WHERE MaNguoiDung = ?';
    db.query(sql, [maNguoiDung], callback);
  },

  // 2. Thêm vào yêu thích
  add: (maNguoiDung, maDiaDiem, callback) => {
    const ngayThem = new Date();
    const sql = 'INSERT INTO YeuThich (MaNguoiDung, MaDiaDiem, NgayThem) VALUES (?, ?, ?)';
    db.query(sql, [maNguoiDung, maDiaDiem, ngayThem], callback);
  },

  // 3. Xóa khỏi yêu thích
  remove: (maNguoiDung, maDiaDiem, callback) => {
    const sql = 'DELETE FROM YeuThich WHERE MaNguoiDung = ? AND MaDiaDiem = ?';
    db.query(sql, [maNguoiDung, maDiaDiem], callback);
  }
};

module.exports = YeuThich;