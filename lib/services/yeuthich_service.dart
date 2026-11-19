import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/YeuThich.dart';
import 'UrlHttp.dart';

class YeuThichService {
  // Thay thế bằng IP phù hợp với môi trường chạy (Emulator: 10.0.2.2, Máy thật: IP Wifi)
  static const String baseUrl = '${Urlhttp.baseUrl}/api/yeuthich';

  // 1. Lấy danh sách YeuThich theo ID người dùng
  // lib/services/yeuthich_service.dart

  Future<List<int>> getFavoritesByUser(int maNguoiDung) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$maNguoiDung'));
      if (response.statusCode == 200) {
        // Backend trả về mảng số nguyên [1, 3, 9]
        List<dynamic> data = json.decode(response.body);
        return data.map<int>((e) => e as int).toList();
      }
    } catch (e) {
      print("Lỗi getFavoritesByUser: $e");
    }
    return [];
  }

  // 2. Thêm Yêu thích bằng Model
  Future<bool> addFavorite(YeuThich yeuThich) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(yeuThich.toJson()),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Lỗi addFavorite: $e");
      return false;
    }
  }

  // 3. Xóa Yêu thích
  Future<bool> removeFavorite(int maNguoiDung, int maDiaDiem) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl?maNguoiDung=$maNguoiDung&maDiaDiem=$maDiaDiem'),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Lỗi removeFavorite: $e");
      return false;
    }
  }
}