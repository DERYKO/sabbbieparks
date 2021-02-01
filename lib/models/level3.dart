class Level3{
  int id;
  String address;

  Level3(this.id, this.address);
  Level3.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['formatted_address'];
  }
}