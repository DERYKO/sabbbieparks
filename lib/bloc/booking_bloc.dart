import 'dart:convert';

import 'package:flutter/material.dart' hide Page;
import 'package:sabbieparks/api/api.dart';
import 'package:sabbieparks/dialogs/add_new_vehicle_dialog.dart';
import 'package:sabbieparks/models/VehicleType.dart';
import 'package:sabbieparks/models/spot.dart';
import 'package:sabbieparks/models/vehicle.dart';
import 'package:sabbieparks/widgets/bloc_provider.dart';

class BookingBloc extends Bloc {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  TextEditingController registrationNumberController = TextEditingController();
  TextEditingController modelTypeController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  int spot_id;
  Spot spot;
  bool isLoading = false;
  List<Vehicle> vehicles = [];
  List<VehicleType> types = [];
  VehicleType selected;
  Vehicle userVehicle;

  @override
  Future<void> initState() async {
    super.initState();
    await getParkingDetails();
    await getVehicles();
    await getVehicleTypes();
    showLoader(false);
  }

  BookingBloc(this.spot_id);
  createVehicle() async {
    if (loginFormKey.currentState.validate()) {
      try {
        showLoader();
        var response = await api.createVehicle(
            selected.id,
            registrationNumberController.text,
            colorController.text,
            modelTypeController.text);
        for (var i = 0; i < response.data.length; i++) {
          vehicles.add(Vehicle.fromJson(response.data[i]));
        }
        showLoader(false);
      } catch (e) {
        print(e);
        showLoader(false);
      }
    }
  }

  getVehicleTypes() async {
    try {
      showLoader();
      var response = await api.getVehicleTypes();
      for (var i = 0; i < response.data.length; i++) {
        types.add(VehicleType.fromJson(response.data[i]));
      }
    } catch (e) {
      showLoader(false);
    }
  }

  getVehicles() async {
    try {
      showLoader();
      var response = await api.getUserVehicles();
      for (var i = 0; i < response.data.length; i++) {
        vehicles.add(Vehicle.fromJson(response.data[i]));
      }
    } catch (e) {
      showLoader(false);
    }
  }

  getParkingDetails() async {
    try {
      showLoader();
      var response = await api.getParkingSpotDetail(spot_id);
      spot = Spot.fromJson(response.data);
    } catch (e) {
      showLoader(false);
    }
  }

  showLoader([bool loading = true]) {
    isLoading = loading;
    notifyChanges();
  }

  lipaNaMpesa() async {
    if (userVehicle != null) {
      showLoader();
      try {
        await api.lipaNaMpesa(
            userVehicle.id, spot.client.id, spot.id, spot.price.cost_price);
        alert('Transaction',
            'Transaction is being processed .. you will receive a notification on completion');
        showLoader(false);
      } catch (e) {
        showLoader(false);
      }
    } else {
      alert('Error', 'Please specify a vehicle');
    }
  }

  addVehicle() async {
    var data = await showAddNewVehicle(context, types: types);
    if (data != null) {
      try {
        showLoader();
        vehicles = [];
        selected = null;
        var response = await api.createVehicle(data["vehicleType"],
            data["regNumber"], data["color"], data["model"]);
        for (var i = 0; i < response.data.length; i++) {
          vehicles.add(Vehicle.fromJson(response.data[i]));
        }
        notifyChanges();
        showLoader(false);
      } catch (e) {
        print(e);
        showLoader(false);
      }
    }
    print(data);
  }
}
