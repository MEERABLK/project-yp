// Import Dart's built-in library for working with JSON data
import 'dart:convert';


//step 1
// This function takes a raw JSON string (str),
// decodes it into a List of maps (dynamic objects),
// and then maps each one to a UserModel object using fromJson()
List<PokemonModel> pokemonModelFromJson(String str) {
  final jsonData = json.decode(str);        // decode JSON string -> Map
  final List<dynamic> dataList = jsonData["data"]; // extract the "data" array
  return dataList.map((x) => PokemonModel.fromJson(x)).toList();
}

// This function takes a List<UserModel> objects,
// converts each one into a Map (using toJson()),
// and encodes the entire list into a JSON strin
String pokemonModelToJson(List<PokemonModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

//step 2
// Represents a user object with nested fields like Address and Company
class PokemonModel {
  PokemonModel({
    required this.id,
    required this.name,
    required this.types,
    required this.abilities,
    required this.baseStats,
    required this.poke_images,
  });
  // Fields (properties) for each user

  int id;
  String name;
  List<String> types;
  List<String> abilities;
  Map<String,int> baseStats;
  PokeImages poke_images;
// String card_images;

  //step 3
  // Converts a Map<String, dynamic> (decoded JSON) into a UserModel object
  // Uses other model classes (Address, Company) to decode nested JSON fields
  factory PokemonModel.fromJson(Map<String, dynamic> json) => PokemonModel(
    id: json["id"],
    name: json["name"],
    types: json["types"],
    abilities: json["abilities"],
    baseStats: json["baseStats"],
      // poke_images: json["poke_images"]
    // poke_images: PokeImages.fromJson(json["poke_images"]),
    poke_images: (json["poke_images"] != null && json["poke_images"].isNotEmpty)
        ? PokeImages.fromJson(json["poke_images"][0]) // first (and only) image
        : PokeImages(image_url_cropped: ""), // fallback
  );

  //step 4
  // Converts the UserModel object back into a JSON compatible Map.
  // Useful for sending data to APIs.
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "types": types,
    "abilities": abilities,
    "baseStats": baseStats,
     "card_images": poke_images.toJson(),
  };
}

class PokeImages {
  PokeImages({
    required this.image_url_cropped,

  });

  String image_url_cropped;


  factory PokeImages.fromJson(Map<String, dynamic> json) => PokeImages(

    image_url_cropped: json["image_url_cropped"],
  );

  Map<String, dynamic> toJson() => {
    "image_url_cropped": image_url_cropped,

  };
}


