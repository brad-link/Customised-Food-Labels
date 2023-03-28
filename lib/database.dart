import 'dart:async';

import 'package:cfl_app/TrafficValues.dart';
import 'package:cfl_app/userData.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({this.uid,}){
    userData = FirebaseFirestore.instance.collection('Users');
    userDocRef = userData.doc(uid);
    accountDetails = userDocRef.collection("account");
    nutritionDetails = userDocRef.collection("nutrition");
  }
  late final CollectionReference userData;
  // = FirebaseFirestore.instance.collection("User Data");
  //final CollectionReference mtlValues = FirebaseFirestore.instance.collection("User Data");
  final CollectionReference users = FirebaseFirestore.instance.collection("Users");
  late final DocumentReference userDocRef;
  late final CollectionReference accountDetails;
  late final CollectionReference nutritionDetails;


  Future updateUserData(String? name, num? height, num? weight) async{
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

  Future setMTL(TrafficValues values) async{
    return await accountDetails.doc('MTL').set(values.toFirestore());
    //return await accountDetails.doc('MTL').set(values);
  }

  Future updateMTL(String green, String amber, num greenValue, num amberValue) async{
    return await accountDetails.doc('MTL').update({
      green : greenValue,
      amber : amberValue,
    });
  }


  Stream<TrafficValues?> getMTLStream() {
    final ref = accountDetails.doc('MTL')
        .withConverter(fromFirestore: TrafficValues.fromFirestore,
        toFirestore: (TrafficValues values, _) => values.toFirestore(),
    );
    return ref.snapshots().map((doc) => doc.data()).handleError((error) {
      print('Error getting MTL stream: $error');
    });
  }
    // (snapshot, _) => TrafficValues.fromFirestore(snapshot),

  /*Stream<TrafficValues> getTrafficValuesStream() {
    final trafficValuesDocRef = accountDetails.doc('MTL');
    return trafficValuesDocRef.snapshots().map((snapshot) {
      return TrafficValues.fromFirestore(snapshot, null);
    });
  }*/


  Future<TrafficValues?> getMTL() async {
    final mtlDocRef = accountDetails.doc('MTL').withConverter(
        fromFirestore: TrafficValues.fromFirestore, toFirestore: (TrafficValues values, _) => values.toFirestore(),
    );
    final docSnap = await mtlDocRef.get();

    return docSnap.data();
  }

  UserData _userDataFromSnapshotTwo2(DocumentSnapshot snapshot){
    return UserData(
      //uid: uid,
      name: snapshot.get('name')??"",
      height: snapshot.get('height')??0,
      weight: snapshot.get('weight')??0,
    );
  }

  Future updateMTL2(num? fatGreen, num? fatAmber, num? satFatGreen, num? satFatAmber,
  num? sugarGreen, num? sugarAmber, num? saltGreen, num? saltAmber) async{
    var mtl ={
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

  /*Future updateMTLValue(String ref, num? value) async{
    return await mtlValues.doc(uid).update({ref: value});
  }*/


  /*Future updateMTL2(List<List<num>> mtl) async{
    List<Map<String, num>> mtlMap = mtl.map((innerList) {
      return Map.fromIterable(innerList.asMap().keys,
          key: (index) => 'value$index', value: (index) => innerList[index]);
    }).toList();
    return await mtlValues.doc(uid).set({'mtl': mtlMap,
    });
  }*/


  /*Stream<List<List<num>>> getMTL() async* {
    final doc = await mtlValues.doc(uid).get();
    if (doc.exists) {
      final data = doc.data() as List<dynamic>;
      return List<List<num>>.from(data.map(
              (list) => List<num>.from(list.map((value) => value as num))));
    } else {
      return [];
    }
  }*/



  /*Stream<List<List<num>>> getMTL() {
    return mtlValues.doc(uid).snapshots().map((doc) {
      List<List<num>> mtl = [];
      if (doc.exists) {
        List<dynamic> data = doc.data()!['mtl'];
        for (var item in data) {
          List<num> tempList = [];
          for (var value in item) {
            tempList.add(value);
          }
          mtl.add(tempList);
        }
      }
      return mtl;
    });
  }*/

  /*Future updateMTLList(int listIndex, List<num> newList) async{
    List<List<num>> mtl = await getMTL();
    mtl[listIndex] = newList;
    return await mtlValues.doc(uid).set(mtl);
  }*/


  Stream<QuerySnapshot> get user{
    return userData.snapshots();
  }
  /*List<UserData> _userDataFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return UserData(
        name: doc.get('name')??"",
        height: doc.get('height')??0,
        weight: doc.get('weight')??0,
      );
    }).toList();
  }*/



  /*Stream<List<UserData>> get userInfo{
    return userData.snapshots().map(_userDataFromSnapshot);
  }*/
/*
TrafficValues _trafficValuesFromSnapShot(DocumentSnapshot snapshot){
  return TrafficValues(
    fatGreen: snapshot.get('fG'),
    fatAmber: snapshot.get('fA'),
    satFatGreen: snapshot.get('sFG'),
    satFatAmber: snapshot.get('SFA'),
    sugarGreen: snapshot.get('sugG'),
    sugarAmber: snapshot.get('sugA'),
    saltGreen: snapshot.get('saltG'),
    saltAmber: snapshot.get('saltA'),
      );
}*/

  UserData _userDataFromSnapshotTwo(DocumentSnapshot snapshot){
    return UserData(
      //uid: uid,
      name: snapshot.get('name')??"",
      height: snapshot.get('height')??0,
      weight: snapshot.get('weight')??0,
    );
  }

 /* Future<TrafficValues> getMTL() async {
    DocumentSnapshot mtlSnapshot = await accountDetails.doc('MTL').get();
    Map<String, dynamic> mtlData = mtlSnapshot.data() as Map<String, dynamic>;
    TrafficValues trafficValues = TrafficValues(
        fatGreen: mtlData['fG'],
        fatAmber: mtlData['fA'],
        satFatGreen: mtlData['sFG'],
        satFatAmber: mtlData['sFA'],
        sugarGreen: mtlData['sugG'],
        sugarAmber: mtlData['sugA'],
        saltGreen: mtlData['saltG'],
        saltAmber: mtlData['saltA']);
    return trafficValues;
  }
  Stream<TrafficValues> getMTLStream() {
    return accountDetails.doc('MTL').snapshots().transform(
      StreamTransformer<DocumentSnapshot<Map<String, dynamic>>, TrafficValues>.fromHandlers(
        handleData: (snapshot, sink) {
          if (snapshot.exists) {
            Map<String, dynamic> mtlData = snapshot.data()!;
            TrafficValues trafficValues = TrafficValues(
              fatGreen: mtlData['fG'],
              fatAmber: mtlData['fA'],
              satFatGreen: mtlData['sFG'],
              satFatAmber: mtlData['sFA'],
              sugarGreen: mtlData['sugG'],
              sugarAmber: mtlData['sugA'],
              saltGreen: mtlData['saltG'],
              saltAmber: mtlData['saltA'],
            );
            sink.add(trafficValues);
          } else {
            sink.addError('Document does not exist');
          }
        },
        handleError: (error, stackTrace, sink) {
          sink.addError('An error occurred: $error');
        },
      ),
    );
  }*/

  /*Stream<TrafficValues> get getMTL2{
  return accountDetails.doc('MTL').snapshots().map(_trafficValuesFromSnapShot);
  }*/

  Stream<DocumentSnapshot> get userInformation{
    return userData.doc(uid).snapshots();
  }

  Stream<UserData> get userInfo{
    return accountDetails.doc('personal details').snapshots().map(_userDataFromSnapshotTwo);
  }


}