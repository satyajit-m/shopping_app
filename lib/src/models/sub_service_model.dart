class SubServiceModel {
  final name, price, serviceId, desc, prov, img, rate;
  SubServiceModel(this.name, this.price, this.serviceId, this.desc, this.prov,
      this.img, this.rate);
  Map<String, dynamic> toMap() {
    Map<String, dynamic> mp = Map<String, dynamic>();
    mp["name"] = this.name;
    mp["price"] = this.price;
    mp["serviceId"] = this.serviceId;
    mp["desc"] = this.serviceId;
    mp["prov"] = this.serviceId;
    mp["img"] = this.img;
    mp["rate"] = this.rate;

    return mp;
  }
}
