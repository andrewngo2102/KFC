import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';

class ThanhDieuHuong extends StatelessWidget {
  final int trangHienTai;
  final Function(int) onTap;
  final int soThongBaoChuaDoc;

  const ThanhDieuHuong({
    Key? key,
    required this.trangHienTai,
    required this.onTap,
    this.soThongBaoChuaDoc = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: MauSac.denNen,
        border: Border(
          top: BorderSide(color: MauSac.xamDam, width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: trangHienTai,
        onTap: onTap,
        backgroundColor: MauSac.denNen,
        selectedItemColor: MauSac.kfcRed,
        unselectedItemColor: MauSac.xam,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Giỏ hàng',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Yêu thích',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.person),
                if (soThongBaoChuaDoc > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: MauSac.kfcRed,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        soThongBaoChuaDoc > 9 ? '9+' : '$soThongBaoChuaDoc',
                        style: const TextStyle(
                          color: MauSac.trang,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}
