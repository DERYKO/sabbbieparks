import 'package:flutter/material.dart' hide Page;

import 'bloc_provider.dart';

abstract class Page<T extends Bloc> extends StatelessWidget {
  T bloc;
  Page({Key key}) : super(key: key);
  @protected
  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<T>(context);
  }
}