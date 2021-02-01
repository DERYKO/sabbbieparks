class Card {
  Card(this.id, this.cardNumber, this.expiryDate, this.cardHolderName,
      this.cvvCode, this.isCvvFocused);

  int id;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  Card.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardNumber = json['card_number'];
    expiryDate = json['expiry_date'];
    cardHolderName = json['holders_name'];
    cvvCode = json['cvs_number'];
    isCvvFocused = false;
  }
}
