class DeliveryAddress {
  final String area;
  final String number;
  final String landMark;
  DeliveryAddress({
    required this.area,
    required this.number,
    required this.landMark,
  });

  String get formated =>"$number, $landMark, $area";

  DeliveryAddress copyWith({
    String? area,
    String? number,
    String? landMark,
  }) {
    return DeliveryAddress(
      area: area ?? this.area,
      number: number ?? this.number,
      landMark: landMark ?? this.landMark,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'area': area,
      'number': number,
      'landMark': landMark,
    };
  }

  factory DeliveryAddress.fromMap(Map<String, dynamic> map) {
    return DeliveryAddress(
      area: map['area'],
      number: map['number'],
      landMark: map['landMark'],
    );
  }
}
