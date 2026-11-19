class ChiTietTour {
  final int maChiTietTour;
  final int maTour;
  final int? maDiaDiem;
  final String? tenDiaDiem;
  final String thoiGian;
  final String hoatDong;
  final int thuTu;
  final String? ghiChu;

  ChiTietTour({
    required this.maChiTietTour,
    required this.maTour,
    this.maDiaDiem,
    this.tenDiaDiem,
    required this.thoiGian,
    required this.hoatDong,
    required this.thuTu,
    this.ghiChu,
  });

  factory ChiTietTour.fromJson(Map<String, dynamic> json) {
    return ChiTietTour(
      maChiTietTour: int.parse(json['MaChiTietTour'].toString()),
      maTour: int.parse(json['MaTour'].toString()),
      maDiaDiem: json['MaDiaDiem'] != null ? int.parse(json['MaDiaDiem'].toString()) : null,
      tenDiaDiem: json['TenDiaDiem']?.toString(),
      thoiGian: json['ThoiGian']?.toString() ?? '',
      hoatDong: json['HoatDong']?.toString() ?? '',
      thuTu: json['ThuTu'] != null ? int.parse(json['ThuTu'].toString()) : 0,
      ghiChu: json['GhiChu']?.toString(),
    );
  }
}