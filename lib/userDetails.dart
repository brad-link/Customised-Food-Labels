import 'package:cfl_app/userData.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<List<UserData>>(context);
    userData.forEach((i){
      print(i.name);
      print(i.weight);
      print(i.height);
    });
    return const Placeholder();
  }
}
