import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sabbieparks/api/api.dart';
import 'package:sabbieparks/bloc/booking_bloc.dart';
import 'package:sabbieparks/models/map_request.dart';
import 'package:sabbieparks/models/spot.dart';
import 'package:sabbieparks/page/booking.dart';
import 'package:sabbieparks/widgets/bloc_provider.dart';

class DetailBloc extends Bloc {
  final Set<Polyline> polyLines = {};
  bool isLoading = false;
  String time = 'Unknown';
  String distance = 'Unknown';
  int id;
  LatLng latLng;
  Spot spot;
  List<IconData> icons = [
    Icons.account_balance,
    Icons.linked_camera,
    Icons.security,
    Icons.warning
  ];
  int selectedIndex = 0;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  final Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    getParkingDetails();
  }

  getParkingDetails() async {
    try {
      showLoader();
      var response = await api.getParkingSpotDetail(id);
      spot = Spot.fromJson(response.data);
      print(spot);
      addMarker(latLng, "mylocation");
      await drawRoute();
      showLoader(false);
    } catch (e) {
      print(e);
      showLoader(false);
    }
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  void createRoute(String encondedPoly) {
    polyLines.add(Polyline(
        polylineId: PolylineId(latLng.toString()),
        width: 4,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.red));
  }

  void addMarker(LatLng location, String address) {
    markers.add(Marker(
        markerId: MarkerId("${address}112"),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "go here"),
        icon: BitmapDescriptor.defaultMarker));
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];
    return lList;
  }

  drawRoute() async {
    LatLng destination =
        LatLng(double.parse(spot.latitude), double.parse(spot.longitude));
    String route =
        await _googleMapsServices.getRouteCoordinates(latLng, destination);
    Map values = jsonDecode(route);
    var routes = values["routes"][0]["overview_polyline"]["points"];
    time = values["routes"][0]["legs"][0]["steps"][0]["duration"]["text"];
    distance = values["routes"][0]["legs"][0]["steps"][0]["distance"]["text"];
    notifyChanges();
    createRoute(routes);
    addMarker(destination, "Destination");
  }

  showLoader([bool loading = true]) {
    isLoading = loading;
    notifyChanges();
  }

  DetailBloc(this.id, this.latLng);

  toBooking() {
    navigate(page: BookingPage(), bloc: BookingBloc(id));
  }
}
