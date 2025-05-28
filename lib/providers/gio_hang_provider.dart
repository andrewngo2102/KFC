import 'package:flutter/foundation.dart';
import 'package:kfc/models/san_pham.dart';
import 'package:kfc/models/san_pham_gio_hang.dart';

class GioHangProvider with ChangeNotifier {
  final List<SanPhamGioHang> _danhSachSanPham = [];

  List<SanPhamGioHang> get danhSachSanPham => _danhSachSanPham;

  int get tongSoLuong {
    return _danhSachSanPham.fold(0, (sum, item) => sum + item.soLuong);
  }

  int get tongTien {
    return _danhSachSanPham.fold(
      0,
      (sum, item) => sum + (item.sanPham.gia * item.soLuong),
    );
  }

  void themSanPham(SanPham sanPham) {
    final index = _danhSachSanPham.indexWhere(
      (item) => item.sanPham.id == sanPham.id,
    );

    if (index >= 0) {
      _danhSachSanPham[index].soLuong += 1;
    } else {
      _danhSachSanPham.add(
        SanPhamGioHang(
          sanPham: sanPham,
          soLuong: 1,
        ),
      );
    }

    notifyListeners();
  }

  void xoaSanPham(String sanPhamId) {
    _danhSachSanPham.removeWhere((item) => item.sanPham.id == sanPhamId);
    notifyListeners();
  }

  void tangSoLuong(String sanPhamId) {
    final index = _danhSachSanPham.indexWhere(
      (item) => item.sanPham.id == sanPhamId,
    );

    if (index >= 0) {
      _danhSachSanPham[index].soLuong += 1;
      notifyListeners();
    }
  }

  void giamSoLuong(String sanPhamId) {
    final index = _danhSachSanPham.indexWhere(
      (item) => item.sanPham.id == sanPhamId,
    );

    if (index >= 0) {
      if (_danhSachSanPham[index].soLuong > 1) {
        _danhSachSanPham[index].soLuong -= 1;
      } else {
        _danhSachSanPham.removeAt(index);
      }
      notifyListeners();
    }
  }

  void xoaGioHang() {
    _danhSachSanPham.clear();
    notifyListeners();
  }

  void xacNhanDatHang() {
    // Trong thực tế, bạn sẽ gửi đơn hàng lên Firebase ở đây
    // Sau đó xóa giỏ hàng
    xoaGioHang();
  }
}
