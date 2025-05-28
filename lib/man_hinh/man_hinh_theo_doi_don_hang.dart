import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:provider/provider.dart';
import 'package:kfc/providers/dia_chi_provider.dart';
import 'dart:async';

class ManHinhTheoDoi extends StatefulWidget {
  const ManHinhTheoDoi({Key? key}) : super(key: key);

  @override
  State<ManHinhTheoDoi> createState() => _ManHinhTheoDoiState();
}

class _ManHinhTheoDoiState extends State<ManHinhTheoDoi> {
  Timer? _timer;
  int _thoiGianConLai = 15; // Phút
  int _tiepTucGiaoHang = 0; // 0-100%

  @override
  void initState() {
    super.initState();
    
    // Đếm ngược thời gian giao hàng
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        if (_thoiGianConLai > 0) {
          _thoiGianConLai--;
        } else {
          timer.cancel();
        }
      });
    });

    // Cập nhật tiến trình giao hàng
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        if (_tiepTucGiaoHang < 100) {
          _tiepTucGiaoHang += 5;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diaChiProvider = Provider.of<DiaChiProvider>(context);
    final diaChiHienTai = diaChiProvider.diaChiHienTai;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trạng thái đơn hàng',
          style: TextStyle(
            color: MauSac.trang,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTrangThaiDonHang(
                      icon: Icons.check_circle,
                      title: 'Xác nhận',
                      isActive: true,
                      isCompleted: true,
                    ),
                    _buildDuongKe(isCompleted: true),
                    _buildTrangThaiDonHang(
                      icon: Icons.restaurant,
                      title: 'Chuẩn bị',
                      isActive: true,
                      isCompleted: true,
                    ),
                    _buildDuongKe(isCompleted: false),
                    _buildTrangThaiDonHang(
                      icon: Icons.delivery_dining,
                      title: 'Đang giao',
                      isActive: true,
                      isCompleted: false,
                    ),
                    _buildDuongKe(isCompleted: false),
                    _buildTrangThaiDonHang(
                      icon: Icons.done_all,
                      title: 'Đã giao',
                      isActive: false,
                      isCompleted: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Giao hàng trong khoảng',
                    style: TextStyle(
                      color: MauSac.trang,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$_thoiGianConLai phút',
                    style: TextStyle(
                      color: MauSac.kfcRed,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Thay thế Google Maps bằng giao diện đơn giản
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: MauSac.denNhat,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.delivery_dining,
                            color: MauSac.kfcRed,
                            size: 80,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Đơn hàng đang được giao',
                            style: TextStyle(
                              color: MauSac.trang,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Người giao hàng đang trên đường đến',
                            style: TextStyle(
                              color: MauSac.xam,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Tiến trình giao hàng',
                                      style: TextStyle(
                                        color: MauSac.trang,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '$_tiepTucGiaoHang%',
                                      style: const TextStyle(
                                        color: MauSac.kfcRed,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: _tiepTucGiaoHang / 100,
                                    backgroundColor: MauSac.xamDam,
                                    valueColor: const AlwaysStoppedAnimation<Color>(MauSac.kfcRed),
                                    minHeight: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: MauSac.denNhat,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: MauSac.kfcRed,
                          child: Icon(
                            Icons.person,
                            color: MauSac.trang,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'KFC - Nguyễn Văn Linh',
                                style: TextStyle(
                                  color: MauSac.trang,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Quận 7, TP.HCM',
                                style: TextStyle(
                                  color: MauSac.xam,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: MauSac.denNen,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: MauSac.kfcRed,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '0934 471258',
                                style: TextStyle(
                                  color: MauSac.trang,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: MauSac.denNhat,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          diaChiHienTai?.tenDiaChi.toLowerCase() == 'nhà'
                              ? Icons.home
                              : diaChiHienTai?.tenDiaChi.toLowerCase() == 'công ty'
                                  ? Icons.business
                                  : Icons.location_on,
                          color: MauSac.kfcRed,
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${diaChiHienTai?.tenDiaChi ?? 'Địa chỉ'}: ${diaChiHienTai?.diaChiChiTiet ?? 'Không có thông tin'}',
                                style: TextStyle(
                                  color: MauSac.trang,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrangThaiDonHang({
    required IconData icon,
    required String title,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? MauSac.kfcRed : MauSac.xamDam,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted ? Icons.check : icon,
            color: MauSac.trang,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: isActive ? MauSac.trang : MauSac.xam,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDuongKe({required bool isCompleted}) {
    return Container(
      width: 30,
      height: 2,
      color: isCompleted ? MauSac.kfcRed : MauSac.xamDam,
    );
  }
}
