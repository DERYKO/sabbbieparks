import 'package:flutter/material.dart';
import 'package:sabbieparks/bloc/vehicle_bloc.dart';
import 'package:sabbieparks/models/vehicle.dart';
import 'package:sabbieparks/shared/strings.dart';
import 'package:sabbieparks/widgets/page.dart';

class VehiclePage extends Page<VehicleBloc> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
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
          'My Vehicles',
          style: TextStyle(
              color: Colors.black, fontSize: 23.0, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: Colors.green,
              size: 32.0,
            ),
            onPressed: () {
              bloc.addVehicle();
            },
          )
        ],
      ),
      body: StreamBuilder<dynamic>(
          stream: bloc.stream,
          builder: (context, snapshot) {
            if (bloc.isLoading) {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[new CircularProgressIndicator()],
                ),
              );
            }
            if (bloc.vehicles.isEmpty) {
              return Center(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 50),
                    Icon(
                      Icons.mood_bad,
                      size: 40.0,
                    ),
                    const SizedBox(height: 16),
                    Text('You have not added any vehicles yet'),
                    const SizedBox(height: 16),
                    InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.refresh),
                          Text(' Refresh'),
                        ],
                      ),
                      onTap: () {
                        bloc.getUserVehicles();
                      },
                    ),
                  ],
                ),
              );
            }
            return Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return _buildVehilceCard(context, index);
                      },
                      itemCount: bloc.vehicles.length,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
  Widget _buildVehilceCard(BuildContext context, int index) {
    Vehicle vehicle = bloc.vehicles[index];
    return InkWell(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        height: 75,
        decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.blueGrey),
            ),
            color: Colors.white),
        child: Row(
          children: <Widget>[
            Container(
              width: (MediaQuery
                  .of(context)
                  .size
                  .width) * 0.20,
              child: SizedBox(
                height: 50,
                width: 50,
                child: Image.network(
                  appUrl + vehicle.vehicleType.icon,
                  height: 100,
                ),
              ),
            ),
            Container(
              width: (MediaQuery
                  .of(context)
                  .size
                  .width) * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10.0),
                  Text(
                    vehicle.model_type,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    vehicle.registration_no,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black45,
                    ),
                  ),
                  Text(
                    vehicle.vehicleType.name,
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: (MediaQuery.of(context).size.width) * 0.1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 5.0),
                  Text(
                    vehicle.color,
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                  IconButton(
                    onPressed: (){

                    },
                    icon: Icon(Icons.delete),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
