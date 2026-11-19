const DatTourModel = require('../models/datTourModel');

const datTourController = {
  // 1. Tạo đơn đặt tour
  taoDonDatTour: async (req, res) => {
    try {
      // ĐÃ THÊM: Bóc tách 3 trường thông tin người đặt từ req.body
      const {
        MaNguoiDung,
        MaTour,
        TenNguoiDat,
        EmailNguoiDat,
        SDTNguoiDat,
        SoLuong,
        TongTien,
        PhuongThuc
      } = req.body;

      if (!MaNguoiDung || !MaTour || !SoLuong || !TongTien) {
        return res.status(400).json({
          status: false,
          message: 'Thiếu thông tin đặt tour bắt buộc!',
        });
      }

      // ĐÃ THÊM: Truyền 3 trường mới này vào Model
      const result = await DatTourModel.createBookingWithPayment({
        MaNguoiDung,
        MaTour,
        TenNguoiDat,
        EmailNguoiDat,
        SDTNguoiDat,
        SoLuong,
        TongTien,
        PhuongThuc,
      });

      return res.status(200).json({
        status: true,
        message: 'Đặt tour thành công!',
        maDatTour: result.maDatTour,
      });
    } catch (error) {
      console.error('Lỗi khi đặt tour:', error);
      return res.status(500).json({ status: false, message: 'Lỗi máy chủ: ' + error.message });
    }
  },

  // 2. Lấy lịch sử
  layLichSuDatTour: async (req, res) => {
    try {
      const { maNguoiDung } = req.params;
      const history = await DatTourModel.getHistoryByUserId(maNguoiDung);

      return res.status(200).json({
        status: true,
        data: history,
      });
    } catch (error) {
      console.error('Lỗi lấy lịch sử:', error);
      return res.status(500).json({ status: false, message: 'Lỗi máy chủ: ' + error.message });
    }
  },

  // 3. Lấy chi tiết đơn
  layChiTietDonTour: async (req, res) => {
    try {
      const { maDatTour } = req.params;
      const detail = await DatTourModel.getBookingDetail(maDatTour);

      if (!detail) {
        return res.status(404).json({ status: false, message: 'Không tìm thấy đơn đặt tour' });
      }

      return res.status(200).json({
        status: true,
        data: detail,
      });
    } catch (error) {
      console.error('Lỗi lấy chi tiết:', error);
      return res.status(500).json({ status: false, message: 'Lỗi máy chủ: ' + error.message });
    }
  }
};

module.exports = datTourController;