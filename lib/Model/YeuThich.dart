class YeuThich {
  final int? maYeuThich;
  final int maNguoiDung;
  final int maDiaDiem;
  final DateTime? ngayThem;

  YeuThich({
    this.maYeuThich,
    required this.maNguoiDung,
    required this.maDiaDiem,
    this.ngayThem,
  });

  // Chuyển dữ liệu từ JSON (Backend trả về) sang Object Dart
  factory YeuThich.fromJson(Map<String, dynamic> json) {
    return YeuThich(
      maYeuThich: json['MaYeuThich'] ?? json['maYeuThich'],
      maNguoiDung: json['MaNguoiDung'] ?? json['maNguoiDung'],
      maDiaDiem: json['MaDiaDiem'] ?? json['maDiaDiem'],
      ngayThem: json['NgayThem'] != null
          ? DateTime.parse(json['NgayThem'])
          : null,
    );
  }

  // Chuyển từ Object Dart sang JSON (để gửi request API)
  Map<String, dynamic> toJson() {
    return {
      if (maYeuThich != null) 'maYeuThich': maYeuThich,
      'maNguoiDung': maNguoiDung,
      'maDiaDiem': maDiaDiem,
      'ngayThem': ngayThem?.toIso8601String(),
    };
  }
}