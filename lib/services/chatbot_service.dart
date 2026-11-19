import 'dart:convert';
import 'package:http/http.dart' as http;
import 'UrlHttp.dart';

class ChatbotService {
  // Dùng 10.0.2.2 cho Android Emulator, đổi thành IP LAN (vd: 192.168.1.X) nếu chạy máy thật
  final String baseUrl = '${Urlhttp.baseUrl}/api/chatbot';

  // Lấy 4 câu hỏi gợi ý từ CSDL
  Future<List<String>> getSuggestions() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/suggestions'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((e) => e['CauHoi'].toString()).toList();
      }
    } catch (e) {
      print('Lỗi getSuggestions: $e');
    }
    return [
      'Địa điểm nổi tiếng ở Huế',
      'Địa điểm lịch sử ở Huế',
      'Địa điểm check-in ở Huế',
      'Địa điểm thiên nhiên ở Huế',
    ];
  }

  // Gửi tin nhắn và nhận câu trả lời từ CSDL
  Future<String> askChatbot(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ask'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['reply'];
      }
    } catch (e) {
      print('Lỗi askChatbot: $e');
    }
    return 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra lại mạng!';
  }
}