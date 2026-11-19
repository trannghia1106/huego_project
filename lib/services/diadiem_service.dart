import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/DiaDiem.dart';
import 'UrlHttp.dart';

class DiadiemService {
  //http://10.0.2.2:3000
  final String baseUrl = '${Urlhttp.baseUrl}';
  Future<List<Diadiem>> getAllDiaDiem() async{
    final response = await http.get(
      Uri.parse('$baseUrl/api/diadiem'),
    );

    if(response.statusCode == 200){
      final jsonData = jsonDecode(response.body);
      final List Data = jsonData['data'];
      final List<Diadiem> danhSachDiaDiem = [];
      for(var item in Data){
        Diadiem diadiem = Diadiem.fromJson(item);
        danhSachDiaDiem.add(diadiem);
      }
      return danhSachDiaDiem;
    }else{
      throw Exception("Không thể tải dữ liệu địa điểm");
    }
  }
}