import 'package:sabbieparks/tools/manager.dart';

import '../api/api.dart';

class WalletManager extends Manager {
  int balance = 0;
  String date;
  bool _loadingBalance = false;

  bool get loadingBalance => _loadingBalance;

  set loadingBalance(bool value) {
    _loadingBalance = value;
    notifyChanges();
  }

  getWalletBalance() async {
    try {
      loadingBalance = true;
      var response = await api.getWalletBalance();
      balance = response.data['balance'];
      date = response.data['created_at'];
      loadingBalance = false;
      notifyChanges();
    } catch (e) {
      loadingBalance = false;
      print(e);
    }
  }
}

var walletManager = WalletManager();
