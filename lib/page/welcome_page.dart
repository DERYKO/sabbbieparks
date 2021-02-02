import 'package:flutter/material.dart' hide Page;
import 'package:introduction_screen/introduction_screen.dart';
import 'package:sabbieparks/bloc/welcome_page_bloc.dart';
import 'package:sabbieparks/widgets/page.dart';

class WelcomePage extends Page<WelcomeBloc> {
  @override
  Widget build(BuildContext context) {
//    bloc.buildPages();
    super.build(context);
    return StreamBuilder<dynamic>(
        stream: bloc.stream,
        builder: (context, snapshot) {
          return IntroductionScreen(
            pages: bloc.pages,
            onDone: bloc.onDone,
            onSkip: bloc.onDone,
            showSkipButton: true,
            skipFlex: 0,
            nextFlex: 0,
            skip: const Text('Skip'),
            next: const Icon(Icons.arrow_forward),
            done: const Text(
              'Complete',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          );
        });
  }
}