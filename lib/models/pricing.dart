class Pricing {
  int id, parking_spot_id, cost_price;

  Pricing(this.id, this.parking_spot_id, this.cost_price);

  Pricing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cost_price = json['cost_price'];
    parking_spot_id = json['parking_spot_id'];
  }
}
