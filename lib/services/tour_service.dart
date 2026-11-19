import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/Tour.dart';
import 'UrlHttp.dart';

class TourService {
  // Thay đổi IP này theo IP máy của bạn khi test trên thiết bị thật/giả lập
  final String baseUrl = "${Urlhttp.baseUrl}/api/tours";

  // 1. Lấy tất cả Tour
  Future<List<Tour>> getAllTours() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((item) => Tour.fromJson(item)).toList();
      } else {
        throw Exception("Không thể tải danh sách Tour");
      }
    } catch (e) {
      throw Exception("Lỗi kết nối Server: $e");
    }
  }

  // 2. Lấy chi tiết 1 Tour (Phục vụ Màn hình Chi tiết / Đặt Tour)
  Future<Tour?> getTourById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return Tour.fromJson(body);
      } else {
        throw Exception("Không tìm thấy Tour");
      }
    } catch (e) {
      throw Exception("Lỗi kết nối Server: $e");
    }
  }
}