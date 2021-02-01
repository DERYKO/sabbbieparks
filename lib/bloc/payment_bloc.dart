import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:sabbieparks/api/api.dart';
import 'package:sabbieparks/models/card.dart';
import 'package:sabbieparks/widgets/bloc_provider.dart';

class PaymentBloc extends Bloc {
  Card card;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserCardDetails();
  }

  saveCardDetails() async {
    if (cardNumber != '' &&
        expiryDate != '' &&
        cardHolderName != '' &&
        cvvCode != '') {
      try {
        showLoader();
        if (card == null) {
          var response = await api.saveCardDetails(
              'Master Card', cardNumber, cardHolderName, cvvCode, expiryDate);
          card = Card.fromJson(response.data);
        } else {
          var response1 = await api.updateCardDetails(card.id, 'Master Card',
              cardNumber, cardHolderName, cvvCode, expiryDate);
          card = Card.fromJson(response1.data);
        }
        showLoader(false);
      } catch (e) {
        print(e);
      }
    } else {
      alert('Card', 'Invalid card details!!');
    }
  }

  showLoader([bool loading = true]) {
    isLoading = loading;
    notifyChanges();
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    cardNumber = creditCardModel.cardNumber;
    expiryDate = creditCardModel.expiryDate;
    cardHolderName = creditCardModel.cardHolderName;
    cvvCode = creditCardModel.cvvCode;
    notifyChanges();
  }

  getUserCardDetails() async {
    try {
      showLoader();
      var response = await api.getCardDetails();
      card = Card.fromJson(response.data);
      showLoader(false);
    } catch (e) {
      showLoader(false);
      print(e);
    }
  }
}
