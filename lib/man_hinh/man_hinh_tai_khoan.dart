import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:kfc/man_hinh/man_hinh_dang_nhap.dart';
import 'package:kfc/man_hinh/man_hinh_lich_su_don_hang.dart';
import 'package:provider/provider.dart';
import 'package:kfc/providers/nguoi_dung_provider.dart';

class ManHinhTaiKhoan extends StatelessWidget {
  const ManHinhTaiKhoan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tài khoản KFC',
          style: TextStyle(
            color: MauSac.trang,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<NguoiDungProvider>(
        builder: (context, nguoiDungProvider, child) {
          if (!nguoiDungProvider.daDangNhap) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 80,
                    color: MauSac.xam,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bạn chưa đăng nhập',
                    style: TextStyle(
                      color: MauSac.trang,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManHinhDangNhap(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MauSac.kfcRed,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Đăng nhập',
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
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: MauSac.denNhat,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: MauSac.kfcRed,
                        child: Text(
                          nguoiDungProvider.nguoiDung!.ten.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: MauSac.trang,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Xin chào, ${nguoiDungProvider.nguoiDung!.ten}',
                            style: TextStyle(
                              color: MauSac.trang,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Đơn hàng của tôi',
                            style: TextStyle(
                              color: MauSac.xam,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Món ăn yêu thích',
                  style: TextStyle(
                    color: MauSac.trang,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: MauSac.denNhat,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/krunch_burger.png',
                              height: 60,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Burger Krunch',
                              style: TextStyle(
                                color: MauSac.trang,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '49.000đ',
                              style: TextStyle(
                                color: MauSac.trang,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                _buildMenuTile(
                  icon: Icons.location_on,
                  title: 'Địa chỉ giao hàng',
                  onTap: () {},
                ),
                _buildMenuTile(
                  icon: Icons.history,
                  title: 'Lịch sử đơn hàng',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManHinhLichSuDonHang(),
                      ),
                    );
                  },
                ),
                _buildMenuTile(
                  icon: Icons.settings,
                  title: 'Cài đặt',
                  onTap: () {},
                ),
                _buildMenuTile(
                  icon: Icons.help_outline,
                  title: 'Trợ giúp & Hỗ trợ',
                  onTap: () {},
                ),
                _buildMenuTile(
                  icon: Icons.exit_to_app,
                  title: 'Đăng xuất',
                  onTap: () {
                    nguoiDungProvider.dangXuat();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: MauSac.xamDam, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: MauSac.trang,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: MauSac.trang,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: MauSac.xam,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
