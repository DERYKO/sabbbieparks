import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sabbieparks/api/api.dart';
import 'package:sabbieparks/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  SharedPreferences prefs;
  User user;

  Future<bool> isLoggedIn() async {
    prefs = await SharedPreferences.getInstance();
    String loggedIn = prefs.getString('token');
    return loggedIn != null ? true : false;
  }
  getUser() async {
    prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('user');
    user = new User.fromJson(json.decode(user));
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
