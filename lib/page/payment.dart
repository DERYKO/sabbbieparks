import 'package:flutter/material.dart' hide Page;
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:sabbieparks/bloc/payment_bloc.dart';
import 'package:sabbieparks/widgets/page.dart';
import 'package:flutter_credit_card/credit_card_form.dart';

class PaymentPage extends Page<PaymentBloc> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<dynamic>(
        stream: bloc.stream,
        builder: (context, snapshot) {
          return bloc.isLoading
              ? Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[new CircularProgressIndicator()],
                  ),
                )
              : Scaffold(
                  appBar: AppBar(
                    elevation: 0.0,
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.green,
                        size: 32.0,
                      ),
                    ),
                    title: Text(
                      'Add Payment Method',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  body: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.0),
                    child: Column(
                      children: <Widget>[
                        CreditCardWidget(
                          cardNumber:
                              bloc.card != null ? bloc.card.cardNumber : '',
                          expiryDate:
                              bloc.card != null ? bloc.card.expiryDate : '',
                          cardHolderName:
                              bloc.card != null ? bloc.card.cardHolderName : '',
                          cvvCode: bloc.card != null ? bloc.card.cvvCode : '',
                          showBackView: bloc.card != null
                              ? bloc.card.isCvvFocused
                              : false,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.credit_card,
                              size: 32.0,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              'Update/Add Card Details',
                              style: TextStyle(
                                  fontSize: 23.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: CreditCardForm(
                              onCreditCardModelChange:
                                  bloc.onCreditCardModelChange,
                            ),
                          ),
                        ),
                        ButtonTheme(
                          minWidth: 200.0,
                          height: 50.0,
                          child: RaisedButton(
                            color: Colors.green,
                            onPressed: () {
                              bloc.saveCardDetails();
                            },
                            child: Text(
                              "Save Card Details",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
        });
  }
}
