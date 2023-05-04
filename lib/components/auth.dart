import 'package:cfl_app/DataClasses/TrafficValues.dart';
import 'package:cfl_app/DataClasses/dietLog.dart';
import 'package:cfl_app/database.dart';
import 'package:cfl_app/userData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../DataClasses/appUser.dart';
import 'dart:core';

import '../database.dart';
import '../DataClasses/dietLog.dart';

//auth class for handling firebase authorisation
class Auth{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  AppUser? _userFromFireBaseUser(User? user){
    return user != null ? AppUser(uid: user.uid) : null;
  }
  //Stream to check if if user is logged in or out
  Stream<AppUser?> get user{
    return firebaseAuth.authStateChanges().map(_userFromFireBaseUser);
  }

  //sign in with email and password
  Future signInWithEMailAndPassword(String email, String password) async{
    try{
      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user= credential.user;
      return _userFromFireBaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //registers user with email and password
  //creates 7 days worth of DietLogs in the database
  //creates default traffic light values and uploads them to database
  Future registerWithEMailAndPassword(String email, String password) async{
    try{
      UserCredential credential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user= credential.user;
      DateTime now = DateTime.now();
      DateTime date = DateTime(now.year, now.month, now.day);
      DateTime addDays = date.subtract(const Duration(days: 7));
      DateTime yesterday = date.subtract(const Duration(days: 1));
      DietLog previousDay = DietLog(date: yesterday);
      DietLog firstEntry = DietLog(date: date);
      for(int i=0; i<7; i++){
        DateTime day = addDays.add(const Duration(days: 1));
        DietLog newEntry = DietLog(date: day);
        await DatabaseService(uid: user?.uid).createLog(newEntry);
      }
      //await DatabaseService(uid: user?.uid).createLog(previousDay);
      //await DatabaseService(uid: user?.uid).createLog(firstEntry);
      UserData userData = UserData(custom: false);
      await DatabaseService(uid: user?.uid)
          .updateUser(userData);
      await DatabaseService(uid: user?.uid).setMTL(TrafficValues());
      return _userFromFireBaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //signs user out
  Future<void> signOut() async{
    try{
      await firebaseAuth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }

}