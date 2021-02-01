import 'package:sabbieparks/models/VehicleType.dart';

class Vehicle {
  String registration_no, model_type, color;
  int id;
  VehicleType vehicleType;

  Vehicle(this.id, this.registration_no, this.model_type, this.color,
      this.vehicleType);

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    registration_no = json['registration_no'];
    model_type = json['model_type'];
    color = json['color'];
    vehicleType = VehicleType.fromJson(json['vehicle_type']);
  }
}
