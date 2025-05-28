import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:kfc/models/san_pham.dart';

class XemGanDayProvider with ChangeNotifier {
  List<SanPham> _danhSachXemGanDay = [];
  final int _soLuongToiDa = 10;

  List<SanPham> get danhSachXemGanDay => _danhSachXemGanDay;

  XemGanDayProvider() {
    _taiDanhSachXemGanDay();
  }

  Future<void> _taiDanhSachXemGanDay() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final danhSachJson = prefs.getStringList('danh_sach_xem_gan_day') ?? [];
      
      _danhSachXemGanDay = danhSachJson.map((json) {
        final Map<String, dynamic> data = jsonDecode(json);
        return SanPham(
          id: data['id'],
          ten: data['ten'],
          gia: data['gia'],
          hinhAnh: data['hinhAnh'],
          moTa: data['moTa'],
          danhMucId: data['danhMucId'],
          khuyenMai: data['khuyenMai'],
          giamGia: data['giamGia'],
        );
      }).toList();
      
      notifyListeners();
    } catch (e) {
      print('Lỗi khi tải danh sách xem gần đây: $e');
    }
  }

  Future<void> _luuDanhSachXemGanDay() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final danhSachJson = _danhSachXemGanDay.map((sanPham) {
        return jsonEncode({
          'id': sanPham.id,
          'ten': sanPham.ten,
          'gia': sanPham.gia,
          'hinhAnh': sanPham.hinhAnh,
          'moTa': sanPham.moTa,
          'danhMucId': sanPham.danhMucId,
          'khuyenMai': sanPham.khuyenMai,
          'giamGia': sanPham.giamGia,
        });
      }).toList();
      
      await prefs.setStringList('danh_sach_xem_gan_day', danhSachJson);
    } catch (e) {
      print('Lỗi khi lưu danh sách xem gần đây: $e');
    }
  }

  Future<void> themSanPhamXemGanDay(SanPham sanPham) async {
    // Xóa sản phẩm nếu đã tồn tại trong danh sách
    _danhSachXemGanDay.removeWhere((item) => item.id == sanPham.id);
    
    // Thêm sản phẩm vào đầu danh sách
    _danhSachXemGanDay.insert(0, sanPham);
    
    // Giới hạn số lượng sản phẩm trong danh sách
    if (_danhSachXemGanDay.length > _soLuongToiDa) {
      _danhSachXemGanDay = _danhSachXemGanDay.sublist(0, _soLuongToiDa);
    }
    
    await _luuDanhSachXemGanDay();
    notifyListeners();
  }

  Future<void> xoaSanPham(String sanPhamId) async {
    _danhSachXemGanDay.removeWhere((item) => item.id == sanPhamId);
    await _luuDanhSachXemGanDay();
    notifyListeners();
  }

  Future<void> xoaTatCa() async {
    _danhSachXemGanDay.clear();
    await _luuDanhSachXemGanDay();
    notifyListeners();
  }
}
