import 'package:cloud_firestore/cloud_firestore.dart';

class UserData{
  //final String? uid;
   String? name;
  int? height;
  num? weight;
  DateTime? dOB;
  int? age;
  String? sex;
  int? activityLevel;
  int? carbPercentage;
  int? fatPercentage;
  int? proteinPercentage;
  int? weightGoal;

  UserData({
    //this.uid,
    this.name = 'user',
    this.height,
    this.weight,
    this.dOB,
    this.age,
    this.sex,
    this.activityLevel,
    this.carbPercentage = 50,
    this.fatPercentage = 30,
    this.proteinPercentage = 20,
    this.weightGoal
  });

  factory UserData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return UserData(
      //uid: data?['uid'],
      name: data?['name'],
      height: data?['height'],
      weight: data?['weight'],
      age: data?['age'],
      sex: data?['sex'],
      activityLevel: data?['activity'],
      carbPercentage: data?['carbPercentage'],
      proteinPercentage: data?['proteinPercentage'],
      fatPercentage: data?['fatPercentage'],
      weightGoal: data?['weightGoal'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      //'uid': uid,
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'sex': sex,
      'activity': activityLevel,
      'carbPercentage': carbPercentage,
      'proteinPercentage': proteinPercentage,
      'fatPercentage': fatPercentage,
      'weightGoal': weightGoal,
    };
  }

}

