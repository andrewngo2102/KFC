import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:kfc/models/san_pham.dart';
import 'package:kfc/providers/yeu_thich_provider.dart';
import 'package:kfc/providers/gio_hang_provider.dart'; // Thêm import này
import 'package:kfc/widgets/hinh_anh_an_toan.dart';
import 'package:kfc/man_hinh/man_hinh_chi_tiet_san_pham.dart';
import 'package:provider/provider.dart';

class ManHinhYeuThich extends StatefulWidget {
  const ManHinhYeuThich({Key? key}) : super(key: key);

  @override
  State<ManHinhYeuThich> createState() => _ManHinhYeuThichState();
}

class _ManHinhYeuThichState extends State<ManHinhYeuThich> {
  bool _dangTaiDuLieu = false;

  Future<void> _lamMoiDuLieu() async {
    setState(() {
      _dangTaiDuLieu = true;
    });

    // Giả lập tải dữ liệu
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _dangTaiDuLieu = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sản phẩm yêu thích',
          style: TextStyle(
            color: MauSac.trang,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<YeuThichProvider>(
            builder: (context, yeuThichProvider, child) {
              if (yeuThichProvider.danhSachYeuThich.isEmpty) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: const Icon(Icons.delete_sweep, color: MauSac.trang),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: MauSac.denNhat,
                      title: const Text(
                        'Xóa tất cả',
                        style: TextStyle(
                          color: MauSac.trang,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: const Text(
                        'Bạn có chắc chắn muốn xóa tất cả sản phẩm yêu thích?',
                        style: TextStyle(
                          color: MauSac.trang,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Hủy',
                            style: TextStyle(
                              color: MauSac.xam,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            yeuThichProvider.xoaTatCa();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đã xóa tất cả sản phẩm yêu thích'),
                                backgroundColor: MauSac.kfcRed,
                              ),
                            );
                          },
                          child: const Text(
                            'Xóa tất cả',
                            style: TextStyle(
                              color: MauSac.kfcRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _lamMoiDuLieu,
        color: MauSac.kfcRed,
        child: Consumer<YeuThichProvider>(
          builder: (context, yeuThichProvider, child) {
            final danhSachYeuThich = yeuThichProvider.danhSachYeuThich;

            if (_dangTaiDuLieu) {
              return const Center(
                child: CircularProgressIndicator(
                  color: MauSac.kfcRed,
                ),
              );
            }

            if (danhSachYeuThich.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 80,
                      color: MauSac.xam,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Chưa có sản phẩm yêu thích',
                      style: TextStyle(
                        color: MauSac.trang,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Hãy thêm sản phẩm vào danh sách yêu thích\nđể xem lại sau',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MauSac.xam,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MauSac.kfcRed,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Khám phá sản phẩm',
                        style: TextStyle(
                          color: MauSac.trang,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: danhSachYeuThich.length,
              itemBuilder: (context, index) {
                final sanPham = danhSachYeuThich[index];
                return _buildSanPhamYeuThichItem(context, sanPham);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSanPhamYeuThichItem(BuildContext context, SanPham sanPham) {
    final giaSauKhuyenMai = sanPham.khuyenMai == true && sanPham.giamGia != null
        ? sanPham.gia - (sanPham.gia * sanPham.giamGia! ~/ 100)
        : sanPham.gia;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ManHinhChiTietSanPham(
              sanPham: sanPham,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: MauSac.denNhat,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh sản phẩm
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: MauSac.denNhat,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: HinhAnhAnToan(
                      duongDan: sanPham.hinhAnh,
                      chieuCao: 100,
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
                Positioned(
                  top: 8,
                  left: 8,
                  child: Consumer<YeuThichProvider>(
                    builder: (context, yeuThichProvider, child) {
                      return GestureDetector(
                        onTap: () {
                          yeuThichProvider.xoaKhoiYeuThich(sanPham.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã xóa ${sanPham.ten} khỏi danh sách yêu thích'),
                              backgroundColor: Colors.grey,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: MauSac.denNen.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: MauSac.kfcRed,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            // Thông tin sản phẩm
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
                    maxLines: 2,
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
                  ElevatedButton(
                    onPressed: () {
                      final gioHangProvider = Provider.of<GioHangProvider>(context, listen: false);
                      gioHangProvider.themSanPham(sanPham);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã thêm ${sanPham.ten} vào giỏ hàng'),
                          backgroundColor: MauSac.xanhLa,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MauSac.kfcRed,
                      minimumSize: const Size(double.infinity, 36),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Thêm vào giỏ hàng',
                      style: TextStyle(
                        color: MauSac.trang,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
