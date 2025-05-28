import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:kfc/models/nguoi_dung.dart';
import 'package:provider/provider.dart';
import 'package:kfc/providers/nguoi_dung_provider.dart';

class ManHinhDangKy extends StatefulWidget {
  const ManHinhDangKy({Key? key}) : super(key: key);

  @override
  State<ManHinhDangKy> createState() => _ManHinhDangKyState();
}

class _ManHinhDangKyState extends State<ManHinhDangKy> {
  final _formKey = GlobalKey<FormState>();
  final _tenController = TextEditingController();
  final _emailController = TextEditingController();
  final _soDienThoaiController = TextEditingController();
  final _matKhauController = TextEditingController();
  final _xacNhanMatKhauController = TextEditingController();
  bool _hienMatKhau = false;

  @override
  void dispose() {
    _tenController.dispose();
    _emailController.dispose();
    _soDienThoaiController.dispose();
    _matKhauController.dispose();
    _xacNhanMatKhauController.dispose();
    super.dispose();
  }

  void _dangKy() {
    if (_formKey.currentState!.validate()) {
      // Trong thực tế, bạn sẽ gọi Firebase Authentication ở đây
      // Đây là mô phỏng đăng ký thành công
      final nguoiDungProvider = Provider.of<NguoiDungProvider>(context, listen: false);
      nguoiDungProvider.dangNhap(
        NguoiDung(
          id: '1',
          ten: _tenController.text,
          email: _emailController.text,
          soDienThoai: _soDienThoaiController.text,
        ),
      );
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đăng ký',
          style: TextStyle(
            color: MauSac.trang,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tạo tài khoản mới',
                style: TextStyle(
                  color: MauSac.trang,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Vui lòng điền đầy đủ thông tin',
                style: TextStyle(
                  color: MauSac.xam,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _tenController,
                style: TextStyle(color: MauSac.trang),
                decoration: InputDecoration(
                  labelText: 'Họ và tên',
                  labelStyle: TextStyle(color: MauSac.xam),
                  prefixIcon: Icon(Icons.person, color: MauSac.xam),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MauSac.xamDam),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MauSac.kfcRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MauSac.kfcRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MauSac.kfcRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: MauSac.denNhat,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập họ và tên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                style: TextStyle(color: MauSac.trang),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: MauSac.xam),
                  prefixIcon: Icon(Icons.email, color: MauSac.xam),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MauSac.xamDam),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MauSac.kfcRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MauSac.kfcRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MauSac.kfcRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: MauSac.denNhat,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  if (!value.contains('@')) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _soDienThoaiController,
                style: TextStyle(color: MauSac.trang),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  labelStyle: TextStyle(color: MauSac.xam),
                  prefixIcon: Icon(Icons.phone, color: MauSac.xam),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MauSac.xamDam),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MauSac.kfcRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MauSac.kfcRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MauSac.kfcRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: MauSac.denNhat,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _matKhauController,
                style: TextStyle(color: MauSac.trang),
                obscureText: !_hienMatKhau,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  labelStyle: TextStyle(color: MauSac.xam),
                  prefixIcon: Icon(Icons.lock, color: MauSac.xam),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hienMatKhau ? Icons.visibility_off : Icons.visibility,
                      color: MauSac.xam,
                    ),
                    onPressed: () {
                      setState(() {
                        _hienMatKhau = !_hienMatKhau;
                      });
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MauSac.xamDam),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MauSac.kfcRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MauSac.kfcRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MauSac.kfcRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: MauSac.denNhat,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  if (value.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _xacNhanMatKhauController,
                style: TextStyle(color: MauSac.trang),
                obscureText: !_hienMatKhau,
                decoration: InputDecoration(
                  labelText: 'Xác nhận mật khẩu',
                  labelStyle: TextStyle(color: MauSac.xam),
                  prefixIcon: Icon(Icons.lock, color: MauSac.xam),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MauSac.xamDam),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MauSac.kfcRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MauSac.kfcRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MauSac.kfcRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: MauSac.denNhat,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng xác nhận mật khẩu';
                  }
                  if (value != _matKhauController.text) {
                    return 'Mật khẩu không khớp';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _dangKy,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MauSac.kfcRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Đăng ký',
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
      ),
    );
  }
}
