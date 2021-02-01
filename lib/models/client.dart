class Client {
  int id;
  String name;

  Client(this.id, this.name);

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
