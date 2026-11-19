const nguoidungModel = require("../models/nguoidungModel");
const login = (req, res) => {
    const { emailphone, matkhau } = req.body;

    if (!emailphone || !matkhau) {
        return res.status(400).json({
            success: false,
            message: "Vui lòng nhập đầy đủ tài khoản và mật khẩu"
        });
    }

    nguoidungModel.login(emailphone, matkhau, (err, results) => {
        if (err) {
            console.error("Lỗi đăng nhập:", err);

            return res.status(500).json({
                success: false,
                message: "Lỗi đăng nhập"
            });
        }

        if (results.length === 0) {
            return res.status(401).json({
                success: false,
                message: "Tài khoản hoặc mật khẩu không đúng"
            });
        }

        res.json({
            success: true,
            message: "Đăng nhập thành công",
            data: results[0]
        });
    });
};

// Đăng nhập bằng Google
const loginGoogle = (req, res) => {
    console.log("🔥 GOOGLE LOGIN CONTROLLER ĐÃ ĐƯỢC GỌI");
    console.log("BODY:", req.body);
    const { email, hoTen, anhDaiDien } = req.body;

    if (!email) {
        return res.status(400).json({
            success: false,
            message: "Không nhận được email Google"
        });
    }

    nguoidungModel.loginGoogle(email, (err, results) => {

        if (err) {
            console.error("Lỗi kiểm tra tài khoản Google:", err);

            return res.status(500).json({
                success: false,
                message: "Lỗi kiểm tra tài khoản"
            });
        }

        // Đã có tài khoản
        if (results.length > 0) {

            const user = results[0];
            console.log("ĐÃ VÀO NHÁNH USER ĐÃ TỒN TẠI");
            console.log("EMAIL:", email);
            console.log("HOTEN:", hoTen);
            nguoidungModel.updateGoogleUser(
                email,
                hoTen,
                anhDaiDien,
                (err) => {

                    if (err) {
                        console.error("Lỗi cập nhật tài khoản Google:", err);

                        return res.status(500).json({
                            success: false,
                            message: "Lỗi cập nhật tài khoản Google"
                        });
                    }

                    nguoidungModel.loginGoogle(email, (err, updatedResults) => {

                        if (err) {
                            console.error("Lỗi lấy user sau khi update:", err);

                            return res.status(500).json({
                                success: false,
                                message: "Lỗi lấy thông tin người dùng"
                            });
                        }

                        return res.json({
                            success: true,
                            message: "Đăng nhập Google thành công",
                            data: updatedResults[0]
                        });
                    });
                }
            );

            return;
        }

        // Chưa có tài khoản → tạo mới
        nguoidungModel.createGoogleUser(
            hoTen || "",
            email,
            anhDaiDien || "",
            (err, result) => {

                if (err) {
                    console.error("Lỗi tạo tài khoản Google:", err);

                    return res.status(500).json({
                        success: false,
                        message: "Không thể tạo tài khoản Google"
                    });
                }

                // Lấy lại user vừa tạo
                nguoidungModel.loginGoogle(email, (err, results) => {

                    if (err || results.length === 0) {
                        return res.status(500).json({
                            success: false,
                            message: "Không thể lấy thông tin người dùng"
                        });
                    }

                    res.json({
                        success: true,
                        message: "Tạo tài khoản Google thành công",
                        data: results[0]
                    });
                });
            }
        );
    });
};


module.exports = {
    login,
    loginGoogle
};