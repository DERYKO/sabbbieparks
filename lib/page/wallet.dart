import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sabbieparks/bloc/wallet_bloc.dart';
import 'package:sabbieparks/shared/strings.dart';
import 'package:sabbieparks/widgets/page.dart';

class WalletPage extends Page<WalletBloc> {
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
              : new Scaffold(
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
                      'My Wallet',
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
                        Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.white70,
                            elevation: 10,
                            margin: EdgeInsets.all(5.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 8,
                              decoration: BoxDecoration(),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          ' Balance:  ${bloc.balance} Ksh',
                                          style: TextStyle(
                                              fontSize: 23.0,
                                              fontWeight: FontWeight.w700),
                                        )
                                      ],
                                    ),
                                    Text(
                                      'Recharged on ${bloc.date}',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.blueGrey),
                                    )
                                  ],
                                ),
                              ),
                            )),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.white70,
                          elevation: 10,
                          margin: EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white70),
                            height: MediaQuery.of(context).size.height * 4 / 8,
                            child: Container(
                              padding: EdgeInsets.all(9.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Recharge Account',
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Card(
                                          elevation: 5.0,
                                          child: IconButton(
                                            padding: EdgeInsets.all(5.0),
                                            icon: Image.asset(mpesa),
                                            iconSize: 150,
                                            onPressed: () {
                                              bloc.loadWallet();
                                            },
                                          )),
                                      Card(
                                          elevation: 5.0,
                                          child: IconButton(
                                            icon: Image.asset(creditCard),
                                            iconSize: 150,
                                            onPressed: () {},
                                          )),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Card(
                                          elevation: 5.0,
                                          child: IconButton(
                                            icon: Image.asset(airtel),
                                            iconSize: 150,
                                            onPressed: () {},
                                          )),
                                    ],
                                  )
                                ],
                              ),
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
