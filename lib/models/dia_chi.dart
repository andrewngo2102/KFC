class DiaChi {
  final String id;
  final String tenDiaChi;
  final String diaChiChiTiet;
  final String? ghiChu;
  final double? viDo;
  final double? kinhDo;

  DiaChi({
    required this.id,
    required this.tenDiaChi,
    required this.diaChiChiTiet,
    this.ghiChu,
    this.viDo,
    this.kinhDo,
  });

  DiaChi copyWith({
    String? id,
    String? tenDiaChi,
    String? diaChiChiTiet,
    String? ghiChu,
    double? viDo,
    double? kinhDo,
  }) {
    return DiaChi(
      id: id ?? this.id,
      tenDiaChi: tenDiaChi ?? this.tenDiaChi,
      diaChiChiTiet: diaChiChiTiet ?? this.diaChiChiTiet,
      ghiChu: ghiChu ?? this.ghiChu,
      viDo: viDo ?? this.viDo,
      kinhDo: kinhDo ?? this.kinhDo,
    );
  }
}
