import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:grocery_web_admin/core/models/offer.dart';

class Masterdata {
  final bool active;
  final List<Offer> offers;
  Masterdata({
    required this.active,
    required this.offers,
  });

  Masterdata copyWith({
    bool? active,
    List<Offer>? offers,
  }) {
    return Masterdata(
      active: active ?? this.active,
      offers: offers ?? this.offers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'active': active,
      'offers': offers.map((x) => x.toMap()).toList(),
    };
  }

  factory Masterdata.fromMap(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Masterdata(
      active: map['active'],
      offers: List<Offer>.from(map['offers']?.map((x) => Offer.fromMap(x))),
    );
  }
}
