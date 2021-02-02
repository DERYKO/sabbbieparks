import 'package:flutter/material.dart' hide Page;
import 'package:sabbieparks/page/splash_page.dart';
import 'package:sabbieparks/shared/strings.dart';
import 'package:sabbieparks/utils/network_status.dart';

import 'bloc/splash_bloc.dart';
import 'widgets/bloc_provider.dart';
void main() {
  runApp(MyApp());
  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
          fontFamily: 'Nova',
          primaryColor: Colors.green,
          primaryColorLight: Colors.amberAccent,
          primaryColorDark: Colors.green),
      home: BlocProvider(
        child: SplashPage(),
        bloc: SplashBloc(),
      ),
    );
  }
}