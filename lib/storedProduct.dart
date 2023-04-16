import 'package:cfl_app/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
/*
class StoredProduct extends Product{
  num? portion;
  num? numOfPortions;
  String? dateAdded;
  DateTime timeAdded;

  StoredProduct(  {
    required String? code,
    required String? productName,
    required num? carbs,
    required num? carbs_100g,
    required num? calories,
    required num? calories_100g,
    required num? fat,
    required num? fat_100g,
    required num? protein,
    required num? protein_100g,
    required num? sugar,
    required num? sugar_100g,
    required num? salt,
    required num? salt_100g,
    required num? satFat,
    required num? sat_fat,
    required num? sat_fat100g,
    required num? satFat_100g,
    required String? serve_size,
    required String? quantity,
    required num? serving_quantity,
    required String? image,
    required this.portion,
    required this.numOfPortions,
    required this.dateAdded,
    required this.timeAdded,
  }); /*super(
    code: code,
    productName: productName,
    carbs: carbs,
    carbs_100g: carbs_100g,
    calories: calories,
    calories_100g: calories_100g,
    fat: fat,
    fat_100g: fat_100g,
    protein: protein,
    protein_100g: protein_100g,
    sugar: sugar,
    sugar_100g: sugar_100g,
    salt: salt,
    salt_100g: salt_100g,
    satFat: satFat,
    satFat_100g: satFat_100g,
    sat_fat: sat_fat,
    sat_fat100g: sat_fat100g,
    serve_size: serve_size,
    quantity: quantity,
    serving_quantity: serving_quantity,
    image: image,
  );
  */

  StoredProduct.storeProduct(Product product,
      num? p, num? numOfP, String dateAdd)
    : timeAdded = DateTime.now(),
  portion = p,
  numOfPortions = numOfP,
  dateAdded = dateAdd,
        super(
        code: product.code,
        productName: product.productName,
        carbs: product.carbs,
        carbs_100g: product.carbs_100g,
        calories: product.calories,
        calories_100g: product.calories_100g,
        fat: product.fat,
        fat_100g: product.fat_100g,
        protein: product.protein,
        protein_100g: product.protein_100g,
        sugar: product.sugar,
        sugar_100g: product.sugar_100g,
        salt: product.salt,
        salt_100g: product.salt_100g,
        satFat: product.satFat,
        satFat_100g: product.satFat_100g,
        sat_fat: product.sat_fat,
        sat_fat100g: product.sat_fat100g,
        serve_size: product.serve_size,
        quantity: product.quantity,
        serving_quantity: product.serving_quantity,
        image: product.image,
      );



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
    };
  }

  factory StoredProduct.fromFirestore(
      DocumentSnapshot doc
      //DocumentSnapshot<Map<String, dynamic>> snapshot,
      //SnapshotOptions? options,
      ) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Timestamp timestamp = data?['timeAdded'];
    DateTime? dateTime = timestamp?.toDate();
    return StoredProduct(
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
    );
  }
}
*/
