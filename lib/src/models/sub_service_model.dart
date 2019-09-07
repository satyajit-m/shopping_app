
class SubServiceModel {
  final name;
  final price;
  final serviceId;
  SubServiceModel(this.name,this.price, this.serviceId);
  Map<String, dynamic> toMap() {
    Map<String, dynamic> mp = Map<String, dynamic> ();
    mp["name"] = this.name;
    mp["price"] = this.price;
    mp["serviceId"] = this.serviceId;
    return mp;
  }
}