import 'dart:async';
import 'dart:ui';

import 'package:cfl_app/TrafficValues.dart';
import 'package:cfl_app/components/dietLog.dart';
import 'package:cfl_app/components/nutritionGoals.dart';
import 'package:cfl_app/product.dart';
import 'package:cfl_app/storedProduct.dart';
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
    productDetails = userDocRef.collection("products");
  }
  late final CollectionReference userData;
  // = FirebaseFirestore.instance.collection("User Data");
  //final CollectionReference mtlValues = FirebaseFirestore.instance.collection("User Data");
  final CollectionReference users =
      FirebaseFirestore.instance.collection("Users");
  late final DocumentReference userDocRef;
  late final CollectionReference accountDetails;
  late final CollectionReference nutritionDetails;
  late final CollectionReference productDetails;

  Future updateUserData(String? name, num? height, num? weight) async {
    return await accountDetails.doc("personal details").set({
      'name': name,
      'height': height,
      'weight': weight,
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

  Future createLog(DietLog entry) async {
    String date = DateFormat('dd-MM-yyyy').format(entry.date);
    print('Database $date');
    //final date = entry?.date as String;
    return await nutritionDetails.doc(date).set(entry.toFirestore());
  }

  //Future<DietLog> getEntry() async {}


  Stream<List<DietLog>> get nutritionTracker {
    return nutritionDetails.orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
    .map((doc) => DietLog.fromFirestore(doc)).toList());
        //.map(_foodTracker);
  }
  Future setNutritionGoals(NutritionGoals goals) async{
    return await accountDetails.doc('Nutrition goals').set(goals.toFirestore());
  }

  Future updateLog(DietLog entry) async{
    String date = DateFormat('dd-MM-yyyy').format(entry.date);
    return await nutritionDetails.doc(date).update({
      "calories": FieldValue.increment(entry.calories),
      "fat": FieldValue.increment(entry.fat),
      "saturates": FieldValue.increment(entry.saturates),
      "carbohydrates": FieldValue.increment(entry.carbohydrates),
      "sugars": FieldValue.increment(entry.sugars),
      "protein": FieldValue.increment(entry.protein),
      "salt": FieldValue.increment(entry.salt),
    }
    );
  }

  Future addProduct(Product product) async {
    return await productDetails.doc(product.productID).set(product.toFirestore());
  }

  Future<NutritionGoals?> getNutritionGoals() async {
    final nutritionRef = accountDetails.doc('Nutrition goals').withConverter(
      fromFirestore: NutritionGoals.fromFirestore,
      toFirestore: (NutritionGoals values, _) => values.toFirestore(),
    );
    final docSnap = await nutritionRef.get();

    return docSnap.data();
  }

  Stream<NutritionGoals?> getGoals() {
    final ref = accountDetails.doc('Nutrition goals').withConverter(
      fromFirestore: NutritionGoals.fromFirestore,
      toFirestore: (NutritionGoals values, _) => values.toFirestore(),
    );
    return ref.snapshots().map((doc) => doc.data()).handleError((error) {
      print('Error getting Nutrition goals stream: $error');
    });
  }
/*
  Stream<Product?> getProduct() {
    final ref = accountDetails.doc('Nutrition goals').withConverter(
      fromFirestore: Product.fromFirestore,
      toFirestore: (Product values, _) => values.toFirestore(),
    );
    return ref.snapshots().map((doc) => doc.data()).handleError((error) {
      print('Error getting Nutrition goals stream: $error');
    });
  }*/

  Stream<List<Product>> getDailyProducts(DateTime date) {
    String day = DateFormat('dd/MM/yyyy').format(date);
    return productDetails
        .where('dateAdded',isEqualTo: day)
        .orderBy('timeAdded', descending: false)
        .snapshots()
        .map((QuerySnapshot querysnapshot){
          return querysnapshot.docs.map((DocumentSnapshot doc){
            return Product.fromFirestore(doc);
          }).toList();
    });
    //.map(_foodTracker);
  }
  Stream<List<Product>> getSavedProducts() {
    List<Product> products = [];
    List<String?> names = [];
    return productDetails
        .snapshots()
        .map((QuerySnapshot querysnapshot){
      for(var doc in querysnapshot.docs){
        Product product = Product.fromFirestore(doc);
        String? productName = product.productName;
        if(!names.contains(productName)){
          names.add(productName);
          products.add(product);
        }
      }
      return products;
    });
  }
  /*
  Future<List<Product>> getSavedProductsFuture() async {
    final snapshot = await productDetails.get();
    final products = snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    return products;
  }*/
  Future<List<Product>> getSavedProductsFuture() async {
    final snapshot = await productDetails.get();
    List<Product> products = [];
    List<String?> names = [];
    for (var doc in snapshot.docs) {
      Product product = Product.fromFirestore(doc);
      String? productName = product.productName;
      if(!names.contains(productName)){
        names.add(productName);
        products.add(product);
      }
      }
    return products;
    }



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
