import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:kfc/models/danh_muc.dart';
import 'package:kfc/widgets/hinh_anh_an_toan.dart';

class TheDanhMuc extends StatelessWidget {
  final DanhMuc danhMuc;

  const TheDanhMuc({
    Key? key,
    required this.danhMuc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 100, // Đặt chiều cao cố định để tránh tràn
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Thêm dòng này để Column chỉ chiếm không gian cần thiết
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: MauSac.denNhat,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: HinhAnhAnToan(
                duongDan: danhMuc.hinhAnh,
                chieuRong: 40,
                chieuCao: 40,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded( // Bọc Text trong Expanded để tránh tràn
            child: Text(
              danhMuc.ten,
              style: const TextStyle(
                color: MauSac.trang,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
