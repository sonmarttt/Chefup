// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Welcome> fruitFromJson(String str) =>
    List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

String welcomeToJson(List<Welcome> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Welcome {
  String name;
  int id;
  String family;
  String order;
  String genus;
  Nutritions nutritions;

  Welcome({
    required this.name,
    required this.id,
    required this.family,
    required this.order,
    required this.genus,
    required this.nutritions,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    name: json["name"],
    id: json["id"],
    family: json["family"],
    order: json["order"],
    genus: json["genus"],
    nutritions: Nutritions.fromJson(json["nutritions"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "family": family,
    "order": order,
    "genus": genus,
    "nutritions": nutritions.toJson(),
  };
}

class Nutritions {
  int calories;
  int fat;
  int sugar;
  int carbohydrates;
  int protein;

  Nutritions({
    required this.calories,
    required this.fat,
    required this.sugar,
    required this.carbohydrates,
    required this.protein,
  });

  factory Nutritions.fromJson(Map<String, dynamic> json) => Nutritions(
    calories: json["calories"],
    fat: json["fat"],
    sugar: json["sugar"],
    carbohydrates: json["carbohydrates"],
    protein: json["protein"],
  );

  Map<String, dynamic> toJson() => {
    "calories": calories,
    "fat": fat,
    "sugar": sugar,
    "carbohydrates": carbohydrates,
    "protein": protein,
  };
}
