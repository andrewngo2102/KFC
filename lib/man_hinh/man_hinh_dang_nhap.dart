import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:kfc/models/nguoi_dung.dart';
import 'package:provider/provider.dart';
import 'package:kfc/providers/nguoi_dung_provider.dart';
import 'package:kfc/man_hinh/man_hinh_dang_ky.dart';

class ManHinhDangNhap extends StatefulWidget {
  const ManHinhDangNhap({Key? key}) : super(key: key);

  @override
  State<ManHinhDangNhap> createState() => _ManHinhDangNhapState();
}

class _ManHinhDangNhapState extends State<ManHinhDangNhap> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _matKhauController = TextEditingController();
  bool _hienMatKhau = false;

  @override
  void dispose() {
    _emailController.dispose();
    _matKhauController.dispose();
    super.dispose();
  }

  void _dangNhap() {
    if (_formKey.currentState!.validate()) {
      // Trong thực tế, bạn sẽ gọi Firebase Authentication ở đây
      // Đây là mô phỏng đăng nhập thành công
      final nguoiDungProvider = Provider.of<NguoiDungProvider>(context, listen: false);
      nguoiDungProvider.dangNhap(
        NguoiDung(
          id: '1',
          ten: 'Nguyễn Văn A',
          email: _emailController.text,
          soDienThoai: '0987654321',
          diaChi: '123 Đường Nguyễn Văn Linh, Quận 7, TP.HCM',
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đăng nhập',
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
              Center(
                child: Image.asset(
                  'assets/images/kfc_logo.png',
                  width: 120,
                  height: 120,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Chào mừng trở lại',
                style: TextStyle(
                  color: MauSac.trang,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Đăng nhập để tiếp tục',
                style: TextStyle(
                  color: MauSac.xam,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
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
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Xử lý quên mật khẩu
                  },
                  child: Text(
                    'Quên mật khẩu?',
                    style: TextStyle(
                      color: MauSac.kfcRed,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _dangNhap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MauSac.kfcRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(
                      color: MauSac.trang,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Chưa có tài khoản? ',
                    style: TextStyle(
                      color: MauSac.xam,
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManHinhDangKy(),
                        ),
                      );
                    },
                    child: Text(
                      'Đăng ký',
                      style: TextStyle(
                        color: MauSac.kfcRed,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
