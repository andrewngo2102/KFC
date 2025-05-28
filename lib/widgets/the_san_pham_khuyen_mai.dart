import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:kfc/models/san_pham.dart';
import 'package:provider/provider.dart';
import 'package:kfc/providers/gio_hang_provider.dart';
import 'package:kfc/widgets/hinh_anh_an_toan.dart';

class TheSanPhamKhuyenMai extends StatelessWidget {
  final SanPham sanPham;
  final VoidCallback onTap;

  const TheSanPhamKhuyenMai({
    Key? key,
    required this.sanPham,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tính giá sau khuyến mãi
    final giaSauKhuyenMai = sanPham.khuyenMai == true && sanPham.giamGia != null
        ? sanPham.gia - (sanPham.gia * sanPham.giamGia! ~/ 100)
        : sanPham.gia;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: MauSac.denNhat,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần hình ảnh và nhãn khuyến mãi
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    color: MauSac.denNhat,
                    child: Center(
                      child: Hero(
                        tag: 'product_${sanPham.id}',
                        child: HinhAnhAnToan(
                          duongDan: sanPham.hinhAnh,
                          chieuCao: 100,
                        ),
                      ),
                    ),
                  ),
                ),
                if (sanPham.khuyenMai == true && sanPham.giamGia != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: MauSac.kfcRed,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '-${sanPham.giamGia}%',
                        style: const TextStyle(
                          color: MauSac.trang,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Phần thông tin sản phẩm
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sanPham.ten,
                    style: const TextStyle(
                      color: MauSac.trang,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${giaSauKhuyenMai}đ',
                        style: const TextStyle(
                          color: MauSac.trang,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (sanPham.khuyenMai == true && sanPham.giamGia != null)
                        Text(
                          '${sanPham.gia}đ',
                          style: const TextStyle(
                            color: MauSac.xam,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Đánh giá sao
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: MauSac.vang,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '4.8',
                            style: TextStyle(
                              color: MauSac.xam,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      // Nút thêm vào giỏ hàng
                      GestureDetector(
                        onTap: () {
                          final gioHangProvider = Provider.of<GioHangProvider>(context, listen: false);
                          gioHangProvider.themSanPham(sanPham);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã thêm ${sanPham.ten} vào giỏ hàng'),
                              backgroundColor: MauSac.xanhLa,
                            ),
                          );
                        },
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: MauSac.kfcRed,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
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
          ],
        ),
      ),
    );
  }
}
