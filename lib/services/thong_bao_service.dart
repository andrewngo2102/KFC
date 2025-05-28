import 'package:flutter/material.dart';

class ThongBaoService {
  // Hiển thị thông báo trong ứng dụng
  void hienThiThongBaoTrongUngDung({
    required BuildContext context,
    required String tieuDe,
    required String noiDung,
    Duration thoiGian = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tieuDe,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(noiDung),
          ],
        ),
        duration: thoiGian,
        action: SnackBarAction(
          label: 'Đóng',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // Hiển thị hộp thoại thông báo
  Future<void> hienThiHopThoaiThongBao({
    required BuildContext context,
    required String tieuDe,
    required String noiDung,
    String nutDongY = 'OK',
    String? nutHuy,
    VoidCallback? onDongY,
    VoidCallback? onHuy,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tieuDe),
        content: Text(noiDung),
        actions: [
          if (nutHuy != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onHuy != null) onHuy();
              },
              child: Text(nutHuy),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onDongY != null) onDongY();
            },
            child: Text(nutDongY),
          ),
        ],
      ),
    );
  }

  // Hiển thị thông báo dưới cùng
  void hienThiThongBaoDuoiCung({
    required BuildContext context,
    required String noiDung,
    Color mauNen = Colors.black87,
    Color mauChu = Colors.white,
    Duration thoiGian = const Duration(seconds: 2),
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50,
        left: 20,
        right: 20,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          color: mauNen,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Text(
              noiDung,
              style: TextStyle(color: mauChu),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(thoiGian, () {
      overlayEntry.remove();
    });
  }
}
