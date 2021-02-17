import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:sabbieparks/api/api.dart';
import 'package:sabbieparks/bloc/booking_bloc.dart';
import 'package:sabbieparks/bloc/booking_list_bloc.dart';
import 'package:sabbieparks/bloc/detail.dart';
import 'package:sabbieparks/bloc/notification_bloc.dart';
import 'package:sabbieparks/bloc/payment_bloc.dart';
import 'package:sabbieparks/bloc/reservation_bloc.dart';
import 'package:sabbieparks/bloc/vehicle_bloc.dart';
import 'package:sabbieparks/bloc/wallet_bloc.dart';
import 'package:sabbieparks/database/database_helper.dart';
import 'package:sabbieparks/helpers/wallet_manager.dart';
import 'package:sabbieparks/models/map_request.dart';
import 'package:sabbieparks/models/user.dart';
import 'package:sabbieparks/models/wallet.dart';
import 'package:sabbieparks/page/booking.dart';
import 'package:sabbieparks/page/booking_list.dart';
import 'package:sabbieparks/page/details.dart';
import 'package:sabbieparks/page/login.dart';
import 'package:sabbieparks/page/notification.dart';
import 'package:sabbieparks/page/payment.dart';
import 'package:sabbieparks/page/profile.dart';
import 'package:sabbieparks/page/reservation.dart';
import 'package:sabbieparks/page/vehicle.dart';
import 'package:sabbieparks/page/wallet.dart';
import 'package:sabbieparks/shared/strings.dart';
import 'package:sabbieparks/tools/auth_manager.dart';
import 'package:sabbieparks/widgets/bloc_provider.dart';
import 'login_bloc.dart';
import 'package:sabbieparks/helpers/wallet_manager.dart';

class HomeBloc extends Bloc {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final Set<Polyline> polyLines = {};
  GoogleMapController controller1;
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  GlobalKey<ScaffoldState> mainScaffold = GlobalKey();
  Wallet wallet;
  Set<Marker> markers = {};
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  Completer<GoogleMapController> controller = Completer();
  LatLng latLng = const LatLng(-1.2675, 36.8120);
  LocationData currentLocation;
  bool isLoading = false;
  File file;
  User user;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final dbHelper = DatabaseHelper.instance;
  int notificationCount;

  @override
  void initState() async {
    super.initState();
    await fcmMessages();
    getUserProfile();
  }

  Future fcmMessages() async {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        Map<String, dynamic> row = {
          'message': message['notification']['body'],
          'read': 0,
          'date': DateTime.now().toString().split(".")[0]
        };
        walletManager.getWalletBalance();
        await dbHelper.insert(row);
        notificationCount = await dbHelper.queryRowCount();
        notifyChanges();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        walletManager.getWalletBalance();
      },
      onResume: (Map<String, dynamic> message) async {
        walletManager.getWalletBalance();
      },
    );
  }

  void onCameraMove(CameraPosition position) {
    latLng = position.target;
  }

  toPayments() {
    navigate(
      page: PaymentPage(),
      bloc: PaymentBloc(),
    );
  }

  logout() async {
    authManager.logout();
    popAndNavigate(
      page: Login(),
      bloc: LoginBloc(),
    );
  }

  pickImage() async {
    file = await ImagePicker.pickImage(source: ImageSource.gallery);
    notifyChanges();
  }

  updateProfile() async {
    showLoader(true);
    if (file != null) {
      String base64Image = base64Encode(file.readAsBytesSync());
      String fileName = file.path.split("/").last;
      if (loginFormKey.currentState.validate()) {
        try {
          var response = await api.updateProfileImage({
            "image": base64Image,
            "name": fileName,
          }, titleController.text, firstNameController.text,
              lastNameController.text, emailController.text);
          user = User.fromJson(response.data['user']);
        } catch (e) {
          print(e);
        }
      }
    } else {
      if (loginFormKey.currentState.validate()) {
        try {
          var response = await api.updateProfile(
              titleController.text,
              firstNameController.text,
              lastNameController.text,
              emailController.text);
          user = User.fromJson(response.data['user']);
        } catch (e) {
          print(e);
        }
      }
    }
    file = null;
    showLoader(false);
  }

  toProfile() {
    navigate(
      page: ProfilePage(),
      bloc: HomeBloc(),
    );
  }

  toWallets() {
    navigate(
      page: WalletPage(),
      bloc: WalletBloc(),
    );
  }

  toVehicles() {
    navigate(page: VehiclePage(), bloc: VehicleBloc());
  }

  toNotifications() {
    navigate(page: NotificationPage(), bloc: NotificationBloc());
  }

  setLatLng(LatLng lng) async {
    latLng = lng;
  }

  getLocation() async {
    var location = new Location();
    location.onLocationChanged().listen((currentLocation) async {
      print(currentLocation);
      markers = {};
      latLng = LatLng(currentLocation.latitude, currentLocation.longitude);
      markers.add(Marker(
          markerId: MarkerId("yourlocation"),
          position: latLng,
          infoWindow: InfoWindow(title: "Your Location", snippet: "go here"),
          icon: BitmapDescriptor.fromAsset(userlocation)));
      var spots = await api.getParkingSpots(latLng);
      for (int i = 0; i < spots.data.length; i++) {
        var marker = LatLng(double.parse(spots.data[i]['latitude']),
            double.parse(spots.data[i]['longitude']));
        addMarker(marker, spots.data[i]['land_mark'], spots.data[i]);
      }
      notifyChanges();
    });
  }

  getSpots() async {
    showLoader();
    try {
      var spots = await api.getParkingSpots(latLng);
      print(spots.data);
      markers = {};
      for (int i = 0; i < spots.data.length; i++) {
        var marker = LatLng(double.parse(spots.data[i]['latitude']),
            double.parse(spots.data[i]['longitude']));
        addMarker(marker, spots.data[i]['land_mark'], spots.data[i]);
      }
    } catch (e) {
      alert('Profile', 'Error loading data');
    }
    showLoader(false);
  }

  void onMapCreated(GoogleMapController controller) {
    controller = controller;
  }

  drawRoute(spot) async {
    LatLng destination =
        LatLng(double.parse(spot.latitude), double.parse(spot.longitude));
    String route =
        await _googleMapsServices.getRouteCoordinates(latLng, destination);
    createRoute(route);
    markers.add(Marker(
        markerId: MarkerId("destination"),
        position: destination,
        infoWindow:
            InfoWindow(title: spot['client']['name'], snippet: "go here"),
        icon: BitmapDescriptor.defaultMarker));
  }

  void createRoute(String encondedPoly) {
    polyLines.add(Polyline(
        polylineId: PolylineId(latLng.toString()),
        width: 4,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.red));
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

  Future<void> addMarker(LatLng location, String address, spot) async {
    markers.add(Marker(
        markerId: MarkerId("${spot['id']}"),
        position: location,
        onTap: () {
          //await drawRoute(spot);
          //notifyChanges();
          drawerKey.currentState.removeCurrentSnackBar();
          return drawerKey.currentState.showSnackBar(new SnackBar(
              duration: Duration(minutes: 2),
              backgroundColor: Colors.amber,
              content: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Card(
                        color: Colors.white,
                        elevation: 6.0,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  spot['client']['name'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.0,
                                      color: Colors.blueGrey),
                                  maxLines: 2,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              spot['client']['logo'] != null
                                  ? Image.network(
                                      appUrl + spot['client']['logo'],
                                      height:
                                          MediaQuery.of(context).size.height /
                                              8,
                                      width: double.infinity)
                                  : Image.asset(
                                      client,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              8,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                              SizedBox(
                                height: 5,
                              ),
                              ButtonTheme(
                                height: 30.0,
                                child: RaisedButton(
                                  color: Colors.green,
                                  onPressed: () {
                                    toDetails(spot['id']);
                                  },
                                  child: Text(
                                    "Details",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Card(
                        color: Colors.white,
                        elevation: 6.0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  'Parking Price is ${spot['pricing']['cost_price']} Kes',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.0,
                                      color: Colors.blueGrey),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ButtonTheme(
                                    height: 30.0,
                                    minWidth:
                                        MediaQuery.of(context).size.width *
                                            1 /
                                            8,
                                    child: RaisedButton(
                                      color: Colors.green,
                                      onPressed: () {
                                        toBooking(spot['id']);
                                      },
                                      child: Text(
                                        "Book this spot",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )));
        },
        infoWindow: InfoWindow(title: address, snippet: "go here"),
        icon: BitmapDescriptor.fromAsset(carpark)));
  }

  toListBookings() {
    navigate(page: BookingListPage(), bloc: BookingListBloc());
  }

  toReservations() {
    navigate(page: ReservationPage(), bloc: ReservationBloc());
  }

  toDetails(int id) {
    navigate(page: DetailPage(), bloc: DetailBloc(id, latLng));
  }

  toBooking(int id) {
    navigate(page: BookingPage(), bloc: BookingBloc(id));
  }

  getUserProfile() async {
    try {
      showLoader();
      int count = await dbHelper.queryRowCount();
      notificationCount = count;
      var response = await api.getUserProfile();
      await walletManager.getWalletBalance();
      // var response1 = await api.getWalletBalance();
      user = User.fromJson(response.data);
      // wallet = Wallet.fromJson(response1.data);
      emailController.text = user.email;
      titleController.text = user.title;
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      getLocation();
      getSpots();
      showLoader(false);
    } catch (e) {
      showLoader(false);
    }
  }

  showLoader([bool loading = true]) {
    isLoading = loading;
    notifyChanges();
  }
}
