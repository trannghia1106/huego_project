const db = require('../config/database');

const DatTourModel = {
  // Tạo đơn đặt tour + Thanh toán
  createBookingWithPayment: (data) => {
    return new Promise((resolve, reject) => {
      const { MaNguoiDung, MaTour, TenNguoiDat, EmailNguoiDat, SDTNguoiDat, SoLuong, TongTien, PhuongThuc } = data;

      db.getConnection((err, connection) => {
        if (err) return reject(err);

        connection.beginTransaction((err) => {
          if (err) {
            connection.release();
            return reject(err);
          }

          const queryDatTour = `
            INSERT INTO dattour (MaNguoiDung, MaTour, TenNguoiDat, EmailNguoiDat, SDTNguoiDat, NgayDat, SoLuong, TongTien, TrangThai)
            VALUES (?, ?, ?, ?, ?, NOW(), ?, ?, 'Chờ xác nhận')
          `;
          connection.query(
            queryDatTour,
            [MaNguoiDung, MaTour, TenNguoiDat, EmailNguoiDat, SDTNguoiDat, SoLuong, TongTien],
            (err, resultDatTour) => {
              if (err) {
                return connection.rollback(() => {
                  connection.release();
                  reject(err);
                });
              }

              const maDatTourVuaTao = resultDatTour.insertId;

              const queryThanhToan = `
                INSERT INTO thanhtoan (MaDatTour, SoTien, PhuongThuc, TrangThai, NgayThanhToan)
                VALUES (?, ?, ?, 'Chờ xác nhận', NOW())
              `;
              connection.query(
                queryThanhToan,
                [maDatTourVuaTao, TongTien, PhuongThuc || 'VietQR'],
                (err) => {
                  if (err) {
                    return connection.rollback(() => {
                      connection.release();
                      reject(err);
                    });
                  }

                  connection.commit((err) => {
                    if (err) {
                      return connection.rollback(() => {
                        connection.release();
                        reject(err);
                      });
                    }
                    connection.release();
                    resolve({ success: true, maDatTour: maDatTourVuaTao });
                  });
                }
              );
            }
          );
        });
      });
    });
  },

  // Lấy lịch sử
  getHistoryByUserId: (maNguoiDung) => {
    return new Promise((resolve, reject) => {
      const query = `
        SELECT
          dt.MaDatTour, dt.TenNguoiDat, dt.EmailNguoiDat, dt.SDTNguoiDat,
          dt.NgayDat, dt.SoLuong, dt.TongTien, dt.TrangThai AS TrangThaiDatTour,
          t.MaTour, t.TenTour, t.ThoiLuong, t.LichKhoiHanh,
          MAX(m.DuongDan) AS AnhChinh,
          tt.MaThanhToan, tt.PhuongThuc, tt.TrangThai AS TrangThaiThanhToan, tt.NgayThanhToan
        FROM dattour dt
        JOIN tour t ON dt.MaTour = t.MaTour
        LEFT JOIN mediatour m ON t.MaTour = m.MaTour AND (m.MediaChinh = 1 OR m.MediaChinh IS NULL)
        LEFT JOIN thanhtoan tt ON dt.MaDatTour = tt.MaDatTour
        WHERE dt.MaNguoiDung = ?
        GROUP BY dt.MaDatTour, dt.TenNguoiDat, dt.EmailNguoiDat, dt.SDTNguoiDat, dt.NgayDat, dt.SoLuong, dt.TongTien, dt.TrangThai, t.MaTour, t.TenTour, t.ThoiLuong, t.LichKhoiHanh, tt.MaThanhToan, tt.PhuongThuc, tt.TrangThai, tt.NgayThanhToan
        ORDER BY dt.NgayDat DESC
      `;
      db.query(query, [maNguoiDung], (err, results) => {
        if (err) return reject(err);
        resolve(results);
      });
    });
  }
};

module.exports = DatTourModel;