import 'package:sabbieparks/models/security.dart';

class Feature{
  int id,parking_spot_id,security_id;
  Security security;

  Feature.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parking_spot_id = json['parking_spot_id'];
    security_id = json['security_id'];
    security = Security.fromJson(json['security']);
  }

  Feature(this.id, this.parking_spot_id, this.security_id, this.security);
}