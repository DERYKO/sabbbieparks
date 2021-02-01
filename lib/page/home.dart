import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sabbieparks/bloc/home_bloc.dart';
import 'package:sabbieparks/shared/strings.dart';
import 'package:sabbieparks/widgets/page.dart';
import 'package:search_map_place/search_map_place.dart';

class HomePage extends Page<HomeBloc> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<dynamic>(
        stream: bloc.stream,
        // ignore: missing_return
        builder: (context, snapshot) {
          if (bloc.isLoading) {
            return Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[new CircularProgressIndicator()],
              ),
            );
          } else {
            if (bloc.hasError) {
              return Center(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 50),
                    Icon(
                      Icons.network_check,
                      size: 40.0,
                    ),
                    const SizedBox(height: 16),
                    Text('Check your internet connection'),
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
                        bloc.initState();
                      },
                    ),
                  ],
                ),
              );
            } else {
              return new Scaffold(
                key: bloc.drawerKey,
                drawer: Drawer(
                  child: ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        child: Align(
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => bloc.toProfile(),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40.0),
                                  child: bloc.user != null &&
                                          bloc.user.avatar != null
                                      ? Image.network(
                                          appUrl + bloc.user.avatar,
                                          height: 100,
                                        )
                                      : Image.asset(
                                          profile,
                                          height: 100,
                                        ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                bloc.user.phoneNumber,
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.notifications_active,
                          size: 35.0,
                          color: Colors.green,
                        ),
                        title: Text(
                          'Notifications (${bloc.notificationCount})',
                          style: TextStyle(fontFamily: 'Nova', fontSize: 20.0),
                        ),
                        onTap: () {
                          bloc.toNotifications();
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.perm_identity,
                          size: 35.0,
                          color: Colors.green,
                        ),
                        title: Text('Profile',
                            style:
                                TextStyle(fontFamily: 'Nova', fontSize: 20.0)),
                        onTap: () {
                          bloc.toProfile();
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.monetization_on,
                          size: 35.0,
                          color: Colors.green,
                        ),
                        trailing: Text(
                          '${bloc.wallet.balance} Kes',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        title: Text('Wallet',
                            style:
                                TextStyle(fontFamily: 'Nova', fontSize: 20.0)),
                        onTap: () {
                          bloc.toWallets();
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.directions_car,
                          size: 35.0,
                          color: Colors.green,
                        ),
                        title: Text('My Vehicles',
                            style:
                                TextStyle(fontFamily: 'Nova', fontSize: 20.0)),
                        onTap: () {
                          bloc.toVehicles();
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.bookmark,
                          size: 35.0,
                          color: Colors.green,
                        ),
                        title: Text('Bookings',
                            style:
                                TextStyle(fontFamily: 'Nova', fontSize: 20.0)),
                        onTap: () {
                          bloc.toListBookings();
                        },
                      ),
                      ListTile(
                        leading:
                            Icon(Icons.store, size: 35.0, color: Colors.green),
                        title: Text('Reservations',
                            style:
                                TextStyle(fontFamily: 'Nova', fontSize: 20.0)),
                        onTap: () {
                          bloc.toReservations();
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.credit_card,
                          size: 35.0,
                          color: Colors.green,
                        ),
                        title: Text('Payments',
                            style:
                                TextStyle(fontFamily: 'Nova', fontSize: 20.0)),
                        onTap: () {
                          bloc.toPayments();
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.label_outline,
                          size: 35.0,
                          color: Colors.green,
                        ),
                        title: Text('Logout',
                            style:
                                TextStyle(fontFamily: 'Nova', fontSize: 20.0)),
                        onTap: () {
                          bloc.logout();
                        },
                      )
                    ],
                  ),
                ),
                body: Stack(
                  children: <Widget>[
                    GoogleMap(
                      polylines: bloc.polyLines,
                      markers: bloc.markers,
                      mapType: MapType.normal,
                      onCameraMove: bloc.onCameraMove,
                      initialCameraPosition: CameraPosition(
                        target: bloc.latLng,
                        zoom: 11.0,
                      ),

                      ///onCameraMove: bloc.onCameraMove,
                      onMapCreated: bloc.onMapCreated,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 40.0, horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.dehaze,
                                    size: 35.0, color: Colors.green),
                                onPressed: () {
                                  bloc.drawerKey.currentState.openDrawer();
                                },
                              ),
                              SizedBox(width: 20.0),
                              Image.asset(
                                smurf,
                                height: 40,
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                'How are you, ${bloc.user.firstName} ${bloc.user.lastName} ?',
                                style: TextStyle(
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          SearchMapPlaceWidget(
                            apiKey: 'AIzaSyAwB-YqrFP1K_TdPNAJ_DapYcqC4v6FM58',
                            language: 'en',
                            location: bloc.latLng,
                            radius: 30000,
                            onSelected: (Place place) async {
                              final geolocation = await place.geolocation;
                              await bloc.setLatLng(geolocation.coordinates);
                              await bloc.getSpots();
                            },
                            // YOUR GOOGLE MAPS API KEY
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        });
  }
}
