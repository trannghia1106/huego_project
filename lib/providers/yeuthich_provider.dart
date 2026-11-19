import 'package:flutter/material.dart';
import '../Model/YeuThich.dart';
import '../services/yeuthich_service.dart';

class YeuThichProvider extends ChangeNotifier {
  final YeuThichService _service = YeuThichService();

  // Set lưu danh sách maDiaDiem đã thích để kiểm tra nhanh on UI
  final Set<int> _favoriteIds = {};
  Set<int> get favoriteIds => _favoriteIds;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // 1. Tải danh sách các mã địa điểm đã thích từ Server
  // lib/providers/yeuthich_provider.dart

  Future<void> loadFavorites(int maNguoiDung) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Service giờ đây trả về thẳng List<int> các ID địa điểm
      final listIds = await _service.getFavoritesByUser(maNguoiDung);

      _favoriteIds.clear();
      _favoriteIds.addAll(listIds);
      print("Danh sách ID đã lưu yêu thích: $_favoriteIds"); // In ra debug kiểm tra
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners(); // Thông báo UI hiển thị ngay tim đỏ
  }

  // 2. Thêm hoặc Bỏ yêu thích
  Future<void> toggleFavorite(int maNguoiDung, int maDiaDiem) async {
    final isFav = _favoriteIds.contains(maDiaDiem);

    if (isFav) {
      // Bỏ thích tạm thời trên UI (Cập nhật tức thì)
      _favoriteIds.remove(maDiaDiem);
      notifyListeners();

      // Gọi API xóa ở Server
      bool success = await _service.removeFavorite(maNguoiDung, maDiaDiem);
      if (!success) {
        _favoriteIds.add(maDiaDiem); // Revert nếu lỗi
        notifyListeners();
      }
    } else {
      // Thêm thích trên UI
      _favoriteIds.add(maDiaDiem);
      notifyListeners();

      // Gọi API thêm ở Server
      final newYeuThich = YeuThich(
        maNguoiDung: maNguoiDung,
        maDiaDiem: maDiaDiem,
        ngayThem: DateTime.now(),
      );

      bool success = await _service.addFavorite(newYeuThich);
      if (!success) {
        _favoriteIds.remove(maDiaDiem); // Revert nếu lỗi
        notifyListeners();
      }
    }
  }

  // Kiểm tra địa điểm này có được thích chưa
  bool isFavorite(int maDiaDiem) {
    return _favoriteIds.contains(maDiaDiem);
  }
}