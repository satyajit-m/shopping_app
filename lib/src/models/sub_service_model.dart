
class SubServiceModel {
  final name,price,serviceId,desc,prov;
  SubServiceModel(this.name,this.price, this.serviceId, this.desc, this.prov);
  Map<String, dynamic> toMap() {
    Map<String, dynamic> mp = Map<String, dynamic> ();
    mp["name"] = this.name;
    mp["price"] = this.price;
    mp["serviceId"] = this.serviceId;
    mp["desc"] = this.serviceId;
    mp["prov"] = this.serviceId;
    return mp;
  }
}