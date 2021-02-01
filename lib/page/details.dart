import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sabbieparks/bloc/detail.dart';
import 'package:sabbieparks/shared/strings.dart';
import 'package:sabbieparks/widgets/page.dart';

class DetailPage extends Page<DetailBloc> {

  Widget _buildIcon(int index) {
    return Container(
      height: 110.0,
      width: 100.0,
      decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: <Widget>[
          Image.network(
            appUrl + bloc.spot.feature[index].security.icon,
            width: 100.0,
            height: 100.0,
            fit: BoxFit.fill,
          ),
          Text(bloc.spot.feature[index].security.name,style: TextStyle(
            fontSize: 10.0
          ),)
        ],
      ),
    );
  }
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
                      'Parking Spot Detail',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  body: ListView(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height / 4,
                        decoration: BoxDecoration(color: Colors.white),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height / 4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: new Radius.circular(20.0),
                                      bottomRight: new Radius.circular(20.0)),
                                  color: Colors.grey),
                              child: GoogleMap(
                                polylines: bloc.polyLines,
                                mapType: MapType.normal,
                                markers: bloc.markers,
                                initialCameraPosition: CameraPosition(
                                  target: bloc.latLng,
                                  zoom: 14.4746,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 4,
                        decoration: BoxDecoration(color: Colors.white),
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('${bloc.spot.client.name} - ${bloc.spot.parking_spot_code}',
                                            style: TextStyle(
                                                fontSize: 27.0,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(bloc.spot.level3.address,
                                            style: TextStyle(
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.w300)),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(bloc.time + '/' +bloc.distance,
                                            style: TextStyle(
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.w300)),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'KES ${bloc.spot.price.cost_price}',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 27.0,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Text(
                                  '${bloc.spot.land_mark}'
                                ),
                                SizedBox(height: 10,),
                                ButtonTheme(
                                  minWidth: 200.0,
                                  height: 50.0,
                                  child: RaisedButton(
                                    color: Colors.green,
                                    onPressed: () {
                                      bloc.toBooking();
                                    },
                                    child: Text(
                                      "Book this parking spot",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0),
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ),
                      Text('Parking Features',style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold),),
                      SizedBox(height: 5.0,),
                      bloc.spot.feature.length > 0 ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: bloc.spot.feature
                            .asMap()
                            .entries
                            .map((MapEntry map) => _buildIcon(map.key))
                            .toList(),
                      ) : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('No features specified.',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),)
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          border: Border.all(color: Colors.grey,width: 2.0,style: BorderStyle.solid)
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height/3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Icon(
                                Icons.image,size: 32.0,
                              ),
                            ),
                            Text('No Images')
                          ],
                        ),
                      )
                    ],
                  ));
        });
  }
}
