import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:kfc/man_hinh/man_hinh_chao.dart';
import 'package:kfc/man_hinh/man_hinh_vi_tri.dart';
import 'package:kfc/man_hinh/man_hinh_danh_muc.dart';
import 'package:kfc/man_hinh/man_hinh_gio_hang.dart';
import 'package:kfc/man_hinh/man_hinh_tai_khoan.dart';
import 'package:kfc/man_hinh/man_hinh_yeu_thich.dart';
import 'package:kfc/widgets/thanh_dieu_huong.dart';
import 'package:provider/provider.dart';
import 'package:kfc/providers/thong_bao_provider.dart';

class TrangChu extends StatefulWidget {
  const TrangChu({Key? key}) : super(key: key);

  @override
  State<TrangChu> createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> with SingleTickerProviderStateMixin {
  int _trangHienTai = 0;
  bool _daHienManHinhChao = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Widget> _manHinh = [
    const ManHinhDanhMuc(),
    const ManHinhGioHang(),
    const ManHinhYeuThich(),
    const ManHinhTaiKhoan(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
    _kiemTraManHinhChao();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _kiemTraManHinhChao() async {
    // Kiểm tra xem đã hiển thị màn hình chào chưa
    // Trong thực tế, bạn có thể sử dụng SharedPreferences để lưu trạng thái này
    if (!_daHienManHinhChao) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ManHinhChao(),
          ),
        ).then((_) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ManHinhViTri(),
            ),
          );
        });
        setState(() {
          _daHienManHinhChao = true;
        });
      }
    }
  }

  void _chuyenTrang(int index) {
    if (_trangHienTai != index) {
      _animationController.reset();
      setState(() {
        _trangHienTai = index;
      });
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _manHinh[_trangHienTai],
      ),
      bottomNavigationBar: ThanhDieuHuong(
        trangHienTai: _trangHienTai,
        onTap: _chuyenTrang,
        soThongBaoChuaDoc: context.watch<ThongBaoProvider>().soThongBaoChuaDoc,
      ),
    );
  }
}
