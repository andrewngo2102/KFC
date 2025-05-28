import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:provider/provider.dart';
import 'package:kfc/providers/gio_hang_provider.dart';
import 'package:kfc/man_hinh/man_hinh_theo_doi_don_hang.dart';

class ManHinhThanhToan extends StatefulWidget {
  const ManHinhThanhToan({Key? key}) : super(key: key);

  @override
  State<ManHinhThanhToan> createState() => _ManHinhThanhToanState();
}

class _ManHinhThanhToanState extends State<ManHinhThanhToan> {
  String _phuongThucThanhToan = 'Tiền mặt';

  @override
  Widget build(BuildContext context) {
    final gioHangProvider = Provider.of<GioHangProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thanh toán',
          style: TextStyle(
            color: MauSac.trang,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Địa chỉ giao hàng',
              style: TextStyle(
                color: MauSac.trang,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MauSac.denNhat,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: MauSac.kfcRed,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nhà',
                          style: TextStyle(
                            color: MauSac.trang,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '123 Đường Nguyễn Văn Linh, Quận 7, TP.HCM',
                          style: TextStyle(
                            color: MauSac.xam,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: MauSac.xam,
                    size: 16,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Tóm tắt đơn hàng',
              style: TextStyle(
                color: MauSac.trang,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MauSac.denNhat,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ...gioHangProvider.danhSachSanPham.map((sanPham) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Text(
                            '${sanPham.soLuong}x',
                            style: TextStyle(
                              color: MauSac.xam,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              sanPham.sanPham.ten,
                              style: TextStyle(
                                color: MauSac.trang,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            '${sanPham.sanPham.gia * sanPham.soLuong}đ',
                            style: TextStyle(
                              color: MauSac.trang,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const Divider(color: MauSac.xamDam),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tạm tính',
                        style: TextStyle(
                          color: MauSac.xam,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${gioHangProvider.tongTien}đ',
                        style: TextStyle(
                          color: MauSac.trang,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Phí giao hàng',
                        style: TextStyle(
                          color: MauSac.xam,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '15.000đ',
                        style: TextStyle(
                          color: MauSac.trang,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng cộng',
                        style: TextStyle(
                          color: MauSac.trang,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${gioHangProvider.tongTien + 15000}đ',
                        style: TextStyle(
                          color: MauSac.trang,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Phương thức thanh toán',
              style: TextStyle(
                color: MauSac.trang,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildPhuongThucThanhToan(
              icon: Icons.money,
              title: 'Tiền mặt',
              subtitle: 'Thanh toán khi nhận hàng',
              isSelected: _phuongThucThanhToan == 'Tiền mặt',
              onTap: () {
                setState(() {
                  _phuongThucThanhToan = 'Tiền mặt';
                });
              },
            ),
            const SizedBox(height: 12),
            _buildPhuongThucThanhToan(
              icon: Icons.credit_card,
              title: 'Thẻ ngân hàng',
              subtitle: 'Visa, Mastercard, JCB',
              isSelected: _phuongThucThanhToan == 'Thẻ ngân hàng',
              onTap: () {
                setState(() {
                  _phuongThucThanhToan = 'Thẻ ngân hàng';
                });
              },
            ),
            const SizedBox(height: 12),
            _buildPhuongThucThanhToan(
              icon: Icons.account_balance_wallet,
              title: 'Ví điện tử',
              subtitle: 'Momo, ZaloPay, VNPay',
              isSelected: _phuongThucThanhToan == 'Ví điện tử',
              onTap: () {
                setState(() {
                  _phuongThucThanhToan = 'Ví điện tử';
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: MauSac.denNen,
          border: Border(
            top: BorderSide(color: MauSac.xamDam, width: 0.5),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // Xử lý đặt hàng
              gioHangProvider.xacNhanDatHang();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManHinhTheoDoi(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MauSac.kfcRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Đặt hàng',
              style: TextStyle(
                color: MauSac.trang,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhuongThucThanhToan({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: MauSac.denNhat,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? MauSac.kfcRed : MauSac.denNhat,
            width: 2,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: MauSac.trang,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: MauSac.xam,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: MauSac.kfcRed,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
