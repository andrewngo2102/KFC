import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:kfc/widgets/the_danh_muc.dart';
import 'package:kfc/widgets/the_san_pham.dart';
import 'package:kfc/widgets/the_san_pham_khuyen_mai.dart';
import 'package:kfc/widgets/banner_khuyen_mai.dart';
import 'package:kfc/models/danh_muc.dart';
import 'package:kfc/models/san_pham.dart';
import 'package:kfc/man_hinh/man_hinh_chi_tiet_san_pham.dart';
import 'package:kfc/man_hinh/man_hinh_chon_dia_chi.dart';
import 'package:kfc/man_hinh/man_hinh_tim_kiem.dart';
import 'package:kfc/man_hinh/man_hinh_danh_sach_san_pham.dart';
import 'package:provider/provider.dart';
import 'package:kfc/providers/dia_chi_provider.dart';
import 'package:kfc/data/du_lieu_mau.dart';

class ManHinhDanhMuc extends StatefulWidget {
  const ManHinhDanhMuc({Key? key}) : super(key: key);

  @override
  State<ManHinhDanhMuc> createState() => _ManHinhDanhMucState();
}

class _ManHinhDanhMucState extends State<ManHinhDanhMuc> {
  final List<Map<String, dynamic>> _danhSachBanner = [
    {
      'hinhAnh': 'assets/images/banner1.png',
      'tieuDe': 'Combo nhóm giảm 25%',
      'moTa': 'Áp dụng cho nhóm từ 3-4 người, chỉ trong hôm nay',
      'nhan': 'HOT',
    },
    {
      'hinhAnh': 'assets/images/banner2.png',
      'tieuDe': 'Mua 1 tặng 1',
      'moTa': 'Áp dụng cho burger và gà rán, từ 10h-14h hàng ngày',
      'nhan': 'NEW',
    },
    {
      'hinhAnh': 'assets/images/banner3.png',
      'tieuDe': 'Freeship đơn từ 100K',
      'moTa': 'Áp dụng cho tất cả đơn hàng, bán kính 5km',
      'nhan': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final danhSachDanhMuc = DuLieuMau.danhSachDanhMuc;
    final danhSachSanPhamNoiBat = DuLieuMau.danhSachSanPhamNoiBat();
    final danhSachSanPhamKhuyenMai = DuLieuMau.danhSachSanPhamKhuyenMai();

    return Scaffold(
      appBar: AppBar(
        title: Consumer<DiaChiProvider>(
          builder: (context, diaChiProvider, child) {
            final diaChiHienTai = diaChiProvider.diaChiHienTai;
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManHinhChonDiaChi(),
                  ),
                );
              },
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: MauSac.kfcRed, size: 20),
                  const SizedBox(width: 5),
                  const Text(
                    'Giao hàng đến:',
                    style: TextStyle(
                      color: MauSac.xam,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      diaChiHienTai?.diaChiChiTiet ?? 'Chọn địa chỉ',
                      style: const TextStyle(
                        color: MauSac.trang,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: MauSac.trang),
                ],
              ),
            );
          },
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: MauSac.trang),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManHinhTimKiem(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: MauSac.trang),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Giả lập làm mới dữ liệu
          await Future.delayed(const Duration(seconds: 1));
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner khuyến mãi
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: BannerKhuyenMai(danhSachBanner: _danhSachBanner),
              ),
              
              // Danh mục
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Danh mục',
                  style: TextStyle(
                    color: MauSac.trang,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: danhSachDanhMuc.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManHinhDanhSachSanPham(
                              danhMuc: danhSachDanhMuc[index],
                            ),
                          ),
                        );
                      },
                      child: TheDanhMuc(danhMuc: danhSachDanhMuc[index]),
                    );
                  },
                ),
              ),
              
              // Khuyến mãi hôm nay
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Khuyến mãi hôm nay',
                      style: TextStyle(
                        color: MauSac.trang,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Tạo một danh mục ảo cho trang khuyến mãi
                        final danhMucKhuyenMai = DanhMuc(
                          id: 'khuyen_mai',
                          ten: 'Khuyến mãi',
                          hinhAnh: '',
                          moTa: 'Tất cả sản phẩm đang khuyến mãi',
                        );
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManHinhDanhSachSanPham(
                              danhMuc: danhMucKhuyenMai,
                              danhSachSanPham: danhSachSanPhamKhuyenMai,
                              tieuDe: 'Khuyến mãi',
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Xem tất cả',
                        style: TextStyle(
                          color: MauSac.kfcRed,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: danhSachSanPhamKhuyenMai.length,
                  itemBuilder: (context, index) {
                    return TheSanPhamKhuyenMai(
                      sanPham: danhSachSanPhamKhuyenMai[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManHinhChiTietSanPham(
                              sanPham: danhSachSanPhamKhuyenMai[index],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              
              // Món ăn nổi bật
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Món ăn nổi bật',
                      style: TextStyle(
                        color: MauSac.trang,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Tạo một danh mục ảo cho trang nổi bật
                        final danhMucNoiBat = DanhMuc(
                          id: 'noi_bat',
                          ten: 'Nổi bật',
                          hinhAnh: '',
                          moTa: 'Những món ăn được yêu thích nhất',
                        );
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManHinhDanhSachSanPham(
                              danhMuc: danhMucNoiBat,
                              danhSachSanPham: danhSachSanPhamNoiBat,
                              tieuDe: 'Món ăn nổi bật',
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Xem tất cả',
                        style: TextStyle(
                          color: MauSac.kfcRed,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: danhSachSanPhamNoiBat.length > 4 ? 4 : danhSachSanPhamNoiBat.length,
                itemBuilder: (context, index) {
                  return TheSanPham(
                    sanPham: danhSachSanPhamNoiBat[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManHinhChiTietSanPham(
                            sanPham: danhSachSanPhamNoiBat[index],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
