import 'package:flutter/material.dart';
import '../Model/DiaDiem.dart';
import '../services/diadiem_service.dart';

class DiadiemProvider extends ChangeNotifier{
  final DiadiemService _service = DiadiemService();
  List<Diadiem> _diaDiem = [];
  List<Diadiem> get diaDiem => _diaDiem;
  List<Diadiem> _originalList = [];

  bool _isLoading = false;
  bool get  isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  //lọc theo maDanhMuc (nhận vào null hoặc ID)
  void filterByCategoryID(int? categoryId){
    if(categoryId == null){
      _diaDiem = List.from(_originalList);
    }else{
      _diaDiem = _originalList
          .where((item) => item.maDanhMuc == categoryId)
          .toList();
    }
    notifyListeners();
  }

  //search địa điểm
  void searchDiaDiem(String query) {
    if (query.trim().isEmpty) {
      _diaDiem = List.from(_originalList);
    } else {
      _diaDiem = _originalList.where((item) {
        final title = item.tenDiaDiem.toLowerCase();
        final address = item.diaChi.toLowerCase();
        final input = query.toLowerCase();
        return title.contains(input) || address.contains(input);
      }).toList();
    }
    notifyListeners();
  }
  Future<void> loadDiaDiem() async{
    _isLoading = true;
    _error = null;
    notifyListeners();
    try{
      final data = await _service.getAllDiaDiem();
      _originalList = data;
      _diaDiem = data;
    }catch(e){
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}