const db = require("../config/database");

const login = (emailphone, matkhau, callback) => {
    const sql = `
        SELECT
            MaNguoiDung,
            HoTen,
            Email,
            SoDienThoai,
            AnhDaiDien,
            VaiTro,
            NgayTao,
            DangNhapGG
        FROM nguoidung
        WHERE (Email = ? OR SoDienThoai = ?)
        AND MatKhau = ?
        LIMIT 1
    `;

    db.query(sql, [emailphone, emailphone, matkhau], callback);
};
// Tìm người dùng bằng email Google
const loginGoogle = (email, callback) => {
    const sql = `
        SELECT
            MaNguoiDung,
            HoTen,
            Email,
            SoDienThoai,
            AnhDaiDien,
            VaiTro,
            NgayTao,
            DangNhapGG
        FROM nguoidung
        WHERE Email = ?
        LIMIT 1
    `;

    db.query(sql, [email], callback);
};


// Tạo người dùng mới bằng Google
const createGoogleUser = (hoTen, email, anhDaiDien, callback) => {
    const sql = `
        INSERT INTO nguoidung
        (
            HoTen,
            Email,
            AnhDaiDien,
            VaiTro,
            DangNhapGG
        )
        VALUES (?, ?, ?, 'User', 1)
    `;

    db.query(
        sql,
        [hoTen, email, anhDaiDien],
        callback
    );
};

const updateGoogleUser = (email, hoTen, anhDaiDien, callback) => {

    console.log("=== UPDATE GOOGLE ===");
    console.log("email:", email);
    console.log("hoTen:", hoTen);
    console.log("anhDaiDien:", anhDaiDien);
    console.log("UPDATE:", email, hoTen, anhDaiDien);
    const sql = `
        UPDATE nguoidung
        SET HoTen = ?,
            AnhDaiDien = ?,
            DangNhapGG = 1
        WHERE Email = ?
    `;

    db.query(
        sql,
        [hoTen, anhDaiDien, email],
        (err, result) => {

            console.log("UPDATE RESULT:", result);
            console.log("UPDATE ERROR:", err);

            callback(err, result);
        }
    );
};

module.exports = {
    login,
    loginGoogle,
    createGoogleUser,
    updateGoogleUser
};