

import 'package:cfl_app/appUser.dart';
import 'package:cfl_app/auth.dart';
import 'package:cfl_app/screens/authenticate/barcodeScanner.dart';
import 'package:cfl_app/screens/home/home.dart';
import 'package:cfl_app/screens/home/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user ==  null){
      return BarcodeScanner();
    } else{
      return HomeScreen();
    }
  }

}