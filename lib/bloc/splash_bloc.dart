import 'package:sabbieparks/bloc/home_bloc.dart';
import 'package:sabbieparks/bloc/login_bloc.dart';
import 'package:sabbieparks/page/home.dart';
import 'package:sabbieparks/page/login.dart';
import 'package:sabbieparks/tools/auth_manager.dart';
import 'package:sabbieparks/widgets/bloc_provider.dart';

class SplashBloc extends Bloc {
  @override
  Future<void> initState() async {
    super.initState();
    await Future.delayed(Duration(seconds: 3));
    this.checkFirstTimeSetup();
  }
  checkFirstTimeSetup() async {
    if (await authManager.isLoggedIn()) {
      await authManager.getUser();
      popAndNavigate(page: HomePage(), bloc: HomeBloc());
    } else {
      popAndNavigate(page: Login(), bloc: LoginBloc());
    }
  }
}