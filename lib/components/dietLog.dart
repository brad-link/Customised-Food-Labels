import 'package:cloud_firestore/cloud_firestore.dart';

class DietLog{
  final DateTime date;
  final int calories;
  final int fat;
  final int saturates;
  final int carbohydrates;
  final int sugars;
  final int protein;
  final int salt;
 // final int fibre;

  DietLog({
    this.calories = 0,
    this.fat = 0,
    this.saturates = 0,
    this.carbohydrates = 0,
    this.sugars = 0,
    this.protein = 0,
    this.salt = 0,
    //this.fibre = 0,
    required this.date,
  });

  factory DietLog.fromFirestore(
      QueryDocumentSnapshot doc
      //DocumentSnapshot<Map<String, dynamic>> snapshot,
      //SnapshotOptions? options,
      ) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Timestamp timestamp = data?['date'];
    //if (timestamp == null) {
      //throw ArgumentError('Invalid diary entry: date is missing');
    //}
    return DietLog(
      date: timestamp.toDate(),
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
       "date": date,
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
