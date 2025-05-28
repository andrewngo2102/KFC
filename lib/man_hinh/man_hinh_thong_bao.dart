import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:provider/provider.dart';
import 'package:kfc/providers/thong_bao_provider.dart';
import 'package:intl/intl.dart';

class ManHinhThongBao extends StatefulWidget {
  const ManHinhThongBao({Key? key}) : super(key: key);

  @override
  State<ManHinhThongBao> createState() => _ManHinhThongBaoState();
}

class _ManHinhThongBaoState extends State<ManHinhThongBao> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _loaiThongBaoHienTai = 'tat_ca';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        switch (_tabController.index) {
          case 0:
            _loaiThongBaoHienTai = 'tat_ca';
            break;
          case 1:
            _loaiThongBaoHienTai = 'khuyen_mai';
            break;
          case 2:
            _loaiThongBaoHienTai = 'don_hang';
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông báo',
          style: TextStyle(
            color: MauSac.trang,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<ThongBaoProvider>(
            builder: (context, thongBaoProvider, child) {
              if (thongBaoProvider.danhSachThongBao.isNotEmpty) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: MauSac.trang),
                  onSelected: (value) {
                    if (value == 'danh_dau_da_doc') {
                      thongBaoProvider.danhDauTatCaDaDoc();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đã đánh dấu tất cả là đã đọc'),
                          backgroundColor: MauSac.xanhLa,
                        ),
                      );
                    } else if (value == 'xoa_tat_ca') {
                      _xacNhanXoaTatCa(context);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'danh_dau_da_doc',
                      child: Text('Đánh dấu tất cả là đã đọc'),
                    ),
                    const PopupMenuItem(
                      value: 'xoa_tat_ca',
                      child: Text('Xóa tất cả thông báo'),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: MauSac.kfcRed,
          labelColor: MauSac.kfcRed,
          unselectedLabelColor: MauSac.xam,
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Khuyến mãi'),
            Tab(text: 'Đơn hàng'),
          ],
        ),
      ),
      body: Consumer<ThongBaoProvider>(
        builder: (context, thongBaoProvider, child) {
          final danhSachThongBao = thongBaoProvider.locThongBaoTheoLoai(_loaiThongBaoHienTai);
          
          if (danhSachThongBao.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 80,
                    color: MauSac.xam,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Không có thông báo nào',
                    style: TextStyle(
                      color: MauSac.trang,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: danhSachThongBao.length,
            itemBuilder: (context, index) {
              final thongBao = danhSachThongBao[index];
              return Dismissible(
                key: Key(thongBao.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  thongBaoProvider.xoaThongBao(thongBao.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã xóa thông báo'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                child: InkWell(
                  onTap: () {
                    thongBaoProvider.danhDauDaDoc(thongBao.id);
                    _hienThiChiTietThongBao(context, thongBao);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: thongBao.daDoc ? MauSac.denNhat : MauSac.denNhat.withOpacity(0.7),
                      border: Border(
                        bottom: BorderSide(color: MauSac.xamDam, width: 0.5),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!thongBao.daDoc)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 6, right: 8),
                            decoration: const BoxDecoration(
                              color: MauSac.kfcRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                        if (thongBao.hinhAnh != null)
                          Container(
                            width: 60,
                            height: 60,
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: MauSac.denNhat,
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage(thongBao.hinhAnh!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                thongBao.tieuDe,
                                style: TextStyle(
                                  color: MauSac.trang,
                                  fontSize: 16,
                                  fontWeight: thongBao.daDoc ? FontWeight.normal : FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                thongBao.noiDung,
                                style: TextStyle(
                                  color: MauSac.xam,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _formatThoiGian(thongBao.thoiGian),
                                style: TextStyle(
                                  color: MauSac.xam,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatThoiGian(DateTime thoiGian) {
    final now = DateTime.now();
    final difference = now.difference(thoiGian);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  void _hienThiChiTietThongBao(BuildContext context, ThongBao thongBao) {
    showModalBottomSheet(
      context: context,
      backgroundColor: MauSac.denNhat,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    thongBao.tieuDe,
                    style: const TextStyle(
                      color: MauSac.trang,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: MauSac.xam),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _formatThoiGianChiTiet(thongBao.thoiGian),
                style: TextStyle(
                  color: MauSac.xam,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              if (thongBao.hinhAnh != null)
                Container(
                  width: double.infinity,
                  height: 200,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(thongBao.hinhAnh!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Text(
                thongBao.noiDung,
                style: const TextStyle(
                  color: MauSac.trang,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MauSac.kfcRed,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Đã hiểu',
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
        );
      },
    );
  }

  String _formatThoiGianChiTiet(DateTime thoiGian) {
    final formatter = DateFormat('HH:mm - dd/MM/yyyy');
    return formatter.format(thoiGian);
  }

  void _xacNhanXoaTatCa(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MauSac.denNhat,
        title: const Text(
          'Xóa tất cả thông báo',
          style: TextStyle(
            color: MauSac.trang,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn xóa tất cả thông báo?',
          style: TextStyle(color: MauSac.trang),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Hủy',
              style: TextStyle(color: MauSac.xam),
            ),
          ),
          TextButton(
            onPressed: () {
              final thongBaoProvider = Provider.of<ThongBaoProvider>(context, listen: false);
              thongBaoProvider.xoaTatCa();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã xóa tất cả thông báo'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              'Xóa',
              style: TextStyle(color: MauSac.kfcRed),
            ),
          ),
        ],
      ),
    );
  }
}
