import 'dart:async';
import 'dart:core';
import 'dart:ui';

import 'package:cfl_app/DataClasses/TrafficValues.dart';
import 'package:cfl_app/DataClasses/dietLog.dart';
import 'package:cfl_app/DataClasses/nutritionGoals.dart';
import 'package:cfl_app/DataClasses/product.dart';
import 'package:cfl_app/userData.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  String? uid;

  DatabaseService({
    this.uid,
  }) {
    userData = FirebaseFirestore.instance.collection('Users');
    userDocRef = userData.doc(uid);
    accountDetails = userDocRef.collection("account");
    nutritionDetails = userDocRef.collection("nutrition");
    productDetails = userDocRef.collection("products");
    productDB = FirebaseFirestore.instance.collection('Products');
  }

  late final CollectionReference userData;
  final CollectionReference users =
  FirebaseFirestore.instance.collection("Users");
  late final DocumentReference userDocRef;
  late final CollectionReference accountDetails;
  late final CollectionReference nutritionDetails;
  late final CollectionReference productDetails;
  late final CollectionReference productDB;


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

  Stream<TrafficValues?> getMTLStream() {
    final ref = accountDetails.doc('MTL').withConverter(
      fromFirestore: TrafficValues.fromFirestore,
      toFirestore: (TrafficValues values, _) => values.toFirestore(),
    );
    return ref.snapshots().map((doc) => doc.data()).handleError((error) {
      if (kDebugMode) {
        print('Error getting MTL stream: $error');
      }
    });
  }

  Future updateUser(UserData user) async {
    return await accountDetails.doc('personal details').set(user.toFirestore());
  }

  Stream<UserData?> getUser() {
    final ref = accountDetails.doc('personal details').withConverter(
      fromFirestore: UserData.fromFirestore,
      toFirestore: (UserData values, _) => values.toFirestore(),
    );
    return ref.snapshots().map((doc) => doc.data()).handleError((error) {
      print('Error getting MTL stream: $error');
    });
  }

  Future<UserData?> getUserData() async {
    final ref = accountDetails.doc('personal details').withConverter(
      fromFirestore: UserData.fromFirestore,
      toFirestore: (UserData values, _) => values.toFirestore(),
    );
    final docSnap = await ref.get();

    return docSnap.data();
  }

  Future<TrafficValues?> getMTL() async {
    final mtlDocRef = accountDetails.doc('MTL').withConverter(
      fromFirestore: TrafficValues.fromFirestore,
      toFirestore: (TrafficValues values, _) => values.toFirestore(),
    );
    final docSnap = await mtlDocRef.get();

    return docSnap.data();
  }


  Future createLog(DietLog entry) async {
    String date = DateFormat('dd-MM-yyyy').format(entry.date);
    return await nutritionDetails.doc(date).set(entry.toFirestore());
  }


  Stream<List<DietLog>> get nutritionTracker {
    return nutritionDetails.orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs
            .map((doc) => DietLog.fromFirestore(doc)).toList());
  }

  Future setNutritionGoals(NutritionGoals goals) async {
    return await accountDetails.doc('Nutrition goals').set(goals.toFirestore());
  }

  Future updateLog(DietLog entry) async {
    String date = DateFormat('dd-MM-yyyy').format(entry.date);
    return await nutritionDetails.doc(date).update({
      "calories": FieldValue.increment(entry.calories ?? 0),
      "fat": FieldValue.increment(entry.fat ?? 0),
      "saturates": FieldValue.increment(entry.saturates ?? 0),
      "carbohydrates": FieldValue.increment(entry.carbohydrates ?? 0),
      "sugars": FieldValue.increment(entry.sugars ?? 0),
      "protein": FieldValue.increment(entry.protein ?? 0),
      "salt": FieldValue.increment(entry.salt ?? 0),
    }
    );
  }

  addProductToMeal(Product product, String meal) async {
    return await nutritionDetails.doc(product.dateAdded).collection('food').doc(
        meal).set(product.toFirestore());
  }

  addProduct(Product product) async {
    return await productDetails.doc(product.productID).set(
        product.toFirestore());
  }

  Future productsList(Product product) async {
    return await productDB.doc(product.productName).set(product.toFirestore());
  }

  removeProductFromDay(Product product, DateTime date) async {
    String day = DateFormat('dd-MM-yyyy').format(date);
    await nutritionDetails.doc(day).update({
      "calories": FieldValue.increment(-product.calories!),
      "fat": FieldValue.increment(-product.fat!),
      "saturates": FieldValue.increment(-product.satFat!),
      "carbohydrates": FieldValue.increment(-product.carbs!),
      "sugars": FieldValue.increment(-product.sugar!),
      "protein": FieldValue.increment(-product.protein!),
      "salt": FieldValue.increment(-product.salt!),
    });
    await productDetails.doc(product.productID).delete();
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

  Stream<List<Product>> getDailyProducts(DateTime date) {
    String day = DateFormat('dd/MM/yyyy').format(date);
    return productDetails
        .where('dateAdded', isEqualTo: day)
        .orderBy('timeAdded', descending: false)
        .snapshots()
        .map((QuerySnapshot querysnapshot) {
      return querysnapshot.docs.map((DocumentSnapshot doc) {
        return Product.fromFirestore(doc);
      }).toList();
    });
  }

  Stream<List<Product>> getUsersSavedProducts() {
    List<Product> products = [];
    List<String?> names = [];
    return productDetails
        .snapshots()
        .map((QuerySnapshot querysnapshot) {
      for (var doc in querysnapshot.docs) {
        Product product = Product.fromFirestore(doc);
        String? productName = product.productName;
        if (!names.contains(productName)) {
          names.add(productName);
          products.add(product);
        }
      }
      return products;
    });
  }

  Stream<List<Product>> getDBProducts() {
    List<Product> products = [];
    return productDB
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Product product = Product.fromFirestore(doc);
        products.add(product);
      }
      return products;
    });
  }

  Future <List<Product>> getUsersProductsFuture() async {
    final snapshot = await productDetails.get();
    List<Product> products = [];
    List<String?> names = [];
    for (var doc in snapshot.docs) {
      Product product = Product.fromFirestore(doc);
      String? productName = product.productName;
      if (!names.contains(productName)) {
        names.add(productName);
        products.add(product);
      }
    }
    return products;
  }

  Future<List<Product>> getSavedProductsFuture() async {
    final snapshot = await productDB.get();
    List<Product> products = [];
    for (var doc in snapshot.docs) {
      Product product = Product.fromFirestore(doc);
      products.add(product);
    }
    return products;
  }
}

