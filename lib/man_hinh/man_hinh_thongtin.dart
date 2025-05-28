import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Snowflake {
  double x;
  double y;
  double size;
  double speed;

  Snowflake({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}

class ManHinhThongTin extends StatefulWidget {
  const ManHinhThongTin({Key? key}) : super(key: key);

  @override
  State<ManHinhThongTin> createState() => _ManHinhThongTinState();
}

class _ManHinhThongTinState extends State<ManHinhThongTin>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<Snowflake> _snowflakes = [];
  final int _snowflakeCount = 50;
  late Timer _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();

    _initSnowflakes();
    _startSnowfall();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _initSnowflakes() {
    _snowflakes = List.generate(_snowflakeCount, (index) {
      return Snowflake(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 4 + 2,
        speed: _random.nextDouble() * 0.01 + 0.002,
      );
    });
  }

  void _startSnowfall() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        _snowflakes.forEach((snowflake) {
          snowflake.y += snowflake.speed;
          if (snowflake.y > 1) {
            snowflake.y = 0;
            snowflake.x = _random.nextDouble();
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông Tin'),
        backgroundColor: Colors.redAccent,
      ),
      body: Stack(
        children: [
          // Bông tuyết
          ..._snowflakes.map((snowflake) {
            return Positioned(
              left: snowflake.x * screenWidth,
              top: snowflake.y * screenHeight,
              child: Icon(
                Icons.ac_unit,
                size: snowflake.size,
                color: Colors.white.withOpacity(0.8),
              ),
            );
          }).toList(),

          // Nội dung thông tin


          FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'KFC Việt Nam',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Chào mừng bạn đến với KFC!',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Địa chỉ: 123 Đường Ăn Ngon, Quận 1, TP.HCM',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Liên hệ: 0886511009 (miễn phí)',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Website: www.kfcvietnam.vn',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),

                    Text(
                      'Giờ hoạt động: 8:00 - 22:00 hàng ngày',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Chính sách giao hàng: Miễn phí giao hàng cho đơn từ 200,000 VNĐ trong bán kính 5km.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Chính sách hoàn trả: Đổi trả trong vòng 24 giờ nếu sản phẩm không đúng yêu cầu.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Hãy theo dõi chúng tôi trên mạng xã hội:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Facebook: facebook.com/kfcvietnam\nInstagram: @kfcvietnam\nTikTok: @kfcvietnam',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),



        ],
      ),
    );
  }
}
