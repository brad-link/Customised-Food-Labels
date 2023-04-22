import 'package:cloud_firestore/cloud_firestore.dart';

class UserData{
  final String? uid;
  final String? name;
  int? height;
  int? weight;
  int? age;
  String? sex;
  int? activityLevel;
  int? weightGoal;

  UserData({this.uid, this.name, this.height, this.weight, this.age, this.sex, this.activityLevel, this.weightGoal});

  factory UserData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return UserData(
      uid: data?['uid'],
      name: data?['name'],
      height: data?['height'],
      weight: data?['weight'],
      age: data?['age'],
      sex: data?['sex'],
      activityLevel: data?['activity'],
      weightGoal: data?['weightGoal'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'sex': sex,
      'activity': activityLevel,
      'weightGoal': weightGoal,
    };
  }

}

