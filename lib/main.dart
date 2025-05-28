import 'package:flutter/material.dart';
import 'package:kfc/trang_chu.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:provider/provider.dart';
import 'package:kfc/providers/gio_hang_provider.dart';
import 'package:kfc/providers/nguoi_dung_provider.dart';
import 'package:kfc/providers/dia_chi_provider.dart';
import 'package:kfc/providers/tim_kiem_provider.dart';
import 'package:kfc/providers/yeu_thich_provider.dart';
import 'package:kfc/providers/thong_bao_provider.dart';
import 'package:kfc/providers/danh_gia_provider.dart';
import 'package:kfc/providers/xem_gan_day_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GioHangProvider()),
        ChangeNotifierProvider(create: (_) => NguoiDungProvider()),
        ChangeNotifierProvider(create: (_) => DiaChiProvider()),
        ChangeNotifierProvider(create: (_) => TimKiemProvider()),
        ChangeNotifierProvider(create: (_) => YeuThichProvider()),
        ChangeNotifierProvider(create: (_) => ThongBaoProvider()),
        ChangeNotifierProvider(create: (_) => DanhGiaProvider()),
        ChangeNotifierProvider(create: (_) => XemGanDayProvider()),
      ],
      child: MaterialApp(
        title: 'KFC Việt Nam',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: MauSac.kfcRed,
          scaffoldBackgroundColor: MauSac.denNen,
          fontFamily: 'Roboto',
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: MauSac.trang),
            bodyMedium: TextStyle(color: MauSac.trang),
            titleLarge: TextStyle(color: MauSac.trang, fontWeight: FontWeight.bold),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: MauSac.denNen,
            elevation: 0,
            iconTheme: IconThemeData(color: MauSac.trang),
          ),
        ),
        home: const TrangChu(),
      ),
    );
  }
}
