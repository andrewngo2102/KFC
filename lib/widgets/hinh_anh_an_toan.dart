import 'package:flutter/material.dart';

class HinhAnhAnToan extends StatelessWidget {
  final String duongDan;
  final double? chieuRong;
  final double? chieuCao;
  final BoxFit? cach;
  final Widget? widgetThayThe;

  const HinhAnhAnToan({
    Key? key,
    required this.duongDan,
    this.chieuRong,
    this.chieuCao,
    this.cach,
    this.widgetThayThe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Thay vì sử dụng Image.asset trực tiếp, sử dụng FadeInImage với placeholder
    return FadeInImage(
      placeholder: const AssetImage('assets/images/placeholder.png'),
      image: AssetImage(duongDan),
      width: chieuRong,
      height: chieuCao,
      fit: cach ?? BoxFit.contain,
      imageErrorBuilder: (context, error, stackTrace) {
        // Khi có lỗi tải hình ảnh, hiển thị widget thay thế hoặc container màu xám
        return widgetThayThe ??
            Container(
              width: chieuRong,
              height: chieuCao,
              color: Colors.grey[300],
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                ),
              ),
            );
      },
    );
  }
}
