import 'package:flutter/foundation.dart';
import 'package:kfc/models/san_pham.dart';
import 'package:kfc/data/du_lieu_mau.dart';

class TimKiemProvider with ChangeNotifier {
  String _tuKhoa = '';
  String _danhMucId = '';
  String _sapXepTheo = 'mac_dinh'; // mac_dinh, gia_tang, gia_giam
  bool _chiHienKhuyenMai = false;
  
  List<SanPham> _ketQuaTimKiem = [];

  String get tuKhoa => _tuKhoa;
  String get danhMucId => _danhMucId;
  String get sapXepTheo => _sapXepTheo;
  bool get chiHienKhuyenMai => _chiHienKhuyenMai;
  List<SanPham> get ketQuaTimKiem => _ketQuaTimKiem;

  TimKiemProvider() {
    _ketQuaTimKiem = DuLieuMau.danhSachSanPham;
  }

  void datTuKhoa(String tuKhoa) {
    _tuKhoa = tuKhoa;
    _timKiem();
  }

  void datDanhMuc(String danhMucId) {
    _danhMucId = danhMucId;
    _timKiem();
  }

  void datSapXep(String sapXepTheo) {
    _sapXepTheo = sapXepTheo;
    _timKiem();
  }

  void datChiHienKhuyenMai(bool chiHien) {
    _chiHienKhuyenMai = chiHien;
    _timKiem();
  }

  void xoaBoLoc() {
    _tuKhoa = '';
    _danhMucId = '';
    _sapXepTheo = 'mac_dinh';
    _chiHienKhuyenMai = false;
    _timKiem();
  }

  void _timKiem() {
    List<SanPham> ketQua = DuLieuMau.danhSachSanPham;

    // Lọc theo từ khóa
    if (_tuKhoa.isNotEmpty) {
      ketQua = ketQua.where((sp) => 
        sp.ten.toLowerCase().contains(_tuKhoa.toLowerCase()) ||
        sp.moTa.toLowerCase().contains(_tuKhoa.toLowerCase())
      ).toList();
    }

    // Lọc theo danh mục
    if (_danhMucId.isNotEmpty) {
      ketQua = ketQua.where((sp) => sp.danhMucId == _danhMucId).toList();
    }

    // Lọc theo khuyến mãi
    if (_chiHienKhuyenMai) {
      ketQua = ketQua.where((sp) => sp.khuyenMai == true).toList();
    }

    // Sắp xếp
    switch (_sapXepTheo) {
      case 'gia_tang':
        ketQua.sort((a, b) => a.gia.compareTo(b.gia));
        break;
      case 'gia_giam':
        ketQua.sort((a, b) => b.gia.compareTo(a.gia));
        break;
      default:
        // Giữ nguyên thứ tự
        break;
    }

    _ketQuaTimKiem = ketQua;
    notifyListeners();
  }
}
