import 'package:flutter/material.dart' hide Page;
import 'package:international_phone_input/international_phone_input.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sabbieparks/bloc/login_bloc.dart';
import 'package:sabbieparks/shared/strings.dart';
import 'package:sabbieparks/widgets/page.dart';

class Login extends Page<LoginBloc> {
  String phoneNumber;
  String phoneIsoCode;
  bool visible = false;
  String confirmedNumber = '';

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    phoneNumber = internationalizedPhoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<dynamic>(
        stream: bloc.stream,
        builder: (context, snapshot) {
          return Scaffold(
            body: SafeArea(
              child: ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height / 2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: const Radius.circular(40.0),
                                bottomRight: const Radius.circular(40.0)),
                            color: Colors.green,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 6.0)
                            ]),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width / 2),
                            child: Column(
                              children: <Widget>[
                                Image.asset(icon, height: 100.0, width: 100.0,color: Colors.white,),
                                SizedBox(height: 10.0),
                                Text(
                                  'I Park',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 35.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Find Your Parking.',
                                  style: TextStyle(
                                      fontSize: 35.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2)),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                  'Save time & money when reserving and locating parking spots.',
                                  style: TextStyle(
                                      fontSize: 22.0, color: Colors.black)),
                              SizedBox(height: 20.0),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Colors.white70,
                                elevation: 10,
                                margin: EdgeInsets.all(5.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      InternationalPhoneInput(
                                          hintText: '711536733',
                                          onPhoneNumberChange:
                                              onPhoneNumberChange,
                                          initialPhoneNumber: phoneNumber,
                                          initialSelection: phoneIsoCode,
                                          enabledCountries: ['+254', '+256']),
                                      IconButton(
                                        icon: Icon(Icons.forward, size: 32.0),
                                        onPressed: () {
                                          if (phoneNumber != null) {
                                            bloc.attemptLogin(phoneNumber);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              Text(
                                'By creating an account you agree to our Terms Of Service and Privacy Policy.',
                                style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black26),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
