class MediaDiaDiem {
  final int maMedia;
  final int maDiaDiem;
  final String duongDan;
  final String loaiMedia;
  final bool isMediaChinh;
  final int thuTu;

  MediaDiaDiem({
    required this.maMedia,
    required this.maDiaDiem,
    required this.duongDan,
    required this.loaiMedia,
    required this.isMediaChinh,
    required this.thuTu,
  });

  factory MediaDiaDiem.fromJson(Map<String, dynamic> json) {
    return MediaDiaDiem(
      maMedia: int.parse(json['MaMedia'].toString()),
      maDiaDiem: int.parse(json['MaDiaDiem'].toString()),
      duongDan: json['DuongDan'].toString(),
      loaiMedia: json['LoaiMedia'].toString(),
      isMediaChinh: json['MediaChinh'].toString() == '1' || json['MediaChinh'] == true,
      thuTu: int.parse(json['ThuTu'].toString()),
    );
  }
}

class Diadiem {
  final int maDiaDiem;
  final String tenDiaDiem;
  final String moTa;
  final String diaChi;
  final double kinhDo;
  final double viDo;
  final String gioMoCua;
  final String? gioDongCua; // Cho phép null để tránh lỗi crash
  final double giaVe;
  final int maDanhMuc;
  final String trangThai;
  final List<MediaDiaDiem> dsMedia; // Danh sách ảnh/video

  Diadiem({
    required this.maDiaDiem,
    required this.tenDiaDiem,
    required this.moTa,
    required this.diaChi,
    required this.kinhDo,
    required this.viDo,
    required this.gioMoCua,
    this.gioDongCua,
    required this.giaVe,
    required this.maDanhMuc,
    required this.trangThai,
    required this.dsMedia,
  });

  // Getter hỗ trợ lấy ảnh đại diện (MediaChinh = 1)
  String get anhChinh {
    if (dsMedia.isEmpty) return 'https://via.placeholder.com/400x280';
    final media = dsMedia.firstWhere(
          (m) => m.isMediaChinh,
      orElse: () => dsMedia.first,
    );
    return media.duongDan;
  }

  factory Diadiem.fromJson(Map<String, dynamic> json) {
    // Parse danh sách MediaDiaDiem từ JSON backend trả về
    var mediaList = <MediaDiaDiem>[];
    if (json['MediaDiaDiem'] != null && json['MediaDiaDiem'] is List) {
      mediaList = (json['MediaDiaDiem'] as List)
          .map((m) => MediaDiaDiem.fromJson(m))
          .toList();
    }

    return Diadiem(
      maDiaDiem: int.parse(json['MaDiaDiem'].toString()),
      tenDiaDiem: json['TenDiaDiem'].toString(),
      moTa: json['MoTa'].toString(),
      diaChi: json['DiaChi'].toString(),
      kinhDo: double.parse(json['KinhDo'].toString()),
      viDo: double.parse(json['ViDo'].toString()),
      gioMoCua: json['GioMoCua'].toString(),
      gioDongCua: (json['GioDongCua'] == null || json['GioDongCua'].toString() == 'null')
          ? null
          : json['GioDongCua'].toString(),
      giaVe: double.parse(json['GiaVe'].toString()),
      maDanhMuc: int.parse(json['MaDanhMuc'].toString()),
      trangThai: json['TrangThai'].toString(),
      dsMedia: mediaList,
    );
  }
}