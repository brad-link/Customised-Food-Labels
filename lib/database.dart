import 'dart:async';

import 'package:cfl_app/userData.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});
  final CollectionReference userData = FirebaseFirestore.instance.collection('UserData');

  Future updateUserData(String? name, num? height, num? weight) async{
    var data ={
      'name': name,
      'height': height,
      'weight': weight,
    };
    return await userData.doc(uid).set(data);
  }

  Stream<QuerySnapshot> get user{
    return userData.snapshots();
  }
  List<UserData> _userDataFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return UserData(
        name: doc.get('name')??"",
        height: doc.get('height')??0,
        weight: doc.get('weight')??0,
      );
    }).toList();
  }



  /*Stream<List<UserData>> get userInfo{
    return userData.snapshots().map(_userDataFromSnapshot);
  }*/



  UserData _userDataFromSnapshotTwo(DocumentSnapshot snapshot){
    return UserData(
      //uid: uid,
      name: snapshot.get('name')??"",
      height: snapshot.get('height')??0,
      weight: snapshot.get('weight')??0,
    );
  }

  Stream<DocumentSnapshot> get userInformation{
    return userData.doc(uid).snapshots();
  }

  Stream<UserData> get userInfo{
    return userData.doc(uid).snapshots().map(_userDataFromSnapshotTwo);
  }


}