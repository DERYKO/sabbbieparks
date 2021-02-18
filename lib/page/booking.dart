import 'package:flutter/cupertino.dart' hide Page;
import 'package:flutter/rendering.dart';
import 'package:sabbieparks/bloc/booking_bloc.dart';
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 3 / 4,
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
                          height: 50.0,
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
                        IconButton(
                          padding: EdgeInsets.all(5.0),
                          icon: Image.asset(mpesa),
                          iconSize: 200,
                          onPressed: () {},
                        ),
                        Text(
                          'Pay ${bloc.spot.price.cost_price} Kes via Mpesa',
                          style: TextStyle(
                              fontSize: 23.0, fontWeight: FontWeight.w900),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          '&',
                          style: TextStyle(
                              fontSize: 23.0, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Book Parking ${bloc.spot.parking_spot_code}',
                          style: TextStyle(
                              fontSize: 23.0, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 40.0,
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
                              "Pay ${bloc.spot.price.cost_price} Kes",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
        });
  }
}
