import 'package:equatable/equatable.dart';
import 'package:grocery_web_admin/core/models/offer.dart';

class WriteOfferParam extends Equatable {
  final Offer? prevOffer;
  final List<Offer> offers;

  WriteOfferParam({this.prevOffer, required this.offers});

  @override
  List<Object?> get props => [prevOffer, offers];
}
