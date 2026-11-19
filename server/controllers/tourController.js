const tourModel = require("../models/tourModel");

const getAllTours = (req, res) => {
    tourModel.getAllTours((err, results) => {
        if (err) {
            return res.status(500).json({
                message: "Lỗi server khi lấy danh sách tour",
                error: err.message
            });
        }
        res.status(200).json(results);
    });
};

const getTourById = (req, res) => {
    const id = req.params.id;
    tourModel.getTourById(id, (err, result) => {
        if (err) {
            return res.status(500).json({
                message: "Lỗi server khi lấy chi tiết tour",
                error: err.message
            });
        }
        if (!result) {
            return res.status(404).json({ message: "Không tìm thấy tour" });
        }
        res.status(200).json(result);
    });
};

module.exports = {
    getAllTours,
    getTourById
};