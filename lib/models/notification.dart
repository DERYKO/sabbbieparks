class Notify {
  int id;
  String message, date;
  int read;

  Notify(this.id, this.message, this.date, this.read);
  Notify.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    read = json['read'];
    date = json['date'];
  }
}
