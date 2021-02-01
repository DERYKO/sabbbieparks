import 'package:dio/dio.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sabbieparks/api/api.dart';
import 'package:sabbieparks/bloc/home_bloc.dart';
import 'package:sabbieparks/bloc/welcome_page_bloc.dart';
import 'package:sabbieparks/page/home.dart';
import 'package:sabbieparks/page/welcome_page.dart';
import 'package:sabbieparks/tools/auth_manager.dart';
import 'package:sabbieparks/widgets/bloc_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationBloc extends Bloc {
  String code;

  @override
  void initState() {
    super.initState();
  }

  attemptVerification(String code, String phone) async {
    try {
      ProgressDialog pr= new ProgressDialog(context);
      pr.show();
      Response response = await api.verifyCode(phone, code);
      pr.dismiss();
      authManager.setToken(response.data['token']);
      if (response.data['user']['first_name'] == null) {
        popAndNavigate(page: WelcomePage(), bloc: WelcomeBloc());
      } else {
        popAndNavigate(page: HomePage(), bloc: HomeBloc());
      }
    } catch (e) {
      alert("Unsuccessful", 'We could not validate the code provided!');
    }

  }

  setCode(String code) {
    this.code = code;
  }
}
