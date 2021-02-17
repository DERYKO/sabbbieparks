import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:introduction_screen/introduction_screen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sabbieparks/api/api.dart';
import 'package:sabbieparks/page/home.dart';
import 'package:sabbieparks/shared/strings.dart';
import 'package:sabbieparks/widgets/bloc_provider.dart';

import 'home_bloc.dart';

class WelcomeBloc extends Bloc {
  List<PageViewModel> pages = [];
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Widget _buildImage(String url, [double height = 175.0]) {
    return Align(
      child: Image.asset(
        url,
        height: height,
      ),
      alignment: Alignment.center,
    );
  }

  void onDone() async{
    if (loginFormKey.currentState.validate()) {
      try{
        ProgressDialog pr= new ProgressDialog(context);
        pr.show();
       await api.updateProfile(titleController.text, firstNameController.text,
            lastNameController.text, emailController.text);
       pr.hide();
        popAndNavigate(page: HomePage(), bloc: HomeBloc());
      }catch(e){
        print(e.response);
        alert('Profile', 'Authentication error!!');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    buildPages();
  }

  buildPages() {
    pages = [
      PageViewModel(
          title: "Welcome to the SabbieParks",
          body:
              "Park the smart way with SabbieParks\nSwipe left to complete setting up your account.",
          image: _buildImage(
            "assets/images/logo-green.png",
          ),
          decoration: PageDecoration(
            pageColor: Colors.white70,
          )),
      PageViewModel(
          title: "",
          bodyWidget: Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
            padding: EdgeInsets.only(left: 38.0, right: 38.0, top: 30.0),
            child: Form(
              key: loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildImage(appIcon),
                  TextFormField(
                    controller: firstNameController,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    onFieldSubmitted: (value) {},
                    validator: (value) {
                      if (value.isEmpty)
                        return 'First name is required';
                      else
                        return null;
                    },
                    decoration: InputDecoration(
                      labelText: "First Name",
                      hintText: "Sabbie",
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: lastNameController,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    onFieldSubmitted: (value) {},
                    validator: (value) {
                      if (value.isEmpty)
                        return 'Last name is required';
                      else
                        return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Last Name",
                      hintText: "Karanja",
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    onFieldSubmitted: (value) {},
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "email address",
                    ),
                  )
                ],
              ),
            ),
          ),
          decoration: PageDecoration(
            pageColor: Colors.white70,
          ))
    ];
    notifyChanges();
  }
}
