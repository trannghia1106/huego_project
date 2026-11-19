const db = require("../config/database");

const getAllDiaDiem = (callback) => {
    const sql = `
        SELECT
            d.MaDiaDiem,
            d.TenDiaDiem,
            d.MoTa,
            d.DiaChi,
            d.KinhDo,
            d.ViDo,
            d.GioMoCua,
            d.GioDongCua,
            d.GiaVe,
            d.MaDanhMuc,
            d.TrangThai,
            -- Gom danh sách media thành mảng JSON
            IF(COUNT(m.MaMedia) > 0,
                CONCAT('[',
                    GROUP_CONCAT(
                        JSON_OBJECT(
                            'MaMedia', m.MaMedia,
                            'MaDiaDiem', m.MaDiaDiem,
                            'DuongDan', m.DuongDan,
                            'LoaiMedia', m.LoaiMedia,
                            'MediaChinh', m.MediaChinh,
                            'ThuTu', m.ThuTu
                        )
                        ORDER BY m.ThuTu ASC
                    ),
                ']'),
                '[]'
            ) AS MediaDiaDiem
        FROM diadiem d
        LEFT JOIN mediadiadiem m ON d.MaDiaDiem = m.MaDiaDiem
        GROUP BY d.MaDiaDiem
    `;

    db.query(sql, (err, results) => {
            if (err) return callback(err, null);

            // Convert chuỗi JSON MediaDiaDiem sang Array thật trước khi trả về Client
            const formattedResults = results.map(row => ({
                ...row,
                MediaDiaDiem: typeof row.MediaDiaDiem === 'string'
                    ? JSON.parse(row.MediaDiaDiem)
                    : row.MediaDiaDiem
            }));

            callback(null, formattedResults);
    });
};

module.exports = {
    getAllDiaDiem
};