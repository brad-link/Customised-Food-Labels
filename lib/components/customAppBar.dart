import 'package:flutter/material.dart';

import '../auth.dart';
import '../screens/home/settings_form.dart';
import '../traffic_settings.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget{
  final String title;
  final IconButton? calendar;
  final bool backButton;
  const CustomAppBar({Key? key, required this.title, this.calendar, required this.backButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Auth _auth = Auth();
    void _showSettings(){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: const SettingsForm(),
        );
      });
    }
    void nutritionSettings(){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          //child: const TrafficSheet(),
        );
      });
    }
    return AppBar(
      leading: calendar,
      title:  Text('$title'),
      centerTitle: true,
      automaticallyImplyLeading: backButton,
      //backgroundColor: Colors.green,
      actions: [
        PopupMenuButton<int>(itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Row(
              children: [
                Text("Account settings")
              ],
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Row(
              children: [
                Text("update nutrition preferences")
              ],
            ),
          ),
          PopupMenuItem(
            value: 3,
            child: Row(
              children: [
                Text("Sign out")
              ],
            ),
          ),
        ],
          onSelected: (value) async{
            if (value==1){
              _showSettings();
            }
            if (value==2){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TrafficSettings()),
              );
              //nutritionSettings();
            }
            if(value== 3){
              await _auth.signOut();
            }
          },
          icon: Icon(Icons.account_circle,
            color: Colors.white,
            size: 28.0,
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
