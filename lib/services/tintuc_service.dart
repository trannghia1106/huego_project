import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/TinTuc.dart';
import 'UrlHttp.dart';

class TinTucService {
  // Thay 10.0.2.2 bằng IP máy tính của bạn nếu chạy máy thật
  static const String baseUrl = '${Urlhttp.baseUrl}/api/tintuc';

  // Lấy tất cả hoặc theo loại
  static Future<List<TinTucModel>> fetchTinTuc({String loai = 'Tất cả'}) async {
    final response = await http.get(Uri.parse('$baseUrl?loai=$loai'));
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      List list = data['data'];
      return list.map((e) => TinTucModel.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi kết nối API');
    }
  }

  // Lấy danh sách Tin Hot cho Banner
  static Future<List<TinTucModel>> fetchTinHot() async {
    final response = await http.get(Uri.parse('$baseUrl/hot'));
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      List list = data['data'];
      return list.map((e) => TinTucModel.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi lấy tin hot');
    }
  }

  // Tìm kiếm tin tức
  static Future<List<TinTucModel>> searchTinTuc(String keyword) async {
    final response = await http.get(Uri.parse('$baseUrl/search?keyword=$keyword'));
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      List list = data['data'];
      return list.map((e) => TinTucModel.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi tìm kiếm');
    }
  }

  // Lấy 5 sự kiện mới nhất (Lấy tất cả rồi tự lọc an toàn)
  static Future<List<TinTucModel>> fetchSuKienMoiNhat() async {
    try {
      // 1. Gọi lấy toàn bộ danh sách bài viết
      List<TinTucModel> allNews = await fetchTinTuc(loai: 'Tất cả');

      // 2. Lọc linh hoạt theo loại "Sự kiện" (bỏ qua hoa/thường & khoảng trắng)
      List<TinTucModel> suKienList = allNews.where((item) {
        String loaiClean = item.loai.trim().toLowerCase();
        return loaiClean.contains('sự kiện') ||
            loaiClean.contains('su kien') ||
            loaiClean == 'sự kiện';
      }).toList();

      // 3. Nếu không tìm thấy bài nào có loại "Sự kiện", lấy tạm 5 bài mới nhất để không bị trống UI
      if (suKienList.isEmpty) {
        return allNews.take(5).toList();
      }

      // 4. Trả về tối đa 5 sự kiện
      return suKienList.take(5).toList();
    } catch (e) {
      throw Exception('Lỗi lấy danh sách sự kiện: $e');
    }
  }
}