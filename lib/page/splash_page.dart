import 'package:flutter/material.dart' hide Page;
import 'package:sabbieparks/bloc/splash_bloc.dart';
import 'package:sabbieparks/shared/strings.dart';
import 'package:sabbieparks/widgets/page.dart';
class SplashPage extends Page<SplashBloc> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        child: Center(
          child: Hero(
              tag: "logo",
              child: Image.asset(appIcon, height: 200.0, width: 200.0)),
        ),
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}