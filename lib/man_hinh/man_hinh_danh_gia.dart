import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:kfc/models/san_pham.dart';
import 'package:provider/provider.dart';
import 'package:kfc/providers/danh_gia_provider.dart';
import 'package:kfc/providers/nguoi_dung_provider.dart';
import 'package:intl/intl.dart';

class ManHinhDanhGia extends StatelessWidget {
  final SanPham sanPham;
  
  const ManHinhDanhGia({
    Key? key,
    required this.sanPham,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đánh giá sản phẩm',
          style: TextStyle(
            color: MauSac.trang,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<DanhGiaProvider>(
        builder: (context, danhGiaProvider, child) {
          final danhSachDanhGia = danhGiaProvider.layDanhGiaTheoSanPham(sanPham.id);
          final trungBinhSao = danhGiaProvider.tinhTrungBinhSao(sanPham.id);
          
          return Column(
            children: [
              // Phần thông tin sản phẩm và đánh giá trung bình
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: MauSac.denNhat,
                  border: Border(
                    bottom: BorderSide(color: MauSac.xamDam, width: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: MauSac.denNhat,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Image.asset(
                          sanPham.hinhAnh,
                          width: 60,
                          height: 60,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.fastfood,
                              size: 40,
                              color: MauSac.kfcRed,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sanPham.ten,
                            style: const TextStyle(
                              color: MauSac.trang,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                trungBinhSao.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: MauSac.trang,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < trungBinhSao.floor()
                                        ? Icons.star
                                        : (index < trungBinhSao.ceil() && trungBinhSao.floor() != trungBinhSao.ceil())
                                            ? Icons.star_half
                                            : Icons.star_border,
                                    color: MauSac.vang,
                                    size: 18,
                                  );
                                }),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '(${danhSachDanhGia.length} đánh giá)',
                                style: TextStyle(
                                  color: MauSac.xam,
                                  fontSize: 14,
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
              
              // Nút thêm đánh giá
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final nguoiDungProvider = Provider.of<NguoiDungProvider>(context, listen: false);
                      if (!nguoiDungProvider.daDangNhap) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Vui lòng đăng nhập để đánh giá'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      
                      _hienThiFormDanhGia(context, sanPham);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MauSac.kfcRed,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Viết đánh giá',
                      style: TextStyle(
                        color: MauSac.trang,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Danh sách đánh giá
              Expanded(
                child: danhSachDanhGia.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.rate_review,
                              size: 80,
                              color: MauSac.xam,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Chưa có đánh giá nào',
                              style: TextStyle(
                                color: MauSac.trang,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Hãy là người đầu tiên đánh giá sản phẩm này',
                              style: TextStyle(
                                color: MauSac.xam,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: danhSachDanhGia.length,
                        itemBuilder: (context, index) {
                          final danhGia = danhSachDanhGia[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: MauSac.xamDam, width: 0.5),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      danhGia.tenNguoiDung,
                                      style: const TextStyle(
                                        color: MauSac.trang,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _formatThoiGian(danhGia.thoiGian),
                                      style: TextStyle(
                                        color: MauSac.xam,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < danhGia.sao ? Icons.star : Icons.star_border,
                                      color: MauSac.vang,
                                      size: 16,
                                    );
                                  }),
                                ),
                                if (danhGia.noiDung != null && danhGia.noiDung!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      danhGia.noiDung!,
                                      style: const TextStyle(
                                        color: MauSac.trang,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatThoiGian(DateTime thoiGian) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(thoiGian);
  }

  void _hienThiFormDanhGia(BuildContext context, SanPham sanPham) {
    final danhGiaProvider = Provider.of<DanhGiaProvider>(context, listen: false);
    final nguoiDungProvider = Provider.of<NguoiDungProvider>(context, listen: false);
    
    if (nguoiDungProvider.nguoiDung == null) return;
    
    final nguoiDungId = nguoiDungProvider.nguoiDung!.id;
    final tenNguoiDung = nguoiDungProvider.nguoiDung!.ten;
    
    // Kiểm tra xem người dùng đã đánh giá sản phẩm này chưa
    if (danhGiaProvider.daNguoiDungDanhGia(sanPham.id, nguoiDungId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bạn đã đánh giá sản phẩm này rồi'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    double sao = 5.0;
    final noiDungController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: MauSac.denNhat,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Đánh giá sản phẩm',
                    style: TextStyle(
                      color: MauSac.trang,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < sao ? Icons.star : Icons.star_border,
                          color: MauSac.vang,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            sao = index + 1.0;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: noiDungController,
                    style: const TextStyle(color: MauSac.trang),
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Nhập đánh giá của bạn (tùy chọn)',
                      hintStyle: TextStyle(color: MauSac.xam),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: MauSac.xamDam),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: MauSac.kfcRed),
                      ),
                      filled: true,
                      fillColor: MauSac.denNhat,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Tạo đánh giá mới
                        final danhGiaMoi = DanhGia(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          sanPhamId: sanPham.id,
                          nguoiDungId: nguoiDungId,
                          tenNguoiDung: tenNguoiDung,
                          sao: sao,
                          noiDung: noiDungController.text.isNotEmpty ? noiDungController.text : null,
                          thoiGian: DateTime.now(),
                        );
                        
                        danhGiaProvider.themDanhGia(danhGiaMoi);
                        Navigator.pop(context);
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cảm ơn bạn đã đánh giá'),
                            backgroundColor: MauSac.xanhLa,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MauSac.kfcRed,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Gửi đánh giá',
                        style: TextStyle(
                          color: MauSac.trang,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
