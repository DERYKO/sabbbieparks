import 'package:sabbieparks/models/spot.dart';
import 'package:sabbieparks/models/vehicle.dart';

class Booking {
  Vehicle vehicle;
  String registration_no, model_type, color,created_at;
  int id, expiry_time, inconvenience_fee;
  int status;
  Spot spot;

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status']!=null ? json['status'] : false;
    registration_no = json['registration_no'];
    model_type = json['model_type'];
    color = json['color'];
    inconvenience_fee = json['inconvenience_fee'];
    expiry_time = json['expiry_time'];
    created_at = json['created_at'];
    vehicle = Vehicle.fromJson(json['user_vehicle']);
    spot = Spot.fromJson(json['parking_spot']);
  }

  Booking(
      this.vehicle,
      this.registration_no,
      this.model_type,
      this.color,
      this.id,
      this.expiry_time,
      this.inconvenience_fee,
      this.status,
      this.spot,this.created_at);
}
