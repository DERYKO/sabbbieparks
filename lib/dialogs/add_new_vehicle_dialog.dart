import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sabbieparks/models/VehicleType.dart';
import 'package:sabbieparks/shared/strings.dart';

Future showAddNewVehicle(context, {List<VehicleType> types}) async {
  return await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return _AddVehicle(
          types: types,
        );
      });
}

class _AddVehicle extends StatefulWidget {
  List<VehicleType> types = [];

  _AddVehicle({this.types});

  @override
  __AddVehicleState createState() => __AddVehicleState();
}

class __AddVehicleState extends State<_AddVehicle> {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  TextEditingController registrationNumberController = TextEditingController();
  TextEditingController modelTypeController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  VehicleType selected;

  createVehicle() {
    if (loginFormKey.currentState.validate()) {
      var data = {};

      Navigator.pop(context, {});
    } else {
      Fluttertoast.showToast(msg: "Fill all fields to proceed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: <Widget>[
          Form(
            key: loginFormKey,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new DropdownButton<VehicleType>(
                    value: selected,
                    isExpanded: true,
                    hint: new Text("Select a car category"),
                    items: widget.types.map((VehicleType type) {
                      return new DropdownMenuItem<VehicleType>(
                        value: type,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.network(
                                appUrl + type.icon,
                                height: 100,
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
                      setState(() {
                        selected = type;
                      });
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
            height: 10.0,
          ),
          ButtonTheme(
            minWidth: 200.0,
            height: 50.0,
            child: RaisedButton(
              color: Colors.green,
              onPressed: () {
                createVehicle();
              },
              child: Text(
                "Add Vehicle",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
