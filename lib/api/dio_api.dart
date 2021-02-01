import 'package:dio/dio.dart';
import 'package:sabbieparks/shared/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioApi {
  SharedPreferences prefs;
  Dio dio;
  Dio dioVocServer;

  DioApi() {
    dio = Dio();
    dio.options.baseUrl = apiUrl;
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    dio.interceptors.add(InterceptorsWrapper(onRequest: _requestIntercept));
    dio.interceptors.add(InterceptorsWrapper(onResponse: _responseIntercept));
    dio.interceptors.add(InterceptorsWrapper(onError: _errorIntercept));
  }

  _requestIntercept(RequestOptions options) async {
    prefs = await SharedPreferences.getInstance();
    String loggedIn = prefs.getString('token');
    if (loggedIn != null) {
      options.headers.addAll({"Authorization": "Bearer $loggedIn"});
    }
    return options;
  }
  _responseIntercept(Response response) async {
    return response;
  }
  _errorIntercept(DioError error) async {
    return error;
  }
}
