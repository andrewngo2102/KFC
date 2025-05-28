import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DanhGia {
  final String id;
  final String sanPhamId;
  final String nguoiDungId;
  final String tenNguoiDung;
  final double sao;
  final String? noiDung;
  final DateTime thoiGian;

  DanhGia({
    required this.id,
    required this.sanPhamId,
    required this.nguoiDungId,
    required this.tenNguoiDung,
    required this.sao,
    this.noiDung,
    required this.thoiGian,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sanPhamId': sanPhamId,
      'nguoiDungId': nguoiDungId,
      'tenNguoiDung': tenNguoiDung,
      'sao': sao,
      'noiDung': noiDung,
      'thoiGian': thoiGian.toIso8601String(),
    };
  }

  factory DanhGia.fromJson(Map<String, dynamic> json) {
    return DanhGia(
      id: json['id'],
      sanPhamId: json['sanPhamId'],
      nguoiDungId: json['nguoiDungId'],
      tenNguoiDung: json['tenNguoiDung'],
      sao: json['sao'].toDouble(),
      noiDung: json['noiDung'],
      thoiGian: DateTime.parse(json['thoiGian']),
    );
  }
}

class DanhGiaProvider with ChangeNotifier {
  List<DanhGia> _danhSachDanhGia = [];

  List<DanhGia> get danhSachDanhGia => _danhSachDanhGia;

  DanhGiaProvider() {
    _taiDanhSachDanhGia();
    _taoDanhGiaMau();
  }

  Future<void> _taiDanhSachDanhGia() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final danhSachJson = prefs.getStringList('danh_sach_danh_gia') ?? [];
      
      _danhSachDanhGia = danhSachJson.map((json) {
        return DanhGia.fromJson(jsonDecode(json));
      }).toList();
      
      notifyListeners();
    } catch (e) {
      print('Lỗi khi tải danh sách đánh giá: $e');
    }
  }

  Future<void> _luuDanhSachDanhGia() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final danhSachJson = _danhSachDanhGia.map((danhGia) {
        return jsonEncode(danhGia.toJson());
      }).toList();
      
      await prefs.setStringList('danh_sach_danh_gia', danhSachJson);
    } catch (e) {
      print('Lỗi khi lưu danh sách đánh giá: $e');
    }
  }

  void _taoDanhGiaMau() {
    if (_danhSachDanhGia.isEmpty) {
      final now = DateTime.now();
      
      _danhSachDanhGia = [
        // Đánh giá cho Gà Rán Giòn Cay (101)
        DanhGia(
          id: '1',
          sanPhamId: '101',
          nguoiDungId: 'user1',
          tenNguoiDung: 'Nguyễn Văn A',
          sao: 5.0,
          noiDung: 'Gà rán rất giòn và cay vừa phải, rất ngon!',
          thoiGian: now.subtract(const Duration(days: 2)),
        ),
        DanhGia(
          id: '2',
          sanPhamId: '101',
          nguoiDungId: 'user2',
          tenNguoiDung: 'Trần Thị B',
          sao: 4.0,
          noiDung: 'Gà ngon nhưng hơi cay với mình.',
          thoiGian: now.subtract(const Duration(days: 5)),
        ),
        
        // Đánh giá cho Burger Zinger (201)
        DanhGia(
          id: '3',
          sanPhamId: '201',
          nguoiDungId: 'user3',
          tenNguoiDung: 'Lê Văn C',
          sao: 5.0,
          noiDung: 'Burger rất ngon, thịt gà giòn và sốt mayonnaise đặc biệt.',
          thoiGian: now.subtract(const Duration(days: 1)),
        ),
        DanhGia(
          id: '4',
          sanPhamId: '201',
          nguoiDungId: 'user4',
          tenNguoiDung: 'Phạm Thị D',
          sao: 4.5,
          noiDung: 'Burger ngon, nhưng bánh hơi khô.',
          thoiGian: now.subtract(const Duration(days: 3)),
        ),
        
        // Đánh giá cho Khoai Tây Chiên (401)
        DanhGia(
          id: '5',
          sanPhamId: '401',
          nguoiDungId: 'user5',
          tenNguoiDung: 'Hoàng Văn E',
          sao: 4.0,
          noiDung: 'Khoai tây giòn, ngon nhưng hơi mặn.',
          thoiGian: now.subtract(const Duration(days: 4)),
        ),
      ];
      
      _luuDanhSachDanhGia();
      notifyListeners();
    }
  }

  Future<void> themDanhGia(DanhGia danhGia) async {
    _danhSachDanhGia.add(danhGia);
    await _luuDanhSachDanhGia();
    notifyListeners();
  }

  List<DanhGia> layDanhGiaTheoSanPham(String sanPhamId) {
    return _danhSachDanhGia
        .where((danhGia) => danhGia.sanPhamId == sanPhamId)
        .toList()
      ..sort((a, b) => b.thoiGian.compareTo(a.thoiGian));
  }

  double tinhTrungBinhSao(String sanPhamId) {
    final danhSachDanhGia = layDanhGiaTheoSanPham(sanPhamId);
    if (danhSachDanhGia.isEmpty) return 0;
    
    final tongSao = danhSachDanhGia.fold(0.0, (sum, item) => sum + item.sao);
    return tongSao / danhSachDanhGia.length;
  }

  bool daNguoiDungDanhGia(String sanPhamId, String nguoiDungId) {
    return _danhSachDanhGia.any(
      (danhGia) => danhGia.sanPhamId == sanPhamId && danhGia.nguoiDungId == nguoiDungId,
    );
  }

  Future<void> xoaDanhGia(String danhGiaId) async {
    _danhSachDanhGia.removeWhere((danhGia) => danhGia.id == danhGiaId);
    await _luuDanhSachDanhGia();
    notifyListeners();
  }
}
