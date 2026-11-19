const db = require("../config/database");

const getAllTours = (callback) => {
    const sql = `
        SELECT
            t.MaTour,
            t.TenTour,
            t.MoTa,
            t.GiaTour,
            t.ThoiLuong,
            t.SoCho,
            t.LichKhoiHanh,
            t.TrangThai,
            (
                SELECT COALESCE(
                    JSON_ARRAYAGG(
                        JSON_OBJECT(
                            'MaMedia', m.MaMedia,
                            'MaTour', m.MaTour,
                            'DuongDan', m.DuongDan,
                            'LoaiMedia', m.LoaiMedia,
                            'MediaChinh', m.MediaChinh,
                            'ThuTu', m.ThuTu
                        )
                    ), '[]'
                )
                FROM mediatour m WHERE m.MaTour = t.MaTour
            ) AS mediaTour,
            (
                SELECT COALESCE(
                    JSON_ARRAYAGG(
                        JSON_OBJECT(
                            'MaChiTietTour', c.MaChiTietTour,
                            'MaTour', c.MaTour,
                            'TenDiaDiem', d.TenDiaDiem,
                            'ThoiGian', c.ThoiGian,
                            'HoatDong', c.HoatDong,
                            'ThuTu', c.ThuTu,
                            'GhiChu', c.GhiChu
                        )
                    ), '[]'
                )
                FROM chitiettour c
                LEFT JOIN diadiem d ON c.MaDiaDiem = d.MaDiaDiem
                WHERE c.MaTour = t.MaTour
            ) AS chiTietTour
        FROM tour t
    `;

    db.query(sql, (err, results) => {
        if (err) return callback(err, null);

        const formattedResults = results.map(row => ({
            ...row,
            mediaTour: typeof row.mediaTour === 'string'
                ? JSON.parse(row.mediaTour)
                : (row.mediaTour || []),
            chiTietTour: typeof row.chiTietTour === 'string'
                ? JSON.parse(row.chiTietTour)
                : (row.chiTietTour || [])
        }));

        callback(null, formattedResults);
    });
};

const getTourById = (id, callback) => {
    const sql = `
        SELECT
            t.MaTour,
            t.TenTour,
            t.MoTa,
            t.GiaTour,
            t.ThoiLuong,
            t.SoCho,
            t.LichKhoiHanh,
            t.TrangThai,
            (
                SELECT COALESCE(
                    JSON_ARRAYAGG(
                        JSON_OBJECT(
                            'MaMedia', m.MaMedia,
                            'MaTour', m.MaTour,
                            'DuongDan', m.DuongDan,
                            'LoaiMedia', m.LoaiMedia,
                            'MediaChinh', m.MediaChinh,
                            'ThuTu', m.ThuTu
                        )
                    ), '[]'
                )
                FROM mediatour m WHERE m.MaTour = t.MaTour
            ) AS mediaTour,
            (
                SELECT COALESCE(
                    JSON_ARRAYAGG(
                        JSON_OBJECT(
                            'MaChiTietTour', c.MaChiTietTour,
                            'MaTour', c.MaTour,
                            'TenDiaDiem', d.TenDiaDiem,
                            'ThoiGian', c.ThoiGian,
                            'HoatDong', c.HoatDong,
                            'ThuTu', c.ThuTu,
                            'GhiChu', c.GhiChu
                        )
                    ), '[]'
                )
                FROM chitiettour c
                LEFT JOIN diadiem d ON c.MaDiaDiem = d.MaDiaDiem
                WHERE c.MaTour = t.MaTour
            ) AS chiTietTour
        FROM tour t
        WHERE t.MaTour = ?
    `;

    db.query(sql, [id], (err, results) => {
        if (err) return callback(err, null);
        if (results.length === 0) return callback(null, null);

        const row = results[0];
        const formattedResult = {
            ...row,
            mediaTour: typeof row.mediaTour === 'string'
                ? JSON.parse(row.mediaTour)
                : (row.mediaTour || []),
            chiTietTour: typeof row.chiTietTour === 'string'
                ? JSON.parse(row.chiTietTour)
                : (row.chiTietTour || [])
        };

        callback(null, formattedResult);
    });
};

module.exports = {
    getAllTours,
    getTourById
};