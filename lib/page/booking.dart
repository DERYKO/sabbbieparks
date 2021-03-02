import 'package:flutter/cupertino.dart' hide Page;
import 'package:flutter/rendering.dart';
import 'package:sabbieparks/bloc/booking_bloc.dart';
import 'package:sabbieparks/helpers/wallet_manager.dart';
import 'package:sabbieparks/models/VehicleType.dart';
import 'package:sabbieparks/models/vehicle.dart';
import 'package:sabbieparks/shared/strings.dart';
import 'package:sabbieparks/widgets/page.dart';

import '../widgets/page.dart';
import 'package:flutter/material.dart' hide Page;

class BookingPage extends Page<BookingBloc> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<dynamic>(
        stream: bloc.stream,
        builder: (context, snapshot) {
          return bloc.isLoading
              ? Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[new CircularProgressIndicator()],
                  ),
                )
              : Scaffold(
                  appBar: AppBar(
                    elevation: 0.0,
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.green,
                        size: 32.0,
                      ),
                    ),
                    title: Text(
                      'Booking',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  body: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Form(
                        key: bloc.bookingFormKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Radio(
                                        value: "booking",
                                        onChanged: (value) {
                                          bloc.onRadioChanged(newValue: value);
                                        },
                                        groupValue: bloc.radioValue,
                                      ),
                                      Text("Book")
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                        value: "reserved",
                                        onChanged: (value) {
                                          bloc.onRadioChanged(newValue: value);
                                        },
                                        groupValue: bloc.radioValue,
                                      ),
                                      Text("Reserve")
                                    ],
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: bloc.radioValue == "reserved",
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: bloc.selectDate,
                                      child: AbsorbPointer(
                                        child: TextFormField(
                                          controller:
                                              bloc.reserveDateController,
                                          validator: (value) {
                                            if (value.isEmpty &&
                                                bloc.radioValue == "reserved")
                                              return 'Reservation date is required';
                                            else
                                              return null;
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Select Date",
                                            hintText: "Reservation date",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: new DropdownButton<Vehicle>(
                                  value: bloc.userVehicle,
                                  isExpanded: true,
                                  hint: new Text("Select a vehicle"),
                                  items: bloc.vehicles.map((Vehicle vehicle) {
                                    return new DropdownMenuItem<Vehicle>(
                                      value: vehicle,
                                      child: new Text(
                                          "${vehicle.vehicleType.name} - ${vehicle.model_type} - ${vehicle.registration_no}"),
                                    );
                                  }).toList(),
                                  onChanged: (Vehicle vehicle) {
                                    bloc.selectVehicle(vehicle: vehicle);
                                  },
                                ),
                              ),
                              ButtonTheme(
                                minWidth: 200.0,
                                height: 30.0,
                                child: RaisedButton(
                                  color: Colors.green,
                                  onPressed: bloc.addVehicle,
                                  child: Text(
                                    "Add Vehicle",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                'Want to book parking spot ${bloc.spot.parking_spot_code} ?',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              ButtonTheme(
                                minWidth: 200.0,
                                height: 50.0,
                                child: RaisedButton(
                                  color: Colors.green,
                                  onPressed: () {
                                    bloc.lipaNaMpesa();
                                  },
                                  child: Text(
                                    "Pay ${bloc.spot.price.cost_price} Kes with Mpesa",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              bloc.spot.price.cost_price <=
                                      walletManager?.balance
                                  ? Column(
                                      children: [
                                        Text(
                                          "OR",
                                          style: TextStyle(
                                              color: Colors.black26,
                                              fontSize: 20.0),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ButtonTheme(
                                          minWidth: 200.0,
                                          height: 50.0,
                                          child: RaisedButton(
                                            color: Colors.brown,
                                            onPressed: () {
                                              bloc.lipaNaWallet();
                                            },
                                            child: Text(
                                              "Deduct ${bloc.spot.price.cost_price} Kes from wallet",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
        });
  }
}
