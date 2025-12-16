// Import Dart's built-in library for working with JSON data
import 'dart:convert';
import 'package:projectyp/dependencies.dart';


//step 1
// This function takes a raw JSON string (str),
// decodes it into a List of maps (dynamic objects),
// and then maps each one to a UserModel object using fromJson()
List<PokemonModel> pokemonModelFromJson(String str) {
  final jsonData = json.decode(str);        // decode JSON string -> Map
  final List<dynamic> dataList = jsonData.values.toList(); // extract the "data" array
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
    required this.image,
  });
  // Fields (properties) for each user

  int id;
  String name;
  List<String> types;
  List<String> abilities;
  Map<String,int> baseStats;
  String image;

  static String normalizePokemonName(String name) {
    String normalized = _toKebabCase(name);

    normalized = normalized.replaceAll(RegExp(r"['’]|:-|\.|-\.|%"), "");

    const List<Map<String, String>> sections = [
      // === Gen 1 ===
      {
        "rock-star": "rockstar",
        "pop-star": "popstar",
        "nidoran-f": "nidoranf",
        "nidoran-m": "nidoranm",
        "mr-": "mr",
      },
      // === Gen 2 ===
      {
        "spiky-eared": "spikyeared",
        "ho-oh": "hooh",
      },
      // === Gen 4 ===
      {
        "mime-jr": "mimejr",
        "porygon-z": "porygonz",
      },
      // === Gen 5 ===
      {
        "-striped": "striped",
      },
      // === Gen 6 ===
      {
        "flabébé": "flabebe",
      },
      // === Gen 7 ===
      {
        "rockruff-dusk": "rockruff",
        "mo-o": "moo",
        "pom-pom": "pompom",
        "tapu-": "tapu",
        "dusk-mane": "duskmane",
        "dawn-wings": "dawnwings",
        "-bond": "-ash",
      },
      // === Gen 8 ===
      {
        "rapid-strike": "rapidstrike",
        "low-key": "lowkey",
        "galar-": "galar",
      },
      // === Gen 9 ===
      {
        "paldea-": "paldea",
        "three-segment": "threesegment",
        "great-tusk": "greattusk",
        "scream-tail": "screamtail",
        "brute-bonnet": "brutebonnet",
        "roaring-moon": "roaringmoon",
        "flutter-mane": "fluttermane",
        "slither-wing": "slitherwing",
        "sandy-shocks": "sandyshocks",
        "walking-wake": "walkingwake",
        "gouging-fire": "gougingfire",
        "raging-bolt": "ragingbolt",
        "iron-": "iron",
        "chien-pao": "chienpao",
        "chi-yu": "chiyu",
        "ting-lu": "tinglu",
        "wo-chien": "wochien",
        "-tera": "tera",
        "terastal": "-terastal",
      },
      // === Other ===
      {
        "mega-": "mega",
        "pokestar-": "pokestar",
        "-00": "00",
        "-door": "door",
        "brycen-": "brycen",
        "black-belt": "blackbelt",
      },
    ];

    // 4. Apply all replacements in order
    for (final section in sections) {
      section.forEach((pattern, replacement) {
        normalized = normalized.replaceAll(pattern, replacement);
      });
    }

    return normalized;
  }

  static String _toKebabCase(String str) {
    return str
        .trim()
        .replaceAll(RegExp(r'([a-z])([A-Z])'), r'$1-$2') // split camelCase
        .replaceAll(RegExp(r'\s+'), '-') // spaces to hyphens
        .replaceAll(RegExp(r'_+'), '-') // underscores to hyphens
        .toLowerCase();
  }

  //step 3
  // Converts a Map<String, dynamic> (decoded JSON) into a UserModel object
  // Uses other model classes (Address, Company) to decode nested JSON fields
  factory PokemonModel.fromJson(Map<String, dynamic> json) => PokemonModel(
    id: json["num"] ?? 0,
    name: json["name"] ?? '',
    types: List<String>.from(json["types"] ?? []),
    abilities: Map<String,String>.from(json["abilities"] ?? {}).values.toList(),
    baseStats: Map<String,int>.from(json["baseStats"] ?? {}),
    image: json["image"] ?? "https://play.pokemonshowdown.com/sprites/gen5/" + normalizePokemonName(json["name"] ?? 'missingno') + ".png"
  );

  //step 4
  // Converts the UserModel object back into a JSON compatible Map.
  // Useful for sending data to APIs.
  Map<String, dynamic> toJson() => {
    "num": id,
    "name": name,
    "types": types,
    "abilities": abilities,
    "baseStats": baseStats,
    "image": image,
  };
}