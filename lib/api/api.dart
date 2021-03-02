import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sabbieparks/api/dio_api.dart';

class Api extends DioApi {
  Future login(String phone) {
    return dio.post("/login", data: {"phone_number": phone});
  }

  Future verifyCode(String phone, String code) {
    return dio.post('/code', data: {"phone_number": phone, "code": code});
  }

  Future createVehicle(int vehicle_type_id, String registration_no,
      String color, String model_type) {
    return dio.post('/vehicle', data: {
      "vehicle_type_id": vehicle_type_id,
      "registration_no": registration_no,
      "color": color,
      "model_type": model_type
    });
  }

  Future getVehicleTypes() {
    return dio.get('/vehicle-type');
  }

  Future getBookings(DateTime time) {
    return dio.get('/booking', queryParameters: {"date": time});
  }

  Future getParkingSpotDetail(int id) {
    return dio.get('/spot/$id');
  }

  Future loadWallet(int amount) {
    return dio.get('/recharge-account', queryParameters: {"amount": amount});
  }

  Future lipaNaMpesa(
      int user_vehicle_id, int client_id, int parking_spot_id, int amount) {
    return dio.get('/lipa-na-mpesa', queryParameters: {
      "user_vehicle_id": user_vehicle_id,
      "amount": amount,
      "client_id": client_id,
      "parking_spot_id": parking_spot_id
    });
  }

  Future lipaNaWallet(
      int user_vehicle_id, int client_id, int parking_spot_id, int amount) {
    return dio.get('/lipa-na-wallet', queryParameters: {
      "user_vehicle_id": user_vehicle_id,
      "amount": amount,
      "client_id": client_id,
      "parking_spot_id": parking_spot_id
    });
  }

  Future getUserVehicles() {
    return dio.get('/vehicle');
  }

  Future updateProfile(String title, String firstName, String lastName,
      [String email = '']) {
    return dio.post('/profile', data: {
      "title": title,
      "first_name": firstName,
      "last_name": lastName,
      "email": email
    });
  }

  Future updateProfileImage(
      profileImage, String title, String firstName, String lastName,
      [String email = '']) {
    return dio.post('/profile', data: {
      "profile": profileImage,
      "title": title,
      "first_name": firstName,
      "last_name": lastName,
      "email": email
    });
  }

  Future getUserProfile() {
    return dio.get('/profile');
  }

  Future getParkingSpots(LatLng latLng) {
    print('${latLng.latitude},${latLng.longitude}');

    return dio
        .get('/spot?latitude=${latLng.latitude}&longitude=${latLng.longitude}');
  }

  Future logout() {
    return dio.get('/logout');
  }

  Future getCardDetails() {
    return dio.get('/card');
  }

  Future saveCardDetails(String cardType, String cardNumber, String holderName,
      String cvsNumber, String expiryDate) {
    return dio.post('/card', data: {
      'card_type': cardType,
      'card_number': cardNumber,
      'holders_name': holderName,
      'cvs_number': cvsNumber,
      'expiry_date': expiryDate
    });
  }

  Future updateCardDetails(int id, String cardType, String cardNumber,
      String holderName, String cvsNumber, String expiryDate) {
    return dio.put('/card/$id', data: {
      'card_type': cardType,
      'card_number': cardNumber,
      'holders_name': holderName,
      'cvs_number': cvsNumber,
      'expiry_date': expiryDate
    });
  }

  Future getWalletBalance() {
    return dio.get('/wallet');
  }
}

var api = Api();
