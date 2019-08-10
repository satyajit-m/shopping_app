class Profile {
  final name;
  final phone;
  final pinCode;
  final areaAndStreet;
  final locality;
  final landmark;
  final altPhone;
  Profile(this.name, this.phone, this.pinCode,
          this.areaAndStreet, this.locality, this.landmark,
          this.altPhone);
}

Map<String, dynamic> profileTransaction(Profile profile) {
  Map<String, dynamic> map = Map<String, dynamic>();
  map["name"] = profile.name;
  map["phone"] = profile.phone;
  map["pincode"] = profile.pinCode;
  map["areaAndStreet"] = profile.areaAndStreet;
  map["locality"] = profile.locality;
  map["landmark"] = profile.landmark;
  map["altPhone"] = profile.altPhone;
  return map;
}
