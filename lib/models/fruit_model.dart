// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Fruits> fruitFromJson(String str) =>
    List<Fruits>.from(json.decode(str).map((x) => Fruits.fromJson(x)));

String fruitsToJson(List<Fruits> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Fruits {
  String name;
  int id;
  String family;
  String order;
  String genus;
  Nutritions nutritions;

  Fruits({
    required this.name,
    required this.id,
    required this.family,
    required this.order,
    required this.genus,
    required this.nutritions,
  });

  factory Fruits.fromJson(Map<String, dynamic> json) => Fruits(
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
  double calories;
  double fat;
  double sugar;
  double carbohydrates;
  double protein;

  Nutritions({
    required this.calories,
    required this.fat,
    required this.sugar,
    required this.carbohydrates,
    required this.protein,
  });

  factory Nutritions.fromJson(Map<String, dynamic> json) => Nutritions(
    calories: json["calories"]?.toDouble(),
    fat: json["fat"]?.toDouble(),
    sugar: json["sugar"]?.toDouble(),
    carbohydrates: json["carbohydrates"]?.toDouble(),
    protein: json["protein"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "calories": calories,
    "fat": fat,
    "sugar": sugar,
    "carbohydrates": carbohydrates,
    "protein": protein,
  };
}
