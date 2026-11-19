import 'package:flutter/material.dart';
import '../Model/Tour.dart';
import '../services/tour_service.dart';

class TourProvider extends ChangeNotifier {
  final TourService _service = TourService();

  List<Tour> _tours = [];
  List<Tour> get tours => _tours;

  List<Tour> _originalList = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  int _selectedFilterIndex = 0;
  int get selectedFilterIndex => _selectedFilterIndex;

  // Lọc tour theo thời lượng (Tất cả, 1 ngày, 2 ngày 1 đêm,...)
  void filterByDuration(int index, String filterName) {
    _selectedFilterIndex = index;
    if (filterName == 'Tất cả') {
      _tours = List.from(_originalList);
    } else {
      _tours = _originalList
          .where((item) => item.thoiLuong.toLowerCase().contains(filterName.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // Tìm kiếm tour
  void searchTour(String query) {
    if (query.trim().isEmpty) {
      _tours = List.from(_originalList);
    } else {
      _tours = _originalList.where((item) {
        final title = item.tenTour.toLowerCase();
        final input = query.toLowerCase();
        return title.contains(input);
      }).toList();
    }
    notifyListeners();
  }

  // Tải danh sách Tour từ API
  Future<void> loadTours() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _service.getAllTours();
      _originalList = data;
      _tours = data;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}