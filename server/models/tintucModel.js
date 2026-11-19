const db = require('../config/database');

const TinTuc = {
  // Lấy tất cả tin tức hoặc lọc theo Loại
  getAll: (loai, callback) => {
    let sql = 'SELECT * FROM tintuc';
    let params = [];
    if (loai && loai !== 'Tất cả') {
      sql += ' WHERE Loai = ?';
      params.push(loai);
    }
    sql += ' ORDER BY NgayDang DESC';
    db.query(sql, params, callback);
  },

  // Lấy danh sách Tin Hot cho Banner Slider
  getTinHot: (callback) => {
    const sql = 'SELECT * FROM tintuc WHERE TinHot = 1 ORDER BY NgayDang DESC LIMIT 5';
    db.query(sql, callback);
  },

  // Tìm kiếm tin tức theo từ khóa
  search: (keyword, callback) => {
    const sql = 'SELECT * FROM tintuc WHERE TieuDe LIKE ? OR NoiDung LIKE ? ORDER BY NgayDang DESC';
    const searchTerm = `%${keyword}%`;
    db.query(sql, [searchTerm, searchTerm], callback);
  }
};

module.exports = TinTuc;