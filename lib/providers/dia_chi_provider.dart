import 'package:flutter/foundation.dart';
import 'package:kfc/models/dia_chi.dart';

class DiaChiProvider with ChangeNotifier {
  DiaChi? _diaChiHienTai;
  final List<DiaChi> _danhSachDiaChi = [
    DiaChi(
      id: '1',
      tenDiaChi: 'Nhà',
      diaChiChiTiet: '123 Đường Nguyễn Văn Linh, Quận 7, TP.HCM',
      viDo: 10.7553411,
      kinhDo: 106.7021555,
    ),
    DiaChi(
      id: '2',
      tenDiaChi: 'Công ty',
      diaChiChiTiet: '456 Đường Nguyễn Hữu Thọ, Quận 7, TP.HCM',
      viDo: 10.7414701,
      kinhDo: 106.7021555,
    ),
  ];

  DiaChi? get diaChiHienTai => _diaChiHienTai ?? _danhSachDiaChi.first;
  List<DiaChi> get danhSachDiaChi => _danhSachDiaChi;

  void chonDiaChi(DiaChi diaChi) {
    _diaChiHienTai = diaChi;
    notifyListeners();
  }

  void themDiaChi(DiaChi diaChi) {
    _danhSachDiaChi.add(diaChi);
    notifyListeners();
  }

  void capNhatDiaChi(DiaChi diaChi) {
    final index = _danhSachDiaChi.indexWhere((item) => item.id == diaChi.id);
    if (index >= 0) {
      _danhSachDiaChi[index] = diaChi;
      
      // Nếu đang cập nhật địa chỉ hiện tại, cập nhật luôn địa chỉ hiện tại
      if (_diaChiHienTai != null && _diaChiHienTai!.id == diaChi.id) {
        _diaChiHienTai = diaChi;
      }
      
      notifyListeners();
    }
  }

  void xoaDiaChi(String diaChiId) {
    _danhSachDiaChi.removeWhere((item) => item.id == diaChiId);
    
    // Nếu xóa địa chỉ hiện tại, chọn địa chỉ đầu tiên trong danh sách
    if (_diaChiHienTai != null && _diaChiHienTai!.id == diaChiId) {
      _diaChiHienTai = _danhSachDiaChi.isNotEmpty ? _danhSachDiaChi.first : null;
    }
    
    notifyListeners();
  }
}
