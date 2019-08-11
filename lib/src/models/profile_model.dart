class Profile {
  final name;
  final phone;
  final pinCode;
  final areaAndStreet;
  final locality;
  final landmark;
  final altPhone;
  Profile(this.name, this.phone, this.pinCode, this.areaAndStreet,
      this.locality, this.landmark, this.altPhone);
}

Map<String, dynamic> profileToMap(Profile profile) {
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

Profile mapToProfile(Map<String, dynamic> map) {
  Profile profile = Profile(map["name"], map["phone"], map["pincode"],
      map["areaAndStreet"], map["locality"], map["landmark"], map["altPhone"]);
  return profile;
}

String profileToString(Profile profile) {
  print(profile.name);
  return profile.name +
      "\n" +
      [
        profile.areaAndStreet,
      ].join(", ") +
      "\nNear " +
      profile.landmark +
      "\n" +
      profile.locality +
      "\nPin : " +
      profile.pinCode +
      "\nPhone No : " +
      [profile.phone, profile.altPhone].join(", ");
}
