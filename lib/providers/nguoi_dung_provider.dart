import 'package:flutter/foundation.dart';
import 'package:kfc/models/nguoi_dung.dart';

class NguoiDungProvider with ChangeNotifier {
  NguoiDung? _nguoiDung;

  NguoiDung? get nguoiDung => _nguoiDung;

  bool get daDangNhap => _nguoiDung != null;

  void dangNhap(NguoiDung nguoiDung) {
    _nguoiDung = nguoiDung;
    notifyListeners();
  }

  void dangXuat() {
    _nguoiDung = null;
    notifyListeners();
  }

  void capNhatThongTin({
    String? ten,
    String? soDienThoai,
    String? diaChi,
    String? avatar,
  }) {
    if (_nguoiDung != null) {
      _nguoiDung = NguoiDung(
        id: _nguoiDung!.id,
        ten: ten ?? _nguoiDung!.ten,
        email: _nguoiDung!.email,
        soDienThoai: soDienThoai ?? _nguoiDung!.soDienThoai,
        diaChi: diaChi ?? _nguoiDung!.diaChi,
        avatar: avatar ?? _nguoiDung!.avatar,
      );
      notifyListeners();
    }
  }
}
