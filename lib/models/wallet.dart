class Wallet{
  int id;
  int balance;
  String date;

  Wallet(this.id, this.balance, this.date);
  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    balance = json['balance'];
    date = json['created_at'];
  }
}