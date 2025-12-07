// Import Dart's built-in library for working with JSON data
import 'dart:convert';


//step 1
// This function takes a raw JSON string (str),
// decodes it into a List of maps (dynamic objects),
// and then maps each one to a UserModel object using fromJson()
List<YugiohModel> yugiohModelFromJson(String str) {
  final jsonData = json.decode(str);        // decode JSON string -> Map
  final List<dynamic> dataList = jsonData["data"]; // extract the "data" array
  return dataList.map((x) => YugiohModel.fromJson(x)).toList();
}

// This function takes a List<UserModel> objects,
// converts each one into a Map (using toJson()),
// and encodes the entire list into a JSON strin
String yugiohModelToJson(List<YugiohModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

//step 2
// Represents a user object with nested fields like Address and Company
class YugiohModel {
  YugiohModel({
    required this.id,
    required this.name,
    required this.type,
    required this.desc,
    required this.card_images,

  });
  // Fields (properties) for each user

  int id;
  String name;
  String type;
  String desc;
   CardImages card_images;
// String card_images;

  //step 3
  // Converts a Map<String, dynamic> (decoded JSON) into a UserModel object
  // Uses other model classes (Address, Company) to decode nested JSON fields
  factory YugiohModel.fromJson(Map<String, dynamic> json) => YugiohModel(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    desc: json["desc"],
      // card_images: json["card_images"]
    // card_images: CardImages.fromJson(json["card_images"]),
     card_images: CardImages.fromJson(json["card_images"][0]), // first image

  );

  //step 4
  // Converts the UserModel object back into a JSON compatible Map.
  // Useful for sending data to APIs.
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "desc": desc,
     "card_images": card_images.toJson(),
  };
}

class CardImages {
  CardImages({
    required this.image_url_cropped,

  });

  String image_url_cropped;


  factory CardImages.fromJson(Map<String, dynamic> json) => CardImages(

    image_url_cropped: json["image_url_cropped"],
  );

  Map<String, dynamic> toJson() => {
    "image_url_cropped": image_url_cropped,

  };
}


