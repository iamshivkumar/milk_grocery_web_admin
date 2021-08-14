import 'package:cloud_firestore/cloud_firestore.dart';

class MilkMan {
  final String id;
  final String name;
  final String mobile;
  final double walletAmount;
  final List<String> areas;
  final List<String> pendingAreas;
  final List<String> rejectedAreas;
  MilkMan({
    required this.id,
    required this.name,
    required this.mobile,
    required this.areas,
    required this.walletAmount,
    required this.pendingAreas,
    required this.rejectedAreas,
  });

  MilkMan copyWith({
    String? id,
    String? name,
    String? mobile,
    List<String>? areas,
    List<String>? pendingAreas,
    List<String>? rejectedAreas,
    double? walletAmount,
  }) {
    return MilkMan(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      areas: areas ?? this.areas,
      walletAmount: walletAmount ?? this.walletAmount,
      pendingAreas: pendingAreas ?? this.pendingAreas,
      rejectedAreas: rejectedAreas ?? this.rejectedAreas,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mobile': mobile,
      'areas': areas,
      'walletAmount': walletAmount,
      'areasRequests': pendingAreas,
      'rejectedAreas': rejectedAreas,
    };
  }

  factory MilkMan.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return MilkMan(
      id: doc.id,
      name: map['name'],
      mobile: map['mobile'],
      areas: List<String>.from(map['areas']),
      walletAmount: map['walletAmount'],
      pendingAreas: List<String>.from(map['pendingAreas']),
      rejectedAreas: List<String>.from(map['rejectedAreas']),
    );
  }

  factory MilkMan.empty() {
    return MilkMan(
      id: '',
      name: '',
      mobile: '',
      areas: [],
      walletAmount: 0,
      pendingAreas: [],
      rejectedAreas: [],
    );
  }
}
