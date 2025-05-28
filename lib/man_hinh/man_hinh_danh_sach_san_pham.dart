import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:kfc/models/danh_muc.dart';
import 'package:kfc/models/san_pham.dart';
import 'package:kfc/widgets/the_san_pham.dart';
import 'package:kfc/man_hinh/man_hinh_chi_tiet_san_pham.dart';
import 'package:kfc/data/du_lieu_mau.dart';

class ManHinhDanhSachSanPham extends StatelessWidget {
  final DanhMuc danhMuc;
  final List<SanPham>? danhSachSanPham;
  final String? tieuDe;

  const ManHinhDanhSachSanPham({
    Key? key,
    required this.danhMuc,
    this.danhSachSanPham,
    this.tieuDe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dsSanPham = danhSachSanPham ?? DuLieuMau.laySanPhamTheoDanhMuc(danhMuc.id);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tieuDe ?? danhMuc.ten,
          style: const TextStyle(
            color: MauSac.trang,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần mô tả danh mục
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  danhMuc.moTa,
                  style: TextStyle(
                    color: MauSac.xam,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Có ${dsSanPham.length} món',
                  style: TextStyle(
                    color: MauSac.kfcRed,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Danh sách sản phẩm
          Expanded(
            child: dsSanPham.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.no_food,
                          size: 80,
                          color: MauSac.xam,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Không có sản phẩm nào',
                          style: TextStyle(
                            color: MauSac.trang,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: dsSanPham.length,
                    itemBuilder: (context, index) {
                      return TheSanPham(
                        sanPham: dsSanPham[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManHinhChiTietSanPham(
                                sanPham: dsSanPham[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
