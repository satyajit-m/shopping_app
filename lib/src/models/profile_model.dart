class Profile {
  final String name;
  final phone;
  final pinCode;
  final String areaAndStreet;
  final String locality;
  final String landmark;
  final altPhone;
  Profile(this.name, this.phone, this.pinCode, this.areaAndStreet,
      this.locality, this.landmark, this.altPhone);

  static Map<String, dynamic> profileToMap(Profile profile) {
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

  // Very dangerous, use wisely. DONT USE IT
  static Map<String, dynamic> getEmptyMap() {
    return profileToMap(getEmptyProfile());
  }

  // Very dangerous, use wisely. DONT FUCKIN USE IT
  static Profile getEmptyProfile() {
    Profile profile = Profile("", "", "", "", "", "", "");
    return profile;
  }

  static Profile mapToProfile(Map<String, dynamic> map) {
    Profile profile = Profile(
        map["name"],
        map["phone"],
        map["pincode"],
        map["areaAndStreet"],
        map["locality"],
        map["landmark"],
        map["altPhone"]);
    return profile;
  }

  static String profileToString(Profile profile) {
    String areaAndStreet = "";
    List tlist = profile.areaAndStreet.split(" ");
    final split = 30;
    int currentLineLength = 0;
    for (int i = 0; i < tlist.length; i++) {
      if (currentLineLength + tlist[i].length >= split) {
        areaAndStreet += tlist[i] + "\n";
        currentLineLength = 0;
      } else {
        areaAndStreet += tlist[i] + " ";
        currentLineLength += tlist[i].length;
      }
    }

    areaAndStreet = areaAndStreet.trim();

    return (profile.name +
            "\n" +
            areaAndStreet +
            (profile.landmark.length != 0
                ? ("\nNear " + profile.landmark)
                : "") +
            "\n" +
            profile.locality +
            "\nPin : " +
            profile.pinCode +
            "\nPhone No : " +
            [profile.phone, profile.altPhone].join(", "))
        .trim();
  }
}
