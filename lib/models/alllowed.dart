class Allowed {
  int id,vehicle_type_id,parking_spot_id;

  Allowed(this.id, this.vehicle_type_id, this.parking_spot_id);

  Allowed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicle_type_id = json['vehicle_type_id'];
    parking_spot_id = json['parking_spot_id'];
  }
}