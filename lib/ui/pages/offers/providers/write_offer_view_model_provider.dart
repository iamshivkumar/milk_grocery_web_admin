import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/models/offer.dart';
import 'package:grocery_web_admin/core/models/write_offer_option.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';

final writeOfferViewModelProvider =
    ChangeNotifierProvider.family<WriteOfferViewModel, WriteOfferParam>(
  (ref, param) => WriteOfferViewModel(
    offers: param.offers,
    prevOffer: param.prevOffer,
    ref: ref,
  ),
);

class WriteOfferViewModel extends ChangeNotifier {
  final Offer? prevOffer;
  final List<Offer> offers;
  final ProviderReference ref;

  WriteOfferViewModel({
    this.prevOffer,
    required this.offers,
    required this.ref,
  });

  Offer? _option;
  Offer get offer => _option??Offer.empty().copyWith(
    amount: prevOffer?.amount,
    percentage: prevOffer?.percentage,
  );
  set offer(Offer option) {
    _option = option;
    notifyListeners();
  }


  Repository get repository => ref.read(repositoryProvider);

  void write() {
    if (prevOffer != null) {
      offers.remove(prevOffer);
    }
    offers.add(offer);
    ref.read(repositoryProvider).writeOffer(offers);
  }
}
