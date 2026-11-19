import 'package:flutter/foundation.dart';
import 'ChiTietTour.dart';

class MediaTour {
  final int maMedia;
  final int maTour;
  final String duongDan;
  final String loaiMedia;
  final bool isMediaChinh;
  final int thuTu;

  MediaTour({
    required this.maMedia,
    required this.maTour,
    required this.duongDan,
    required this.loaiMedia,
    required this.isMediaChinh,
    required this.thuTu,
  });

  factory MediaTour.fromJson(Map<String, dynamic> json) {
    return MediaTour(
      maMedia: int.parse(json['MaMedia'].toString()),
      maTour: int.parse(json['MaTour'].toString()),
      duongDan: json['DuongDan'].toString(),
      loaiMedia: json['LoaiMedia'].toString(),
      isMediaChinh: json['MediaChinh'].toString() == '1' || json['MediaChinh'] == true,
      thuTu: int.parse(json['ThuTu'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaMedia': maMedia,
      'MaTour': maTour,
      'DuongDan': duongDan,
      'LoaiMedia': loaiMedia,
      'MediaChinh': isMediaChinh ? 1 : 0,
      'ThuTu': thuTu,
    };
  }
}

class Tour {
  final int maTour;
  final String tenTour;
  final String moTa;
  final double giaTour;
  final String thoiLuong;
  final int soCho;
  final String? lichKhoiHanh;
  final String trangThai;
  final List<MediaTour> mediaTour;
  final List<ChiTietTour> chiTietTour;
  // Getter lấy ảnh đại diện chính (isMediaChinh == true) giống Diadiem
  String get anhChinh {
    if (mediaTour.isEmpty) return 'https://via.placeholder.com/400x280';
    final media = mediaTour.firstWhere(
          (m) => m.isMediaChinh,
      orElse: () => mediaTour.first,
    );
    return media.duongDan;
  }
  Tour({
    required this.maTour,
    required this.tenTour,
    required this.moTa,
    required this.giaTour,
    required this.thoiLuong,
    required this.soCho,
    this.lichKhoiHanh,
    required this.trangThai,
    required this.mediaTour,
    required this.chiTietTour,
  });

  factory Tour.fromJson(Map<String, dynamic> json) {
    var mediaList = <MediaTour>[];
    var rawMedia = json['mediaTour'] ?? json['MediaTour'];
    if (rawMedia != null && rawMedia is List) {
      mediaList = rawMedia.map((m) => MediaTour.fromJson(m)).toList();
    }

    var chiTietList = <ChiTietTour>[];
    var rawChiTiet = json['chiTietTour'] ?? json['ChiTietTour'];
    if (rawChiTiet != null && rawChiTiet is List) {
      chiTietList = rawChiTiet.map((c) => ChiTietTour.fromJson(c)).toList();
      chiTietList.sort((a, b) => a.thuTu.compareTo(b.thuTu));
    }

    return Tour(
      maTour: int.parse(json['MaTour'].toString()),
      tenTour: json['TenTour'].toString(),
      moTa: json['MoTa'].toString(),
      giaTour: double.parse(json['GiaTour'].toString()),
      thoiLuong: json['ThoiLuong'].toString(),
      soCho: json['SoCho'] != null ? int.parse(json['SoCho'].toString()) : 0,
      lichKhoiHanh: (json['LichKhoiHanh'] == null || json['LichKhoiHanh'].toString() == 'null')
          ? null
          : json['LichKhoiHanh'].toString(),
      trangThai: json['TrangThai'].toString(),
      mediaTour: mediaList,
      chiTietTour: chiTietList,
    );
  }
}