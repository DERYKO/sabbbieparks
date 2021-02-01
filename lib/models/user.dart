
class User {
  String title, firstName, lastName, email, phoneNumber,avatar;
  int id;


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['first_name'] = this.lastName;
    data['last_name'] = this.firstName;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['avatar'] = this.avatar;
    return data;
  }

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    avatar = json['avatar'];
  }

  User(this.title, this.firstName, this.lastName, this.email, this.phoneNumber,
      this.avatar, this.id);
}
