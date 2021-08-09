
import 'package:cloud_firestore/cloud_firestore.dart';

class MilkMan {
  final String id;
  final String name;
  final String mobile;
  final List<String> areas;

  MilkMan({
    required this.id,
    required this.name,
    required this.mobile,
    required this.areas,
  });
  
  
  

  MilkMan copyWith({
    String? id,
    String? name,
    String? mobile,
    List<String>? areas,
  }) {
    return MilkMan(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      areas: areas ?? this.areas,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'areas': areas,
    };
  }

  factory MilkMan.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return MilkMan(
      id: doc.id,
      name: map['name'],
      mobile: map['mobile'],
      areas: List<String>.from(map['areas']),
    );
  }

  factory MilkMan.empty() {
    return MilkMan(
      id: '',
      name: '',
      mobile: '',
      areas: [],
    );
  }
}
