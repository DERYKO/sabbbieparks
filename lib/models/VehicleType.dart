class VehicleType {
  String icon, name;
  int id;

  VehicleType(this.id, this.icon, this.name);

  VehicleType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    icon = json['icon'];
    name = json['name'];
  }
}
