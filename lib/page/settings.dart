import 'package:flutter/material.dart' hide Page;
import 'package:sabbieparks/bloc/settings_bloc.dart';
import 'package:sabbieparks/widgets/page.dart';


class Settings extends Page<SettingsBloc> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
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
          'My Settings',
          style: TextStyle(
              color: Colors.black, fontSize: 23.0, fontWeight: FontWeight.bold),
        )
      )
    );
  }
}
