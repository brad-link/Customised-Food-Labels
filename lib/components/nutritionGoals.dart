import 'package:cfl_app/userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NutritionGoals{
  int? calories;
  int? fat;
  int? saturates;
  int? carbohydrates;
  int? sugars;
  int? protein;
  int? salt;
  int? fibre;

  NutritionGoals({
    this.calories = 2000,
    this.fat = 70,
    this.saturates = 20,
    this.carbohydrates = 260,
    this.sugars = 90,
    this.protein = 50,
    this.salt = 6,
    this.fibre = 30,
  });

  NutritionGoals setBMR(UserData user){
    num bmr = 10* user.weight! + 6.25*user.height!;
    if(user.sex == 'male'){
      bmr += 5;
    }
    else{
      bmr -= 161;
    }
    return NutritionGoals(calories: bmr.toInt());
  }


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

