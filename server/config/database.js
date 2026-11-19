const mysql = require("mysql2");

const db = mysql.createPool({
    host: "localhost",
    user: "root",
    password: "nghianghia123",
    database: "huego",
    port: 3306
});

db.getConnection((err, connection) => {
    if (err) {
        console.log("Lỗi kết nối MySQL:", err.message);
        return;
    }

    console.log("Kết nối MySQL thành công");
    connection.release();
});

module.exports = db;