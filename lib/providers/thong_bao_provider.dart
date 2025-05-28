import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ThongBao {
  final String id;
  final String tieuDe;
  final String noiDung;
  final String? hinhAnh;
  final DateTime thoiGian;
  final bool daDoc;
  final String loai; // 'khuyen_mai', 'don_hang', 'he_thong'

  ThongBao({
    required this.id,
    required this.tieuDe,
    required this.noiDung,
    this.hinhAnh,
    required this.thoiGian,
    this.daDoc = false,
    required this.loai,
  });

  ThongBao copyWith({
    String? id,
    String? tieuDe,
    String? noiDung,
    String? hinhAnh,
    DateTime? thoiGian,
    bool? daDoc,
    String? loai,
  }) {
    return ThongBao(
      id: id ?? this.id,
      tieuDe: tieuDe ?? this.tieuDe,
      noiDung: noiDung ?? this.noiDung,
      hinhAnh: hinhAnh ?? this.hinhAnh,
      thoiGian: thoiGian ?? this.thoiGian,
      daDoc: daDoc ?? this.daDoc,
      loai: loai ?? this.loai,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tieuDe': tieuDe,
      'noiDung': noiDung,
      'hinhAnh': hinhAnh,
      'thoiGian': thoiGian.toIso8601String(),
      'daDoc': daDoc,
      'loai': loai,
    };
  }

  factory ThongBao.fromJson(Map<String, dynamic> json) {
    return ThongBao(
      id: json['id'],
      tieuDe: json['tieuDe'],
      noiDung: json['noiDung'],
      hinhAnh: json['hinhAnh'],
      thoiGian: DateTime.parse(json['thoiGian']),
      daDoc: json['daDoc'] ?? false,
      loai: json['loai'],
    );
  }
}

class ThongBaoProvider with ChangeNotifier {
  List<ThongBao> _danhSachThongBao = [];

  List<ThongBao> get danhSachThongBao => _danhSachThongBao;
  
  int get soThongBaoChuaDoc => _danhSachThongBao.where((tb) => !tb.daDoc).length;

  ThongBaoProvider() {
    _taiDanhSachThongBao();
    _taoThongBaoMau();
  }

  Future<void> _taiDanhSachThongBao() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final danhSachJson = prefs.getStringList('danh_sach_thong_bao') ?? [];
      
      _danhSachThongBao = danhSachJson.map((json) {
        return ThongBao.fromJson(jsonDecode(json));
      }).toList();
      
      // Sắp xếp theo thời gian mới nhất
      _danhSachThongBao.sort((a, b) => b.thoiGian.compareTo(a.thoiGian));
      
      notifyListeners();
    } catch (e) {
      print('Lỗi khi tải danh sách thông báo: $e');
    }
  }

  Future<void> _luuDanhSachThongBao() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final danhSachJson = _danhSachThongBao.map((thongBao) {
        return jsonEncode(thongBao.toJson());
      }).toList();
      
      await prefs.setStringList('danh_sach_thong_bao', danhSachJson);
    } catch (e) {
      print('Lỗi khi lưu danh sách thông báo: $e');
    }
  }

  void _taoThongBaoMau() {
    if (_danhSachThongBao.isEmpty) {
      final now = DateTime.now();
      
      _danhSachThongBao = [
        ThongBao(
          id: '1',
          tieuDe: 'Chào mừng bạn đến với KFC',
          noiDung: 'Cảm ơn bạn đã cài đặt ứng dụng KFC. Khám phá ngay các món ăn ngon và ưu đãi hấp dẫn!',
          thoiGian: now.subtract(const Duration(days: 1)),
          loai: 'he_thong',
        ),
        ThongBao(
          id: '2',
          tieuDe: 'Giảm 30% cho đơn hàng đầu tiên',
          noiDung: 'Nhập mã KFCNEW để được giảm 30% cho đơn hàng đầu tiên của bạn. Áp dụng cho đơn từ 100.000đ.',
          hinhAnh: 'assets/images/khuyen_mai_1.png',
          thoiGian: now.subtract(const Duration(days: 2)),
          loai: 'khuyen_mai',
        ),
        ThongBao(
          id: '3',
          tieuDe: 'Combo mới: Gà Sốt Cay Hàn Quốc',
          noiDung: 'Thưởng thức ngay combo Gà Sốt Cay Hàn Quốc mới ra mắt tại KFC. Hương vị cay nồng đặc trưng!',
          hinhAnh: 'assets/images/khuyen_mai_2.png',
          thoiGian: now.subtract(const Duration(days: 3)),
          loai: 'khuyen_mai',
        ),
      ];
      
      _luuDanhSachThongBao();
      notifyListeners();
    }
  }

  Future<void> themThongBao(ThongBao thongBao) async {
    _danhSachThongBao.insert(0, thongBao);
    await _luuDanhSachThongBao();
    notifyListeners();
  }

  Future<void> danhDauDaDoc(String thongBaoId) async {
    final index = _danhSachThongBao.indexWhere((tb) => tb.id == thongBaoId);
    if (index >= 0) {
      _danhSachThongBao[index] = _danhSachThongBao[index].copyWith(daDoc: true);
      await _luuDanhSachThongBao();
      notifyListeners();
    }
  }

  Future<void> danhDauTatCaDaDoc() async {
    _danhSachThongBao = _danhSachThongBao.map((tb) => tb.copyWith(daDoc: true)).toList();
    await _luuDanhSachThongBao();
    notifyListeners();
  }

  Future<void> xoaThongBao(String thongBaoId) async {
    _danhSachThongBao.removeWhere((tb) => tb.id == thongBaoId);
    await _luuDanhSachThongBao();
    notifyListeners();
  }

  Future<void> xoaTatCa() async {
    _danhSachThongBao.clear();
    await _luuDanhSachThongBao();
    notifyListeners();
  }

  List<ThongBao> locThongBaoTheoLoai(String loai) {
    if (loai == 'tat_ca') return _danhSachThongBao;
    return _danhSachThongBao.where((tb) => tb.loai == loai).toList();
  }
}
