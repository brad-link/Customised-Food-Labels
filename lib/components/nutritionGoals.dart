import 'package:cloud_firestore/cloud_firestore.dart';

class NutritionGoals{
  final int? calories;
  final int? fat;
  final int? saturates;
  final int? carbohydrates;
  final int? sugars;
  final int? protein;
  final int? salt;
  //final int? fibre;

  NutritionGoals({
    this.calories = 2000,
    this.fat = 70,
    this.saturates = 20,
    this.carbohydrates = 260,
    this.sugars = 90,
    this.protein = 50,
    this.salt = 6,
    //this.fibre = 30,
  });


  factory NutritionGoals.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return NutritionGoals(
      calories: data?['calories'],
      fat: data?['fat'],
      saturates: data?['saturates'],
      carbohydrates: data?['carbohydrates'],
      sugars: data?['sugars'],
      protein: data?['protein'],
      salt: data?['salt'],
      //fibre: data?['fibre'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (calories != null) "calories": calories,
      if (fat != null) "fat": fat,
      if (saturates != null) "saturates": saturates,
      if (carbohydrates != null) "carbohydrates": carbohydrates,
      if (sugars != null) "sugars": sugars,
      if (protein != null) "protein": protein,
      if (salt != null) "salt": salt,
      //if (fibre != null) "fibre": fibre,
    };
  }
}

