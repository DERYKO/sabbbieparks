import 'package:flutter/material.dart';
import 'package:sabbieparks/api/api.dart';
import 'package:sabbieparks/models/VehicleType.dart';
import 'package:sabbieparks/models/vehicle.dart';
import 'package:sabbieparks/shared/strings.dart';
import 'package:sabbieparks/widgets/bloc_provider.dart';

class VehicleBloc extends Bloc {
  bool isLoading = false;
  List<Vehicle> vehicles = [];
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  TextEditingController registrationNumberController = TextEditingController();
  TextEditingController modelTypeController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  List<VehicleType> types = [];
  VehicleType selected;

  @override
  void initState() {
    super.initState();
    getUserVehicles();
    getVehicleTypes();
  }

  getUserVehicles() async {
    try {
      showLoader();
      var response = await api.getUserVehicles();
      for (var i = 0; i < response.data.length; i++) {
        vehicles.add(Vehicle.fromJson(response.data[i]));
      }
      showLoader(false);
    } catch (e) {
      print(e);
    }
  }

  showLoader([bool loading = true]) {
    isLoading = loading;
    notifyChanges();
  }

  addVehicle() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: MediaQuery.of(context).size.height/2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: loginFormKey,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 3 / 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new DropdownButton<VehicleType>(
                              value: selected,
                              isExpanded: true,
                              hint: new Text("Select a car category"),
                              items: types.map((VehicleType type) {
                                return new DropdownMenuItem<VehicleType>(
                                  value: type,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: Image.network(
                                          appUrl + type.icon,
                                          height: 80,
                                        ),
                                      ),
                                      Text(
                                        "${type.name}",
                                        style: TextStyle(fontSize: 20.0),
                                      )
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (VehicleType type) {
                                selected = type;
                              },
                            ),
                            TextFormField(
                              controller: registrationNumberController,
                              keyboardType: TextInputType.emailAddress,
                              autofocus: true,
                              onFieldSubmitted: (value) {},
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Registration number is required';
                                else
                                  return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Registration Number",
                                hintText: "KAZ 342T",
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: modelTypeController,
                              keyboardType: TextInputType.emailAddress,
                              autofocus: true,
                              onFieldSubmitted: (value) {},
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Model type is required';
                                else
                                  return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Model",
                                hintText: "Isuzu",
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: colorController,
                              keyboardType: TextInputType.emailAddress,
                              autofocus: true,
                              onFieldSubmitted: (value) {},
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Color is required';
                                else
                                  return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Color",
                                hintText: "Black",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () {
                          createVehicle();
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  getVehicleTypes() async {
    try {
      showLoader();
      var response = await api.getVehicleTypes();
      for (var i = 0; i < response.data.length; i++) {
        types.add(VehicleType.fromJson(response.data[i]));
      }
      showLoader(false);
    } catch (e) {
      showLoader(false);
    }
  }
  createVehicle() async {
    if (loginFormKey.currentState.validate()) {
      try {
        showLoader();
        var response = await api.createVehicle(
            selected.id, registrationNumberController.text,
            colorController.text, modelTypeController.text);
        vehicles = [];
        Navigator.of(context, rootNavigator: true).pop('dialog');
        loginFormKey.currentState?.reset();
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
}
