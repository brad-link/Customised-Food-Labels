import 'package:cfl_app/DataClasses/userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//nutritionGoals object
class NutritionGoals{
  int? calories;
  int? fat;
  int? saturates;
  int? carbohydrates;
  int? sugars;
  int? protein;
  int? salt;
  int? fibre;

  //sets the goals to Reference intake by default
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

  //calculates the basal metabolic rate from users information
  num setBMR(UserData user){
    num bmr = 10* user.weight! + 6.25*user.height! - (5* user.age!);
    if(user.sex == 'Male'){
      bmr += 5;
    }
    else{
      bmr -= 161;
    }
    return bmr;
  }

  //calculates daily macronutrient goals
  NutritionGoals.setGoals(UserData user){
    num bmr = setBMR(user);
    List<double> weightMultiplier = [-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1];
    int weightGoal = user.weightGoal!.toInt();
    if(user.activityLevel == 1){
      calories = (1.1*bmr).toInt();
      print(calories);
    } else if(user.activityLevel == 2){
      calories = (1.3*bmr).toInt();
      print(calories);
    }  else if(user.activityLevel == 3){
      calories = (1.5*bmr).toInt();
    } else if(user.activityLevel == 4){
      calories = (1.7*bmr).toInt();
    }
    calories = (calories! + (1000 * weightMultiplier[weightGoal - 1])).toInt();
    carbohydrates = calories! * (user.carbPercentage!/100)~/4;
    protein = (calories! * (user.proteinPercentage!/100)~/4);
    fat = (calories! * (user.fatPercentage!/100)~/9);
    saturates = (calories! * (8/100)~/9);
    sugars = (calories! * (8/100)~/4);
    salt = 6;
    fibre = ((calories!/1000)*14).toInt();
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
      fibre: data?['fibre'],
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
      if (fibre != null) "fibre": fibre,
    };
  }
}

