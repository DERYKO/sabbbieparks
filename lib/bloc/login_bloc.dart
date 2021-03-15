import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sabbieparks/api/api.dart';
import 'package:sabbieparks/bloc/verification_bloc.dart';
import 'package:sabbieparks/page/verification.dart';
import 'package:sabbieparks/tools/auth_manager.dart';
import 'package:sabbieparks/widgets/bloc_provider.dart';

class LoginBloc extends Bloc {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
  }

  attemptLogin(String phone_number) async {
    try {
      ProgressDialog pr = new ProgressDialog(context);
      pr.show();
      Response response = await api.login(phone_number);
      pr.dismiss();
      print(response.data['user']);
      _fcm.subscribeToTopic('user${response.data['user']['id']}');
      await authManager.setUser(response);
      navigate(page: Verification(response), bloc: VerificationBloc());
    } catch (e) {
      print(e.response);
    }
  }
}
