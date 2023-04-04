import 'dart:async';

import 'package:cfl_app/TrafficValues.dart';
import 'package:cfl_app/components/dietLog.dart';
import 'package:cfl_app/userData.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({
    this.uid,
  }) {
    userData = FirebaseFirestore.instance.collection('Users');
    userDocRef = userData.doc(uid);
    accountDetails = userDocRef.collection("account");
    nutritionDetails = userDocRef.collection("nutrition");
  }
  late final CollectionReference userData;
  // = FirebaseFirestore.instance.collection("User Data");
  //final CollectionReference mtlValues = FirebaseFirestore.instance.collection("User Data");
  final CollectionReference users =
      FirebaseFirestore.instance.collection("Users");
  late final DocumentReference userDocRef;
  late final CollectionReference accountDetails;
  late final CollectionReference nutritionDetails;

  Future updateUserData(String? name, num? height, num? weight) async {
    /*var data ={
      'name': name,
      'height': height,
      'weight': weight,
    };*/
    return await accountDetails.doc("personal details").set({
      'name': name,
      'height': height,
      'weight': weight,
      /*'values': {
        'fat': {
          'green': values.fatGreen,
          'amber': values.fatAmber,
        },
        'satFat': {
          'green': values.satFatGreen,
          'amber': values.satFatAmber,
        },
        'sugar': {
          'green': values.sugarGreen,
          'amber': values.sugarAmber,
        },
        'salt': {
          'green': values.saltGreen,
          'amber': values.saltAmber,
        }
      }*/
    });
  }

  Future setMTL(TrafficValues values) async {
    return await accountDetails.doc('MTL').set(values.toFirestore());
    //return await accountDetails.doc('MTL').set(values);
  }

  Future updateMTL(
      String green, String amber, num greenValue, num amberValue) async {
    return await accountDetails.doc('MTL').update({
      green: greenValue,
      amber: amberValue,
    });
  }

  Stream<TrafficValues?> getMTLStream() {
    final ref = accountDetails.doc('MTL').withConverter(
          fromFirestore: TrafficValues.fromFirestore,
          toFirestore: (TrafficValues values, _) => values.toFirestore(),
        );
    return ref.snapshots().map((doc) => doc.data()).handleError((error) {
      print('Error getting MTL stream: $error');
    });
  }

  Future<TrafficValues?> getMTL() async {
    final mtlDocRef = accountDetails.doc('MTL').withConverter(
          fromFirestore: TrafficValues.fromFirestore,
          toFirestore: (TrafficValues values, _) => values.toFirestore(),
        );
    final docSnap = await mtlDocRef.get();

    return docSnap.data();
  }

  UserData _userDataFromSnapshotTwo2(DocumentSnapshot snapshot) {
    return UserData(
      //uid: uid,
      name: snapshot.get('name') ?? "",
      height: snapshot.get('height') ?? 0,
      weight: snapshot.get('weight') ?? 0,
    );
  }

  Future updateMTL2(
      num? fatGreen,
      num? fatAmber,
      num? satFatGreen,
      num? satFatAmber,
      num? sugarGreen,
      num? sugarAmber,
      num? saltGreen,
      num? saltAmber) async {
    var mtl = {
      'fG': fatGreen,
      'fA': fatAmber,
      'sFG': satFatGreen,
      'sFA': satFatAmber,
      'sugG': sugarGreen,
      'sugA': sugarAmber,
      'saltG': saltGreen,
      'saltA': saltAmber,
    };
    return await accountDetails.doc('MTL').set(mtl);
  }

  Future updateLog(DietLog entry) async {
    String date = DateFormat('dd-MM-yyyy').format(entry.date);
    print('Database $date');
    //final date = entry?.date as String;
    return await nutritionDetails.doc(date).set(entry.toFirestore());
  }

  Future<DietLog?> getEntry() async {}


  Stream<List<DietLog?>> get nutritionTracker {
    return nutritionDetails.orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
    .map((doc) => DietLog.fromFirestore(doc)).toList());
        //.map(_foodTracker);
  }

  /*List<DietLog?> _foodTracker(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => DietLog
     /* return DietLog(
        date: doc.get('date'),
        calories: doc.get('calories'),
        fat: doc.get('fat'),
        saturates: doc.get('saturates'),
        carbohydrates: doc.get('carbohydrates'),
        sugars: doc.get('sugars'),
        protein: doc.get('protein'),
        salt: doc.get('salt'),
        fibre: doc.get('fibre'),
      );*/
    //}).toList();
  }*/

  /*Stream<List<DietLog?>> get getLog{
    List<DietLog?> log = [];
    nutritionDetails.get().then((querySnapshot){
      for(var docSnapshot in querySnapshot.docs){
        log.add(docSnapshot as DietLog?);
      }
    });
    return log;
  }

  Stream<List<DietLog?>> getEntries(){
    List<DietLog?> log = [];
    nutritionDetails.snapshots().map((querySnapshot){
      for(var docSnapshot in querySnapshot.docs){
        log.add(docSnapshot as DietLog?);
      }
    });
    return log;
  }*/

  Stream<QuerySnapshot> get user {
    return userData.snapshots();
  }

  UserData _userDataFromSnapshotTwo(DocumentSnapshot snapshot) {
    return UserData(
      //uid: uid,
      name: snapshot.get('name') ?? "",
      height: snapshot.get('height') ?? 0,
      weight: snapshot.get('weight') ?? 0,
    );
  }

  Stream<DocumentSnapshot> get userInformation {
    return userData.doc(uid).snapshots();
  }

  Stream<UserData> get userInfo {
    return accountDetails
        .doc('personal details')
        .snapshots()
        .map(_userDataFromSnapshotTwo);
  }
}
