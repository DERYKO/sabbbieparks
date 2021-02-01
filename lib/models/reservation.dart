import 'package:sabbieparks/models/spot.dart';
import 'package:sabbieparks/models/vehicle.dart';

class Reservation {
  Vehicle vehicle;
  String registration_no, model_type, color, start, end, cost_price;
  int id;
  Spot spot;

  Reservation(this.spot, this.vehicle, this.registration_no, this.model_type,
      this.color, this.start, this.end, this.cost_price, this.id);

  Reservation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    registration_no = json['registration_no'];
    model_type = json['model_type'];
    color = json['color'];
    start = json['start'];
    end = json['end'];
    cost_price = json['cost_price'];
    vehicle = Vehicle.fromJson(json['vehicle']);
    spot = Spot.fromJson(json['spot']);
  }
}
