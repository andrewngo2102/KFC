import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:kfc/models/san_pham.dart';
import 'package:provider/provider.dart';
import 'package:kfc/providers/gio_hang_provider.dart';
import 'package:kfc/widgets/hinh_anh_an_toan.dart';

class TheSanPham extends StatelessWidget {
  final SanPham sanPham;
  final VoidCallback onTap;

  const TheSanPham({
    Key? key,
    required this.sanPham,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: MauSac.denNhat,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
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
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sanPham.ten,
                    style: TextStyle(
                      color: MauSac.trang,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sanPham.moTa,
                    style: TextStyle(
                      color: MauSac.xam,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${sanPham.gia}đ',
                        style: TextStyle(
                          color: MauSac.trang,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
          ],
        ),
      ),
    );
  }
}
