class TinTucModel {
  final int maTinTuc;
  final String tieuDe;
  final String noiDung;
  final String hinhAnh;
  final String loai;
  final String ngayDang;
  final String? ngayBatDau;
  final String? ngayKetThuc;
  final String? diaDiemToChuc;
  final int? tinHot;

  TinTucModel({
    required this.maTinTuc,
    required this.tieuDe,
    required this.noiDung,
    required this.hinhAnh,
    required this.loai,
    required this.ngayDang,
    this.ngayBatDau,
    this.ngayKetThuc,
    this.diaDiemToChuc,
    this.tinHot,
  });

  factory TinTucModel.fromJson(Map<String, dynamic> json) {
    String formatDate(dynamic date) {
      if (date == null) return '';
      return date.toString().split('T')[0];
    }

    return TinTucModel(
      maTinTuc: json['MaTinTuc'],
      tieuDe: json['TieuDe'] ?? '',
      noiDung: json['NoiDung'] ?? '',
      hinhAnh: json['HinhAnh'] ?? '',
      loai: json['Loai'] ?? '',
      ngayDang: formatDate(json['NgayDang']),
      ngayBatDau: formatDate(json['NgayBatDau']),
      ngayKetThuc: formatDate(json['NgayKetThuc']),
      diaDiemToChuc: json['DiaDiemToChuc'],
      tinHot: json['TinHot'],
    );
  }

  // Chuỗi ghép Thời gian tổ chức (Ví dụ: 07/06/2025 - 12/06/2025)
  String get thoiGianToChuc {
    if (ngayBatDau != null && ngayBatDau!.isNotEmpty) {
      if (ngayKetThuc != null && ngayKetThuc!.isNotEmpty) {
        return '$ngayBatDau - $ngayKetThuc';
      }
      return ngayBatDau!;
    }
    return '';
  }
}