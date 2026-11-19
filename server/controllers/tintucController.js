const TinTuc = require('../models/tintucModel');

exports.getAllTinTuc = (req, res) => {
  const loai = req.query.loai;
  TinTuc.getAll(loai, (err, results) => {
    if (err) return res.status(500).json({ success: false, message: err.message });
    res.status(200).json({ success: true, data: results });
  });
};

exports.getTinHot = (req, res) => {
  TinTuc.getTinHot((err, results) => {
    if (err) return res.status(500).json({ success: false, message: err.message });
    res.status(200).json({ success: true, data: results });
  });
};

exports.searchTinTuc = (req, res) => {
  const keyword = req.query.keyword || '';
  TinTuc.search(keyword, (err, results) => {
    if (err) return res.status(500).json({ success: false, message: err.message });
    res.status(200).json({ success: true, data: results });
  });
};