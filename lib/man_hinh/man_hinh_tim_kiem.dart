import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:kfc/models/san_pham.dart';
import 'package:kfc/widgets/the_san_pham.dart';
import 'package:kfc/man_hinh/man_hinh_chi_tiet_san_pham.dart';
import 'package:provider/provider.dart';
import 'package:kfc/providers/tim_kiem_provider.dart';
import 'package:kfc/data/du_lieu_mau.dart';

class ManHinhTimKiem extends StatefulWidget {
  const ManHinhTimKiem({Key? key}) : super(key: key);

  @override
  State<ManHinhTimKiem> createState() => _ManHinhTimKiemState();
}

class _ManHinhTimKiemState extends State<ManHinhTimKiem> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilterOptions = false;

  @override
  void initState() {
    super.initState();
    // Lấy từ khóa hiện tại từ provider
    final timKiemProvider = Provider.of<TimKiemProvider>(context, listen: false);
    _searchController.text = timKiemProvider.tuKhoa;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          style: const TextStyle(color: MauSac.trang),
          decoration: InputDecoration(
            hintText: 'Tìm kiếm món ăn...',
            hintStyle: TextStyle(color: MauSac.xam),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: MauSac.xam),
              onPressed: () {
                _searchController.clear();
                Provider.of<TimKiemProvider>(context, listen: false).datTuKhoa('');
              },
            ),
          ),
          onChanged: (value) {
            Provider.of<TimKiemProvider>(context, listen: false).datTuKhoa(value);
          },
          onSubmitted: (value) {
            Provider.of<TimKiemProvider>(context, listen: false).datTuKhoa(value);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: _showFilterOptions ? MauSac.kfcRed : MauSac.trang,
            ),
            onPressed: () {
              setState(() {
                _showFilterOptions = !_showFilterOptions;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Phần tùy chọn lọc
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showFilterOptions ? 180 : 0,
            color: MauSac.denNhat,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<TimKiemProvider>(
                  builder: (context, timKiemProvider, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lọc theo danh mục',
                          style: TextStyle(
                            color: MauSac.trang,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: DuLieuMau.danhSachDanhMuc.length + 1, // +1 cho "Tất cả"
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return _buildDanhMucChip(
                                  'Tất cả',
                                  timKiemProvider.danhMucId.isEmpty,
                                  () => timKiemProvider.datDanhMuc(''),
                                );
                              }
                              final danhMuc = DuLieuMau.danhSachDanhMuc[index - 1];
                              return _buildDanhMucChip(
                                danhMuc.ten,
                                timKiemProvider.danhMucId == danhMuc.id,
                                () => timKiemProvider.datDanhMuc(danhMuc.id),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Sắp xếp theo',
                          style: TextStyle(
                            color: MauSac.trang,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildSapXepChip(
                              'Mặc định',
                              timKiemProvider.sapXepTheo == 'mac_dinh',
                              () => timKiemProvider.datSapXep('mac_dinh'),
                            ),
                            _buildSapXepChip(
                              'Giá tăng dần',
                              timKiemProvider.sapXepTheo == 'gia_tang',
                              () => timKiemProvider.datSapXep('gia_tang'),
                            ),
                            _buildSapXepChip(
                              'Giá giảm dần',
                              timKiemProvider.sapXepTheo == 'gia_giam',
                              () => timKiemProvider.datSapXep('gia_giam'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: timKiemProvider.chiHienKhuyenMai,
                                  onChanged: (value) {
                                    timKiemProvider.datChiHienKhuyenMai(value ?? false);
                                  },
                                  activeColor: MauSac.kfcRed,
                                ),
                                const Text(
                                  'Chỉ hiện khuyến mãi',
                                  style: TextStyle(color: MauSac.trang),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                timKiemProvider.xoaBoLoc();
                              },
                              child: const Text(
                                'Xóa bộ lọc',
                                style: TextStyle(color: MauSac.kfcRed),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          // Phần kết quả tìm kiếm
          Expanded(
            child: Consumer<TimKiemProvider>(
              builder: (context, timKiemProvider, child) {
                final ketQuaTimKiem = timKiemProvider.ketQuaTimKiem;
                
                if (ketQuaTimKiem.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: MauSac.xam,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Không tìm thấy kết quả',
                          style: TextStyle(
                            color: MauSac.trang,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Thử tìm kiếm với từ khóa khác',
                          style: TextStyle(
                            color: MauSac.xam,
                            fontSize: 14,
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
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: ketQuaTimKiem.length,
                  itemBuilder: (context, index) {
                    return TheSanPham(
                      sanPham: ketQuaTimKiem[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManHinhChiTietSanPham(
                              sanPham: ketQuaTimKiem[index],
                            ),
                          ),
                        );
                      },
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

  Widget _buildDanhMucChip(String ten, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? MauSac.kfcRed : MauSac.denNen,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? MauSac.kfcRed : MauSac.xamDam,
          ),
        ),
        child: Text(
          ten,
          style: TextStyle(
            color: MauSac.trang,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSapXepChip(String ten, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? MauSac.kfcRed : MauSac.denNen,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? MauSac.kfcRed : MauSac.xamDam,
          ),
        ),
        child: Text(
          ten,
          style: TextStyle(
            color: MauSac.trang,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
