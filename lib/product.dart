import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Product {
  final String? code;
  final String? productName;
  final num? carbs;
  final num? carbs_100g;
  final num? calories;
  final num? calories_100g;
  final num? fat;
  final num? fat_100g;
  final num? protein;
  final num? protein_100g;
  final num? sugar;
  final num? sugar_100g;
  final num? salt;
  final num? salt_100g;
  final num? satFat;
  final num? sat_fat;
  final num? sat_fat100g;
  final num? satFat_100g;
  final String? serve_size;
  final String? quantity;
  final num? serving_quantity;
  final String? image;
  num? portion;
  num? numOfPortions;
  String? dateAdded;
  DateTime? timeAdded;
  String? productID;

  Product({
    this.code,
    this.productName,
    this.carbs,
    this.carbs_100g,
    this.calories,
    this.calories_100g,
    this.fat,
    this.fat_100g,
    this.protein,
    this.protein_100g,
    this.sugar,
    this.sugar_100g,
    this.salt,
    this.salt_100g,
    this.satFat,
    this.satFat_100g,
    this.sat_fat,
    this.sat_fat100g,
    this.serve_size,
    this.quantity,
    this.serving_quantity,
    this.image,
    this.portion,
    this.numOfPortions,
    this.dateAdded,
    this.timeAdded,
    this.productID,
  });


  setPortionValues(num portionIn, num numOfPortionsIn) {
    portion = portionIn;
    numOfPortions = numOfPortionsIn;
  }
  setDateTime(DateTime time, String day){
    dateAdded = day;
    timeAdded = time;
    String? timeString = DateFormat('h:mm:ss a').format(time);
    productID = (productName! + timeString)!;
  }

  factory Product.fromJson(final json) {
    var serving = json["product"]["serving_quantity"];
    num? serveSize;
    if (serving is String) {
      serveSize = num.parse(serving);
    } else {
      serveSize = serving;
    }
    return Product(
      code: json["code"].toString(),
      productName: json["product"]["product_name"].toString(),
      carbs: json["product"]["nutriments"]['carbohydrates_serving'],
      carbs_100g: json["product"]["nutriments"]['carbohydrates_100g'],
      calories: json["product"]["nutriments"]["energy-kcal_serving"],
      calories_100g: json["product"]["nutriments"]['energy-kcal_100g'],
      fat: json["product"]["nutriments"]['fat_serving'],
      fat_100g: json["product"]["nutriments"]['fat_100g'],
      protein: json["product"]["nutriments"]['proteins_serving'],
      protein_100g: json["product"]["nutriments"]['proteins_100g'],
      sugar: json["product"]["nutriments"]['sugars_serving'],
      sugar_100g: json["product"]["nutriments"]['sugars_100g'],
      salt: json["product"]["nutriments"]['salt_serving'],
      salt_100g: json["product"]["nutriments"]['salt_100g'],
      satFat: json["product"]["nutriments"]['saturated_fat_serving'],
      satFat_100g: json["product"]["nutriments"]['saturated_fat_100g'],
      sat_fat: json["product"]["nutriments"]["saturated-fat"],
      sat_fat100g: json["product"]["nutriments"]["saturated-fat_100g"],
      serve_size: json["product"]["serving_size"].toString(),
      quantity: json["product"]["quantity"].toString(),
      serving_quantity: serveSize,
      image: json['product']["image_front_thumb_url"],
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      'code': code,
      'productName': productName,
      'carbs': carbs,
      'carbs_100g': carbs_100g,
      'calories': calories,
      'calories_100g': calories_100g,
      'fat': fat,
      'fat_100g': fat_100g,
      'protein': protein,
      'protein_100g': protein_100g,
      'sugar': sugar,
      'sugar_100g': sugar_100g,
      'salt': salt,
      'salt_100g': salt_100g,
      'satFat': satFat,
      'satFat_100g': satFat_100g,
      'sat_fat': sat_fat,
      'sat_fat100g': sat_fat100g,
      'serve_size': serve_size,
      'quantity': quantity,
      'serving_quantity': serving_quantity,
      'image': image,
      'portion': portion,
      'numOfPortions': numOfPortions,
      'dateAdded': dateAdded,
      'timeAdded': timeAdded,
      'productID': productID,
    };
  }

  factory Product.fromFirestore(
      DocumentSnapshot doc
    //DocumentSnapshot<Map<String, dynamic>> snapshot,
    //SnapshotOptions? options,
  ) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Timestamp timestamp = data?['timeAdded'];
    DateTime? dateTime = timestamp?.toDate();
    return Product(
      code: data?['code'],
      productName: data?['productName'],
      carbs: data?['carbs'],
      carbs_100g: data?['carbs_100g'],
      calories: data?['calories'],
      calories_100g: data?['calories_100g'],
      fat: data?['fat'],
      fat_100g: data?['fat_100g'],
      protein: data?['protein'],
      protein_100g: data?['protein_100g'],
      sugar: data?['sugar'],
      sugar_100g: data?['sugar_100g'],
      salt: data?['salt'],
      salt_100g: data?['salt_100g'],
      satFat: data?['satFat'],
      satFat_100g: data?['satFat_100g'],
      sat_fat: data?['sat_fat'],
      sat_fat100g: data?['sat_fat100g'],
      serve_size: data?['serve_size'],
      quantity: data?['quantity'],
      serving_quantity: data['serving_quantity'],
      image: data?['image'],
      portion: data?['portion'],
      numOfPortions: data?['numOfPortions'],
      dateAdded: data?['dateAdded'],
      timeAdded: timestamp.toDate(),
      productID: data['productID'],
    );
  }
}


