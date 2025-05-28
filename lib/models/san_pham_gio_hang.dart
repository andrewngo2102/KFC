import 'package:kfc/models/san_pham.dart';

class SanPhamGioHang {
  final SanPham sanPham;
  int soLuong;

  SanPhamGioHang({
    required this.sanPham,
    this.soLuong = 1,
  });
}
