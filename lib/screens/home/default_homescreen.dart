import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../authenticate/login_screen.dart';
import 'default_scanner.dart';

class DefaultHomeScreen extends StatefulWidget {
  const DefaultHomeScreen({Key? key}) : super(key: key);

  @override
  State<DefaultHomeScreen> createState() => _DefaultHomeScreenState();
}

class _DefaultHomeScreenState extends State<DefaultHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutriMate'),
        centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
      PopupMenuButton<int>(itemBuilder: (context) => [
      PopupMenuItem(
      value: 1,
      child: Row(
        children: const [
          Text("Sign in")
        ],
      ),
    ),
    ],
        onSelected: (value){
          if (value== 1){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          }
        },
        icon: const Icon(Icons.account_circle,
          color: Colors.white,
          size: 28.0,
        ),
      ),
          ],
      ),
        body: Builder(
        builder: (BuildContext context){
          return Container(
          alignment: Alignment.center,
              child:Padding(
            padding: const EdgeInsets.all(12),
            child: DefaultScanner(scanButton: (){}, displayButton: () {  },),
          ),
          );
    }
        ),
    );
  }
}
