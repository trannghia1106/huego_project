const db = require('../config/database'); // Đường dẫn kết nối CSDL của bạn

const Chatbot = {
  // Lấy các câu hỏi gợi ý chính (MaChatbotCha IS NULL)
  getSuggestions: (callback) => {
    const sql = "SELECT MaChatbot, CauHoi FROM Chatbot WHERE MaChatbotCha IS NULL LIMIT 4";
    db.query(sql, callback);
  },

  // Lấy toàn bộ bộ dữ liệu để so khớp từ khóa
  getAll: (callback) => {
    const sql = "SELECT * FROM Chatbot";
    db.query(sql, callback);
  },

  // Lấy danh sách câu hỏi con dựa theo MaChatbotCha
  getChildrenByParentId: (parentId, callback) => {
    const sql = "SELECT * FROM Chatbot WHERE MaChatbotCha = ?";
    db.query(sql, [parentId], callback);
  }
};

module.exports = Chatbot;