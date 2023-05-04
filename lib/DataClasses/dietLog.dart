import 'package:cfl_app/DataClasses/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//data class for DietLog of macronutrients
class DietLog{
  final DateTime date;
  final int? calories;
  final num? fat;
  final num? saturates;
  final num? carbohydrates;
  final num? sugars;
  final num? protein;
  final num? salt;
  final num? fibre;

  //sets values to 0 by default
  DietLog({
    this.calories = 0,
    this.fat = 0,
    this.saturates = 0,
    this.carbohydrates = 0,
    this.sugars = 0,
    this.protein = 0,
    this.salt = 0,
    this.fibre = 0,
    required this.date,
  });

  factory DietLog.fromProduct(Product product){
    return DietLog(
      date: product.timeAdded!,
      calories: product.calories!.toInt(),
      carbohydrates: product.carbs,
      fat: product.fat,
      protein: product.protein,
      saturates: product.satFat,
      sugars: product.sugar,
      salt: product.salt,
      fibre: product.fibre,
    );
  }

  //maps firestore document to DietLog object
  factory DietLog.fromFirestore(
      QueryDocumentSnapshot doc
      ) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Timestamp timestamp = data['date'];
    return DietLog(
      date: timestamp.toDate(),
      calories: data['calories'],
      fat: data['fat'],
      saturates: data['saturates'],
      carbohydrates: data['carbohydrates'],
      sugars: data['sugars'],
      protein: data['protein'],
      salt: data['salt'],
      fibre: data['fibre'],
    );
  }


  //used to set values inside firestore document for each document
  Map<String, dynamic> toFirestore() {
    return {
       "date": date,
      "calories": calories,
      "fat": fat,
      "saturates": saturates,
      "carbohydrates": carbohydrates,
      "sugars": sugars,
      "protein": protein,
      "salt": salt,
      "fibre": fibre,
    };
  }



}
