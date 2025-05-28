import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:kfc/models/dia_chi.dart';
import 'package:provider/provider.dart';
import 'package:kfc/providers/dia_chi_provider.dart';
import 'package:kfc/man_hinh/man_hinh_them_dia_chi.dart';

class ManHinhChonDiaChi extends StatelessWidget {
  const ManHinhChonDiaChi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chọn địa chỉ giao hàng',
          style: TextStyle(
            color: MauSac.trang,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: MauSac.trang),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManHinhThemDiaChi(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<DiaChiProvider>(
        builder: (context, diaChiProvider, child) {
          final danhSachDiaChi = diaChiProvider.danhSachDiaChi;
          final diaChiHienTai = diaChiProvider.diaChiHienTai;

          return ListView.builder(
            itemCount: danhSachDiaChi.length,
            itemBuilder: (context, index) {
              final diaChi = danhSachDiaChi[index];
              final isSelected = diaChiHienTai?.id == diaChi.id;

              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: MauSac.denNhat,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? MauSac.kfcRed : MauSac.denNhat,
                    width: 2,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Icon(
                    diaChi.tenDiaChi.toLowerCase() == 'nhà'
                        ? Icons.home
                        : diaChi.tenDiaChi.toLowerCase() == 'công ty'
                            ? Icons.business
                            : Icons.location_on,
                    color: isSelected ? MauSac.kfcRed : MauSac.trang,
                    size: 28,
                  ),
                  title: Text(
                    diaChi.tenDiaChi,
                    style: TextStyle(
                      color: MauSac.trang,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    diaChi.diaChiChiTiet,
                    style: TextStyle(
                      color: MauSac.xam,
                      fontSize: 14,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: MauSac.kfcRed,
                          size: 24,
                        )
                      : Icon(
                          Icons.arrow_forward_ios,
                          color: MauSac.xam,
                          size: 16,
                        ),
                  onTap: () {
                    diaChiProvider.chonDiaChi(diaChi);
                    Navigator.pop(context);
                  },
                  onLongPress: () {
                    _showOptionsDialog(context, diaChi);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showOptionsDialog(BuildContext context, DiaChi diaChi) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MauSac.denNhat,
        title: Text(
          'Tùy chọn',
          style: TextStyle(
            color: MauSac.trang,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: MauSac.trang),
              title: Text(
                'Chỉnh sửa',
                style: TextStyle(color: MauSac.trang),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManHinhThemDiaChi(diaChi: diaChi),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: MauSac.kfcRed),
              title: Text(
                'Xóa',
                style: TextStyle(color: MauSac.kfcRed),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, diaChi);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, DiaChi diaChi) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MauSac.denNhat,
        title: Text(
          'Xác nhận xóa',
          style: TextStyle(
            color: MauSac.trang,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa địa chỉ này?',
          style: TextStyle(color: MauSac.trang),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Hủy',
              style: TextStyle(color: MauSac.xam),
            ),
          ),
          TextButton(
            onPressed: () {
              final diaChiProvider = Provider.of<DiaChiProvider>(context, listen: false);
              diaChiProvider.xoaDiaChi(diaChi.id);
              Navigator.pop(context);
            },
            child: Text(
              'Xóa',
              style: TextStyle(color: MauSac.kfcRed),
            ),
          ),
        ],
      ),
    );
  }
}
