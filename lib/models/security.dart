class Security{
  int id;
  String name,icon;
  Security(this.id, this.name, this.icon);
  Security.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    icon = json['icon'];
    name = json['name'];
  }
}