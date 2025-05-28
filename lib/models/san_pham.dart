class SanPham {
  final String id;
  final String ten;
  final int gia;
  final String hinhAnh;
  final String moTa;
  final String? danhMucId;
  final bool? khuyenMai;
  final int? giamGia;

  SanPham({
    required this.id,
    required this.ten,
    required this.gia,
    required this.hinhAnh,
    required this.moTa,
    this.danhMucId,
    this.khuyenMai = false,
    this.giamGia,
  });
}
