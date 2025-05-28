import 'package:flutter/material.dart';
import 'package:kfc/theme/mau_sac.dart';
import 'package:kfc/models/dia_chi.dart';
import 'package:provider/provider.dart';
import 'package:kfc/providers/dia_chi_provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class ManHinhThemDiaChi extends StatefulWidget {
  final DiaChi? diaChi;

  const ManHinhThemDiaChi({Key? key, this.diaChi}) : super(key: key);

  @override
  State<ManHinhThemDiaChi> createState() => _ManHinhThemDiaChiState();
}

class _ManHinhThemDiaChiState extends State<ManHinhThemDiaChi> {
  final _formKey = GlobalKey<FormState>();
  final _tenDiaChiController = TextEditingController();
  final _diaChiChiTietController = TextEditingController();
  final _ghiChuController = TextEditingController();

  double _viDo = 10.7553411; // Mặc định TP.HCM
  double _kinhDo = 106.7021555;
  bool _dangTimViTri = false;
  bool _dangTimKiemDiaChi = false;

  @override
  void initState() {
    super.initState();
    if (widget.diaChi != null) {
      _tenDiaChiController.text = widget.diaChi!.tenDiaChi;
      _diaChiChiTietController.text = widget.diaChi!.diaChiChiTiet;
      _ghiChuController.text = widget.diaChi?.ghiChu ?? '';
      
      if (widget.diaChi!.viDo != null && widget.diaChi!.kinhDo != null) {
        _viDo = widget.diaChi!.viDo!;
        _kinhDo = widget.diaChi!.kinhDo!;
      }
    } else {
      _layViTriHienTai();
    }
  }

  @override
  void dispose() {
    _tenDiaChiController.dispose();
    _diaChiChiTietController.dispose();
    _ghiChuController.dispose();
    super.dispose();
  }

  Future<void> _layViTriHienTai() async {
    setState(() {
      _dangTimViTri = true;
    });

    try {
      // Kiểm tra quyền truy cập vị trí
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Quyền bị từ chối, sử dụng vị trí mặc định
          setState(() {
            _dangTimViTri = false;
          });
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        // Quyền bị từ chối vĩnh viễn, sử dụng vị trí mặc định
        setState(() {
          _dangTimViTri = false;
        });
        return;
      }

      // Lấy vị trí hiện tại
      Position position = await Geolocator.getCurrentPosition();
      
      setState(() {
        _viDo = position.latitude;
        _kinhDo = position.longitude;
        _dangTimViTri = false;
      });
      
      // Lấy địa chỉ từ tọa độ
      _layDiaChiTuToaDo(_viDo, _kinhDo);
    } catch (e) {
      print('Lỗi khi lấy vị trí: $e');
      setState(() {
        _dangTimViTri = false;
      });
    }
  }

  Future<void> _layDiaChiTuToaDo(double viDo, double kinhDo) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(viDo, kinhDo);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String diaChi = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}';
        
        setState(() {
          _diaChiChiTietController.text = diaChi;
        });
      }
    } catch (e) {
      print('Lỗi khi lấy địa chỉ: $e');
    }
  }

  Future<void> _timKiemDiaChi() async {
    if (_diaChiChiTietController.text.isEmpty) return;

    setState(() {
      _dangTimKiemDiaChi = true;
    });

    try {
      List<Location> locations = await locationFromAddress(_diaChiChiTietController.text);

      if (locations.isNotEmpty) {
        Location location = locations.first;
        
        setState(() {
          _viDo = location.latitude;
          _kinhDo = location.longitude;
        });
      }
    } catch (e) {
      print('Lỗi khi tìm kiếm địa chỉ: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không tìm thấy địa chỉ. Vui lòng thử lại.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _dangTimKiemDiaChi = false;
      });
    }
  }

  void _luuDiaChi() {
    if (_formKey.currentState!.validate()) {
      final diaChiProvider = Provider.of<DiaChiProvider>(context, listen: false);
      
      if (widget.diaChi != null) {
        // Cập nhật địa chỉ hiện có
        final diaChiCapNhat = DiaChi(
          id: widget.diaChi!.id,
          tenDiaChi: _tenDiaChiController.text,
          diaChiChiTiet: _diaChiChiTietController.text,
          ghiChu: _ghiChuController.text.isEmpty ? null : _ghiChuController.text,
          viDo: _viDo,
          kinhDo: _kinhDo,
        );
        
        diaChiProvider.capNhatDiaChi(diaChiCapNhat);
      } else {
        // Thêm địa chỉ mới
        final diaChiMoi = DiaChi(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          tenDiaChi: _tenDiaChiController.text,
          diaChiChiTiet: _diaChiChiTietController.text,
          ghiChu: _ghiChuController.text.isEmpty ? null : _ghiChuController.text,
          viDo: _viDo,
          kinhDo: _kinhDo,
        );
        
        diaChiProvider.themDiaChi(diaChiMoi);
        diaChiProvider.chonDiaChi(diaChiMoi);
      }
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.diaChi != null ? 'Chỉnh sửa địa chỉ' : 'Thêm địa chỉ mới',
          style: const TextStyle(
            color: MauSac.trang,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _tenDiaChiController,
                      style: const TextStyle(color: MauSac.trang),
                      decoration: InputDecoration(
                        labelText: 'Tên địa chỉ (VD: Nhà, Công ty)',
                        labelStyle: const TextStyle(color: MauSac.xam),
                        prefixIcon: const Icon(Icons.bookmark, color: MauSac.xam),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: MauSac.xamDam),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: MauSac.kfcRed),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: MauSac.kfcRed),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: MauSac.kfcRed),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: MauSac.denNhat,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên địa chỉ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _diaChiChiTietController,
                            style: const TextStyle(color: MauSac.trang),
                            decoration: InputDecoration(
                              labelText: 'Địa chỉ chi tiết',
                              labelStyle: const TextStyle(color: MauSac.xam),
                              prefixIcon: const Icon(Icons.location_on, color: MauSac.xam),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: MauSac.xamDam),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: MauSac.kfcRed),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: MauSac.kfcRed),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: MauSac.kfcRed),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: MauSac.denNhat,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập địa chỉ chi tiết';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _dangTimKiemDiaChi ? null : _timKiemDiaChi,
                          icon: _dangTimKiemDiaChi
                              ? const CircularProgressIndicator(color: MauSac.kfcRed)
                              : const Icon(Icons.search, color: MauSac.kfcRed),
                          tooltip: 'Tìm kiếm địa chỉ',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ghiChuController,
                      style: const TextStyle(color: MauSac.trang),
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Ghi chú (tùy chọn)',
                        labelStyle: const TextStyle(color: MauSac.xam),
                        prefixIcon: const Icon(Icons.note, color: MauSac.xam),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: MauSac.xamDam),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: MauSac.kfcRed),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: MauSac.kfcRed),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: MauSac.kfcRed),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: MauSac.denNhat,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Vị trí địa chỉ',
                      style: TextStyle(
                        color: MauSac.trang,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: MauSac.xamDam),
                        color: MauSac.denNhat,
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: MauSac.kfcRed,
                                  size: 50,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Vị trí: ${_viDo.toStringAsFixed(6)}, ${_kinhDo.toStringAsFixed(6)}',
                                  style: const TextStyle(
                                    color: MauSac.trang,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Chức năng bản đồ không khả dụng',
                                  style: TextStyle(
                                    color: MauSac.xam,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: FloatingActionButton(
                              mini: true,
                              backgroundColor: MauSac.kfcRed,
                              onPressed: _dangTimViTri ? null : _layViTriHienTai,
                              child: _dangTimViTri
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(MauSac.trang),
                                    )
                                  : const Icon(Icons.my_location, color: MauSac.trang),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: MauSac.denNen,
                border: Border(
                  top: BorderSide(color: MauSac.xamDam, width: 0.5),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _luuDiaChi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MauSac.kfcRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.diaChi != null ? 'Cập nhật địa chỉ' : 'Lưu địa chỉ',
                    style: const TextStyle(
                      color: MauSac.trang,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
