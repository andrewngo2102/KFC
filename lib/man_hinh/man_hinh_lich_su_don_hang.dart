import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';

class ManHinhLichSuDonHang extends StatelessWidget {
  const ManHinhLichSuDonHang({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu cho lịch sử đơn hàng
    final danhSachDonHang = [
      {
        'id': 'KFC123456',
        'ngay': '12/04/2023',
        'trangThai': 'Đã giao',
        'tongTien': 499000,
        'danhSachSanPham': [
          {'ten': 'Krispy Box', 'soLuong': 2},
          {'ten': 'Pepsi', 'soLuong': 1},
        ],
      },
      {
        'id': 'KFC123457',
        'ngay': '05/04/2023',
        'trangThai': 'Đã giao',
        'tongTien': 350000,
        'danhSachSanPham': [
          {'ten': 'Krunch Burger', 'soLuong': 1},
          {'ten': 'Fries', 'soLuong': 1},
        ],
      },
      {
        'id': 'KFC123458',
        'ngay': '28/03/2023',
        'trangThai': 'Đã hủy',
        'tongTien': 650000,
        'danhSachSanPham': [
          {'ten': 'Signature Box', 'soLuong': 1},
          {'ten': 'Krispy Box', 'soLuong': 1},
        ],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lịch sử đơn hàng',
          style: TextStyle(
            color: MauSac.trang,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: danhSachDonHang.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 80,
                    color: MauSac.xam,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bạn chưa có đơn hàng nào',
                    style: TextStyle(
                      color: MauSac.trang,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: danhSachDonHang.length,
              itemBuilder: (context, index) {
                final donHang = danhSachDonHang[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: MauSac.denNhat,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Đơn hàng #${donHang['id']}',
                                  style: TextStyle(
                                    color: MauSac.trang,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Ngày: ${donHang['ngay']}',
                                  style: TextStyle(
                                    color: MauSac.xam,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: donHang['trangThai'] == 'Đã giao'
                                    ? MauSac.xanhLa
                                    : MauSac.kfcRed,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                donHang['trangThai'] as String,
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
                      const Divider(color: MauSac.xamDam),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ...(donHang['danhSachSanPham'] as List).map((sanPham) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${sanPham['soLuong']}x ${sanPham['ten']}',
                                      style: TextStyle(
                                        color: MauSac.trang,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tổng tiền:',
                                  style: TextStyle(
                                    color: MauSac.trang,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${donHang['tongTien']} VND',
                                  style: TextStyle(
                                    color: MauSac.kfcRed,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  // Xử lý đặt lại
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: MauSac.kfcRed),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Text(
                                  'Đặt lại',
                                  style: TextStyle(
                                    color: MauSac.kfcRed,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Xử lý xem chi tiết
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MauSac.kfcRed,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Text(
                                  'Chi tiết',
                                  style: TextStyle(
                                    color: MauSac.trang,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
