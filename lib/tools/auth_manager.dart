import 'dart:async';

import 'package:dio/dio.dart';
import 'package:sabbieparks/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  SharedPreferences prefs;

  Future<bool> isLoggedIn() async {
    prefs = await SharedPreferences.getInstance();
    String loggedIn = prefs.getString('token');
    return loggedIn != null ? true : false;
  }
  logout() async {
    try{
      await api.logout();
      prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
    }catch(e){
      print(e);
    }
  }
  setUser(Response response) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('status', response.data['status']);
  }
  setToken(String token) async{
    prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }
}
var authManager = AuthManager();
