import 'package:flutter/material.dart' hide Page;
import 'package:sabbieparks/api/api.dart';
import 'package:sabbieparks/widgets/bloc_provider.dart';

class WalletBloc extends Bloc {
  bool isLoading = false;
  int balance;
  String date;
  TextEditingController amountController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getWalletBalance();
  }

  getWalletBalance() async {
    try {
      showLoader();
      var response = await api.getWalletBalance();
      balance = response.data['balance'];
      date = response.data['created_at'];
      showLoader(false);
    } catch (e) {
      showLoader(false);
      print(e);
    }
  }

  loadWallet() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: MediaQuery.of(context).size.height/2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: loginFormKey,
                      child: TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        onFieldSubmitted: (value) {},
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Amount is required';
                          else
                            return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Amount",
                          hintText: "10",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () {
                          if (loginFormKey.currentState.validate()) {
                            this.rechargeAccount();
                          }
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  rechargeAccount() async {
    try {
      await api.loadWallet(int.parse(amountController.text));
      Navigator.of(context, rootNavigator: true).pop('dialog');
      loginFormKey.currentState?.reset();
    } catch (e) {
      alert("error", "error");
    }
  }

  showLoader([bool loading = true]) {
    isLoading = loading;
    notifyChanges();
  }
}
