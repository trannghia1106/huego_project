const diadiemModel = require("../models/diadiemModel");

const getAllDiaDiem = (req, res) => {
    diadiemModel.getAllDiaDiem((err, results) => {
        if (err) {
            console.error("Lỗi lấy danh sách địa điểm:", err);

            return res.status(500).json({
                success: false,
                message: "Lỗi lấy dữ liệu địa điểm"
            });
        }

        res.json({
            success: true,
            data: results
        });
    });
};

module.exports = {
    getAllDiaDiem
};