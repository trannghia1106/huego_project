const express = require("express");
const cors = require("cors");

const db = require("./config/database");
const diadiemRoutes = require("./routes/diadiem");
const nguoidungRoutes = require("./routes/nguoidung");
const yeuThichRoute = require('./routes/yeuthich');
const chatbotRoute = require('./routes/chatbot');
const tourRoutes = require('./routes/tour');
const datTourRoute = require('./routes/datTour');
const tintucRoute = require('./routes/tintuc');

const app = express();

app.use(cors());
app.use(express.json());

// Test server
app.get("/", (req, res) => {
    res.json({
        message: "HueGo API đang chạy!"
    });
});

// Route địa điểm
app.use("/api/diadiem", diadiemRoutes);
// Route địa điểm Đăng nhập
app.use("/api/nguoidung", nguoidungRoutes);
//Route yêu thích
app.use('/api/yeuthich', yeuThichRoute);
//Route chatbot
app.use('/api/chatbot', chatbotRoute);
// Đăng ký API Tour
app.use('/api/tours', tourRoutes);
// Đặt tour
app.use('/api/dat-tour', datTourRoute);
// Tin tức
app.use('/api/tintuc', tintucRoute);
const PORT = 3000;

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server đang chạy tại http://localhost:${PORT}`);
});