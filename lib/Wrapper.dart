

import 'package:cfl_app/DataClasses/appUser.dart';
import 'package:cfl_app/screens/home/default_homescreen.dart';
import 'package:cfl_app/screens/home/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user ==  null){
      return const DefaultHomeScreen();
    } else{
      return const HomeScreen();
    }
  }

}