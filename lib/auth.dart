import 'package:cfl_app/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'appUser.dart';

class Auth{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  AppUser? _userFromFireBaseUser(User? user){
    return user != null ? AppUser(uid: user.uid) : null;
  }

  //Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();
  Stream<AppUser?> get user{
    return firebaseAuth.authStateChanges().map(_userFromFireBaseUser);
        //.map((User? user) => _userFromFireBaseUser(user!));
  }

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



  Future registerWithEMailAndPassword(String email, String password) async{
    try{
      UserCredential credential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user= credential.user;
      await DatabaseService(uid: user!.uid).updateUserData('name', 0, 0);
      return _userFromFireBaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async{
    try{
      await firebaseAuth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }

}