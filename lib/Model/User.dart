class User {
  final int maNguoiDung;
  final String hoTen;
  final String email;
  final String soDienThoai;
  final String anhDaiDien;
  final String vaiTro;
  final String? ngayTao;
  final int dangNhapGG;

  User({
    required this.maNguoiDung,
    required this.hoTen,
    required this.email,
    required this.soDienThoai,
    required this.anhDaiDien,
    required this.vaiTro,
    required this.ngayTao,
    required this.dangNhapGG
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      maNguoiDung: json['MaNguoiDung'],
      hoTen: json['HoTen'] ?? '',
      email: json['Email'] ?? '',
      soDienThoai: json['SoDienThoai'] ?? '',
      anhDaiDien: json['AnhDaiDien'] ?? '',
      vaiTro: json['VaiTro'] ?? '',
      ngayTao: json['NgayTao']?.toString(),
      dangNhapGG: json['DangNhapGG'] ?? 0,
    );
  }

}