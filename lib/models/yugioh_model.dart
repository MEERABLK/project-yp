// Import Dart's built-in library for working with JSON data
import 'dart:convert';


//step 1
// This function takes a raw JSON string (str),
// decodes it into a List of maps (dynamic objects),
// and then maps each one to a UserModel object using fromJson()
List<YugiohModel> yuGiOhModelFromJson(String str) =>
    List<YugiohModel>.from(json.decode(str).map((x) => YugiohModel.fromJson(x)));


// This function takes a List<UserModel> objects,
// converts each one into a Map (using toJson()),
// and encodes the entire list into a JSON strin
String yuGiOhModelToJson(List<YugiohModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

//step 2
// Represents a user object with nested fields like Address and Company
class YugiohModel {
  YugiohModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
  });
  // Fields (properties) for each user

  int id;
  String name;
  String username;
  String email;
  Address address;
  String phone;
  String website;
  Company company;

  //step 3
  // Converts a Map<String, dynamic> (decoded JSON) into a UserModel object
  // Uses other model classes (Address, Company) to decode nested JSON fields
  factory YugiohModel.fromJson(Map<String, dynamic> json) => YugiohModel(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    email: json["email"],
    address: Address.fromJson(json["address"]),
    phone: json["phone"],
    website: json["website"],
    company: Company.fromJson(json["company"]),
  );

  //step 4
  // Converts the UserModel object back into a JSON compatible Map.
  // Useful for sending data to APIs.
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "username": username,
    "email": email,
    "address": address.toJson(),
    "phone": phone,
    "website": website,
    "company": company.toJson(),
  };
}

class Address {
  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  String street;
  String suite;
  String city;
  String zipcode;
  Geo geo;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    street: json["street"],
    suite: json["suite"],
    city: json["city"],
    zipcode: json["zipcode"],
    geo: Geo.fromJson(json["geo"]),
  );

  Map<String, dynamic> toJson() => {
    "street": street,
    "suite": suite,
    "city": city,
    "zipcode": zipcode,
    "geo": geo.toJson(),
  };
}

class Geo {
  Geo({
    required this.lat,
    required this.lng,
  });

  String lat;
  String lng;

  factory Geo.fromJson(Map<String, dynamic> json) => Geo(
    lat: json["lat"],
    lng: json["lng"],
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

class Company {
  Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  String name;
  String catchPhrase;
  String bs;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    name: json["name"],
    catchPhrase: json["catchPhrase"],
    bs: json["bs"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "catchPhrase": catchPhrase,
    "bs": bs,
  };
}