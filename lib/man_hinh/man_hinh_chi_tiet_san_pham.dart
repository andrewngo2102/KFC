import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:kfc/models/san_pham.dart';
import 'package:provider/provider.dart';
import 'package:kfc/providers/gio_hang_provider.dart';
import 'package:kfc/providers/yeu_thich_provider.dart';
import 'package:kfc/providers/danh_gia_provider.dart';
import 'package:kfc/providers/xem_gan_day_provider.dart';
import 'package:kfc/widgets/hinh_anh_an_toan.dart';
import 'package:kfc/data/du_lieu_mau.dart';
import 'package:kfc/man_hinh/man_hinh_danh_gia.dart';

class ManHinhChiTietSanPham extends StatefulWidget {
  final SanPham sanPham;

  const ManHinhChiTietSanPham({
    Key? key,
    required this.sanPham,
  }) : super(key: key);

  @override
  State<ManHinhChiTietSanPham> createState() => _ManHinhChiTietSanPhamState();
}

class _ManHinhChiTietSanPhamState extends State<ManHinhChiTietSanPham> {
  bool _daChonFries = false;
  bool _daChonMirinda = false;
  bool _daChonPepsi = false;
  int _soLuong = 1;
  late List<SanPham> _sanPhamLienQuan;

  @override
  void initState() {
    super.initState();
    _sanPhamLienQuan = DuLieuMau.laySanPhamLienQuan(widget.sanPham);
    
    // Thêm sản phẩm vào danh sách xem gần đây
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final xemGanDayProvider = Provider.of<XemGanDayProvider>(context, listen: false);
      xemGanDayProvider.themSanPhamXemGanDay(widget.sanPham);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tính giá sau khuyến mãi
    final giaSauKhuyenMai = widget.sanPham.khuyenMai == true && widget.sanPham.giamGia != null
        ? widget.sanPham.gia - (widget.sanPham.gia * widget.sanPham.giamGia! ~/ 100)
        : widget.sanPham.gia;

    // Tính tổng tiền
    int tongTien = giaSauKhuyenMai * _soLuong;
    if (_daChonFries) tongTien += 25000;
    if (_daChonMirinda) tongTien += 15000;
    if (_daChonPepsi) tongTien += 15000;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.sanPham.ten,
          style: const TextStyle(
            color: MauSac.trang,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<YeuThichProvider>(
            builder: (context, yeuThichProvider, child) {
              final isYeuThich = yeuThichProvider.kiemTraYeuThich(widget.sanPham.id);
              return IconButton(
                icon: Icon(
                  isYeuThich ? Icons.favorite : Icons.favorite_border,
                  color: isYeuThich ? MauSac.kfcRed : MauSac.trang,
                ),
                onPressed: () {
                  yeuThichProvider.toggleYeuThich(widget.sanPham);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isYeuThich 
                            ? 'Đã xóa ${widget.sanPham.ten} khỏi danh sách yêu thích' 
                            : 'Đã thêm ${widget.sanPham.ten} vào danh sách yêu thích'
                      ),
                      backgroundColor: isYeuThich ? Colors.grey : MauSac.kfcRed,
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: MauSac.trang),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã sao chép liên kết sản phẩm'),
                  backgroundColor: MauSac.xanhLa,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần hình ảnh sản phẩm
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: MauSac.denNhat,
                  ),
                  child: Center(
                    child: Hero(
                      tag: 'product_${widget.sanPham.id}',
                      child: HinhAnhAnToan(
                        duongDan: widget.sanPham.hinhAnh,
                        chieuCao: 180,
                      ),
                    ),
                  ),
                ),
                if (widget.sanPham.khuyenMai == true && widget.sanPham.giamGia != null)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: MauSac.kfcRed,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Giảm ${widget.sanPham.giamGia}%',
                        style: const TextStyle(
                          color: MauSac.trang,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Phần thông tin sản phẩm
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.sanPham.ten,
                          style: const TextStyle(
                            color: MauSac.trang,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${giaSauKhuyenMai}đ',
                            style: const TextStyle(
                              color: MauSac.trang,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.sanPham.khuyenMai == true && widget.sanPham.giamGia != null)
                            Text(
                              '${widget.sanPham.gia}đ',
                              style: const TextStyle(
                                color: MauSac.xam,
                                fontSize: 16,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Đánh giá
                  Consumer<DanhGiaProvider>(
                    builder: (context, danhGiaProvider, child) {
                      final trungBinhSao = danhGiaProvider.tinhTrungBinhSao(widget.sanPham.id);
                      final soLuongDanhGia = danhGiaProvider.layDanhGiaTheoSanPham(widget.sanPham.id).length;
                      
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManHinhDanhGia(
                                sanPham: widget.sanPham,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
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
                              trungBinhSao > 0 ? trungBinhSao.toStringAsFixed(1) : '0.0',
                              style: TextStyle(
                                color: MauSac.trang,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '($soLuongDanhGia đánh giá)',
                              style: TextStyle(
                                color: MauSac.xam,
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: MauSac.xam,
                              size: 14,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Mô tả
                  Text(
                    widget.sanPham.moTa,
                    style: TextStyle(
                      color: MauSac.xam,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Số lượng
                  Row(
                    children: [
                      const Text(
                        'Số lượng:',
                        style: TextStyle(
                          color: MauSac.trang,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: MauSac.denNhat,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: MauSac.trang),
                              onPressed: () {
                                if (_soLuong > 1) {
                                  setState(() {
                                    _soLuong--;
                                  });
                                }
                              },
                            ),
                            Text(
                              '$_soLuong',
                              style: const TextStyle(
                                color: MauSac.trang,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: MauSac.trang),
                              onPressed: () {
                                setState(() {
                                  _soLuong++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Tùy chọn thêm
                  const Text(
                    'Tùy chọn thêm',
                    style: TextStyle(
                      color: MauSac.trang,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTuyChonItem(
                    'Khoai tây chiên',
                    'assets/images/fries.png',
                    '25.000đ',
                    _daChonFries,
                    (value) {
                      setState(() {
                        _daChonFries = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildTuyChonItem(
                    'Mirinda',
                    'assets/images/mirinda.png',
                    '15.000đ',
                    _daChonMirinda,
                    (value) {
                      setState(() {
                        _daChonMirinda = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildTuyChonItem(
                    'Pepsi',
                    'assets/images/pepsi.png',
                    '15.000đ',
                    _daChonPepsi,
                    (value) {
                      setState(() {
                        _daChonPepsi = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  // Sản phẩm liên quan
                  if (_sanPhamLienQuan.isNotEmpty) ...[
                    const Text(
                      'Sản phẩm liên quan',
                      style: TextStyle(
                        color: MauSac.trang,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _sanPhamLienQuan.length,
                        itemBuilder: (context, index) {
                          final sanPham = _sanPhamLienQuan[index];
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
                              width: 140,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: MauSac.denNhat,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 100,
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
                                        chieuCao: 80,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sanPham.ten,
                                          style: const TextStyle(
                                            color: MauSac.trang,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${sanPham.gia}đ',
                                          style: const TextStyle(
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
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: MauSac.denNen,
          border: Border(
            top: BorderSide(color: MauSac.xamDam, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // Tổng tiền
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tổng tiền',
                    style: TextStyle(
                      color: MauSac.xam,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${tongTien}đ',
                    style: const TextStyle(
                      color: MauSac.trang,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Nút thêm vào giỏ hàng
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  final gioHangProvider = Provider.of<GioHangProvider>(context, listen: false);
                  
                  // Thêm sản phẩm chính vào giỏ hàng
                  for (int i = 0; i < _soLuong; i++) {
                    gioHangProvider.themSanPham(widget.sanPham);
                  }
                  
                  // Thêm các tùy chọn nếu được chọn
                  if (_daChonFries) {
                    final khoaiTay = DuLieuMau.danhSachSanPham.firstWhere(
                      (sp) => sp.id == '401',
                      orElse: () => widget.sanPham,
                    );
                    gioHangProvider.themSanPham(khoaiTay);
                  }
                  
                  if (_daChonMirinda) {
                    final mirinda = SanPham(
                      id: 'mirinda',
                      ten: 'Mirinda',
                      gia: 15000,
                      hinhAnh: 'assets/images/mirinda.png',
                      moTa: 'Mirinda mát lạnh',
                      danhMucId: '5',
                    );
                    gioHangProvider.themSanPham(mirinda);
                  }
                  
                  if (_daChonPepsi) {
                    final pepsi = DuLieuMau.danhSachSanPham.firstWhere(
                      (sp) => sp.id == '501',
                      orElse: () => widget.sanPham,
                    );
                    gioHangProvider.themSanPham(pepsi);
                  }
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã thêm ${widget.sanPham.ten} vào giỏ hàng'),
                      backgroundColor: MauSac.xanhLa,
                      action: SnackBarAction(
                        label: 'XEM GIỎ HÀNG',
                        textColor: MauSac.trang,
                        onPressed: () {
                          // Chuyển đến màn hình giỏ hàng
                          Navigator.pop(context);
                          // Cần cập nhật index trong TrangChu để chuyển đến tab giỏ hàng
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MauSac.kfcRed,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Thêm vào giỏ hàng',
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
      ),
    );
  }

  Widget _buildTuyChonItem(String ten, String hinhAnh, String gia, bool daChon, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: MauSac.denNhat,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          HinhAnhAnToan(
            duongDan: hinhAnh,
            chieuRong: 40,
            chieuCao: 40,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ten,
                  style: const TextStyle(
                    color: MauSac.trang,
                    fontSize: 16,
                  ),
                ),
                Text(
                  gia,
                  style: TextStyle(
                    color: MauSac.xam,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: daChon,
            onChanged: (value) => onChanged(value!),
            activeColor: MauSac.kfcRed,
            checkColor: MauSac.trang,
            side: BorderSide(color: MauSac.xam),
          ),
        ],
      ),
    );
  }
}
