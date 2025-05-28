import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:kfc/widgets/hinh_anh_an_toan.dart';

class ManHinhViTri extends StatelessWidget {
  const ManHinhViTri({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MauSac.denNen,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'KFC',
                  style: TextStyle(
                    color: MauSac.kfcRed,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              const Text(
                'HỖ TRỢ CHÚNG TÔI',
                style: TextStyle(
                  color: MauSac.trang,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Định vị bạn',
                style: TextStyle(
                  color: MauSac.trang,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Để cung cấp trải nghiệm giao hàng liền mạch, KFC muốn lấy vị trí của bạn.',
                style: TextStyle(
                  color: MauSac.xam,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Center(
                child: HinhAnhAnToan(
                  duongDan: 'assets/images/location_icon.png',
                  chieuRong: 150,
                  chieuCao: 150,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MauSac.kfcRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Cho phép truy cập vị trí',
                    style: TextStyle(
                      color: MauSac.trang,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
