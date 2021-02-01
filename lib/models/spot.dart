import 'package:sabbieparks/models/alllowed.dart';
import 'package:sabbieparks/models/client.dart';
import 'package:sabbieparks/models/feature.dart';
import 'package:sabbieparks/models/level3.dart';
import 'package:sabbieparks/models/pricing.dart';

class Spot {
  int id;
  String parking_spot_code, land_mark, latitude, longitude, status;
  List<Allowed> allowed = [];
  List<Feature> feature = [];
  Pricing price;
  Level3 level3;
  Client client;

  Spot(this.level3, this.id, this.parking_spot_code, this.land_mark,
      this.latitude, this.longitude, this.status, this.allowed, this.price);

  Spot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parking_spot_code = json['parking_spot_code'];
    land_mark = json['land_mark'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    price = json['pricing']!=null ? Pricing.fromJson(json['pricing']) : null;
    level3 = json['level3']!=null ? Level3.fromJson(json['level3']) : null;
    client = json['client']!=null ? Client.fromJson(json['client']) : null;
    if( json['allowed']!=null){
      for (var i = 0; i < json['allowed'].length; i++) {
        allowed.add(Allowed.fromJson(json['allowed'][i]));
      }
    }
    if(json['feature']!=null){
      for (var i = 0; i < json['feature'].length; i++) {
        feature.add(Feature.fromJson(json['feature'][i]));
      }
    }
  }
}
