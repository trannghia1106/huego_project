const Chatbot = require('../models/chatbotModel');

exports.getSuggestions = (req, res) => {
  Chatbot.getSuggestions((err, results) => {
    if (err) return res.status(500).json({ success: false, error: err.message });
    res.json(results);
  });
};

exports.askChatbot = (req, res) => {
  const { message } = req.body;
  if (!message) {
    return res.status(400).json({ success: false, error: 'Tin nhắn không được để trống' });
  }

  Chatbot.getAll((err, results) => {
    if (err) return res.status(500).json({ success: false, error: err.message });

    const userMessage = message.trim().toLowerCase();
    let bestMatch = null;

    // 1. Kiểm tra nếu tin nhắn người dùng có CÓ CHỨA (contains) CauHoi trong DB
    for (let item of results) {
      if (item.CauHoi && userMessage.includes(item.CauHoi.trim().toLowerCase())) {
        bestMatch = item;
        break;
      }
    }

    // 2. Nếu không có CauHoi nào chứa, kiểm tra xem tin nhắn CÓ CHỨA (contains) TuKhoa nào không
    if (!bestMatch) {
      for (let item of results) {
        if (item.TuKhoa) {
          const keywords = item.TuKhoa.split(',').map(k => k.trim().toLowerCase());
          if (keywords.some(k => userMessage.includes(k))) {
            bestMatch = item;
            break;
          }
        }
      }
    }

    // Trả kết quả
    if (bestMatch) {
      return res.json({
        success: true,
        reply: bestMatch.CauTraLoi,
        maChatbot: bestMatch.MaChatbot
      });
    } else {
      return res.json({
        success: false,
        reply: 'Xin lỗi, tôi chưa có câu trả lời cho bạn. Bạn có thể liên hệ hotline 0934791106 để biết thêm chi tiết nhé.'
      });
    }
  });
};