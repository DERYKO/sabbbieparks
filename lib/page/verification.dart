import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sabbieparks/api/api.dart';
import 'package:sabbieparks/bloc/verification_bloc.dart';
import 'package:sabbieparks/shared/strings.dart';
import 'package:sabbieparks/widgets/page.dart';

class Verification extends Page<VerificationBloc> {
  Response response;

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
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 20.0),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back,
                                size: 32.0,
                              ),
                            )
                          ],
                        ),
                      )
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('Phone Verification.',
                                  style: TextStyle(
                                      fontSize: 35.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2)),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text('Enter your otp code below.',
                                  style: TextStyle(
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black)),
                              SizedBox(height: 20.0),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: PinEntryTextField(
                                      onSubmit: (String pin) {
                                        String code =
                                            this.response.data['user']['code'];
                                        bloc.setCode(code);
                                        if (bloc.code == pin) {
                                          bloc.attemptVerification(
                                              code,
                                              this.response.data['user']
                                                  ['phone_number']);
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text("Pin"),
                                                  content: Text(
                                                      'Invalid code provided'),
                                                );
                                              }); //en
                                        }
                                      }, // end onSubmit
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              FlatButton(
                                color: Colors.green,
                                textColor: Colors.white,
                                disabledColor: Colors.grey,
                                disabledTextColor: Colors.black,
                                padding: EdgeInsets.all(8.0),
                                splashColor: Colors.blueAccent,
                                onPressed: () async {
                                  Response response = await api.login(this
                                      .response
                                      .data['user']['phone_number']);
                                  Fluttertoast.showToast(
                                      msg: 'Code has been sent.',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  String code = response.data['user']['code'];
                                  bloc.setCode(code);
                                },
                                child: Text(
                                  "Resend OTP Code",
                                  style: TextStyle(fontSize: 20.0),
                                ),
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

  Verification(this.response);
}
