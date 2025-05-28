class NguoiDung {
  final String id;
  final String ten;
  final String email;
  final String soDienThoai;
  final String? diaChi;
  final String? avatar;

  NguoiDung({
    required this.id,
    required this.ten,
    required this.email,
    required this.soDienThoai,
    this.diaChi,
    this.avatar,
  });
}
