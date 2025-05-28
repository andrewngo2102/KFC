import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:kfc/models/san_pham_gio_hang.dart';
import 'package:provider/provider.dart';
import 'package:kfc/providers/gio_hang_provider.dart';
import 'package:kfc/man_hinh/man_hinh_thanh_toan.dart';
import 'package:kfc/widgets/hinh_anh_an_toan.dart';

class ManHinhGioHang extends StatelessWidget {
  const ManHinhGioHang({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(
            color: MauSac.trang,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<GioHangProvider>(
            builder: (context, gioHangProvider, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    '(${gioHangProvider.tongSoLuong} món)',
                    style: TextStyle(
                      color: MauSac.xam,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<GioHangProvider>(
        builder: (context, gioHangProvider, child) {
          if (gioHangProvider.danhSachSanPham.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: MauSac.xam,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Giỏ hàng trống',
                    style: TextStyle(
                      color: MauSac.trang,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hãy thêm món ăn vào giỏ hàng',
                    style: TextStyle(
                      color: MauSac.xam,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: gioHangProvider.danhSachSanPham.length,
                  itemBuilder: (context, index) {
                    final sanPham = gioHangProvider.danhSachSanPham[index];
                    return _buildSanPhamGioHang(context, sanPham, gioHangProvider);
                  },
                ),
              ),
              _buildThongTinThanhToan(context, gioHangProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSanPhamGioHang(
    BuildContext context,
    SanPhamGioHang sanPham,
    GioHangProvider gioHangProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: MauSac.xamDam, width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HinhAnhAnToan(
            duongDan: sanPham.sanPham.hinhAnh,
            chieuRong: 80,
            chieuCao: 80,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sanPham.sanPham.ten,
                  style: TextStyle(
                    color: MauSac.trang,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${sanPham.sanPham.gia}đ',
                  style: TextStyle(
                    color: MauSac.trang,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (sanPham.soLuong > 1) {
                          gioHangProvider.giamSoLuong(sanPham.sanPham.id);
                        }
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: MauSac.denNhat,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: MauSac.trang,
                          size: 16,
                        ),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 28,
                      alignment: Alignment.center,
                      child: Text(
                        '${sanPham.soLuong}',
                        style: TextStyle(
                          color: MauSac.trang,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        gioHangProvider.tangSoLuong(sanPham.sanPham.id);
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: MauSac.kfcRed,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.add,
                          color: MauSac.trang,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${sanPham.sanPham.gia * sanPham.soLuong}đ',
            style: TextStyle(
              color: MauSac.trang,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThongTinThanhToan(
    BuildContext context,
    GioHangProvider gioHangProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MauSac.denNen,
        border: Border(
          top: BorderSide(color: MauSac.xamDam, width: 0.5),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hướng dẫn đặc biệt (tùy chọn)',
                style: TextStyle(
                  color: MauSac.trang,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MauSac.denNhat,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.add,
                  color: MauSac.kfcRed,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Thêm hướng dẫn nấu/giao hàng',
                  style: TextStyle(
                    color: MauSac.kfcRed,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (gioHangProvider.tongSoLuong > 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManHinhThanhToan(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MauSac.kfcRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Tiến hành thanh toán',
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
}
