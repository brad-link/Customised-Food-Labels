import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../DataClasses/appUser.dart';
import 'database.dart';
import '../screens/settings_form.dart';
import '../traffic_settings.dart';
import '../DataClasses/userData.dart';
import 'auth.dart';

//custom app bar used when someone is logged in
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget{
  final String title;
  final IconButton? calendar;
  final bool backButton;
  const CustomAppBar({Key? key, required this.title, this.calendar, required this.backButton}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize =>  const Size.fromHeight(kToolbarHeight);
}


class _CustomAppBarState extends State<CustomAppBar> {
  AppUser? user;
  StreamController<UserData> userStream = StreamController<UserData>();
  final Auth auth = Auth();
  UserData? userData;
  
  @override
  void initState() {
    super.initState();
    user = Provider.of<AppUser?>(context, listen: false);
    DatabaseService(uid: user?.uid).getUser().listen((event) {
      userData = event;
    });
    //setUser();
  }
  void setUser() async{
    //userData = await DatabaseService(uid: user?.uid).getUserData();
  }
  
  @override
  Widget build(BuildContext context) {


    return AppBar(
      leading: widget.calendar,
      title:  Text(widget.title),
      centerTitle: true,
      automaticallyImplyLeading: widget.backButton,
      actions: [
        //menu button to launch different settings screens and sign out
        PopupMenuButton<int>(itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Row(
              children: const [
                Text("Account settings")
              ],
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Row(
              children: const [
                Text("update Traffic Light values")
              ],
            ),
          ),
          PopupMenuItem(
            value: 4,
            child: Row(
              children: const [
                Text("Sign out")
              ],
            ),
          ),
        ],
          onSelected: (value) async{
            if (value==1){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsForm(userData: userData)),
              );
            }
            if (value==2){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TrafficSettings()),
              );
            }
            if(value== 4){
              await auth.signOut();
            }
          },
          icon: const Icon(Icons.account_circle,
            color: Colors.white,
            size: 28.0,
          ),
        ),
      ],
    );
  }
}
