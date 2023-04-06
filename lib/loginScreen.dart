
import 'package:cfl_app/screens/authenticate/register.dart';
import 'package:cfl_app/screens/home/home.dart';
import 'package:cfl_app/screens/home/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Auth _auth = Auth();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: false,
        backgroundColor: Colors.green,
      ),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Login',
            style: TextStyle(
                fontSize: 35,
                color: Colors.blue,
                fontWeight: FontWeight.bold
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Form(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value){
                      setState(() => email = value);

                    },
                    validator: (value) => value!.isEmpty ? "Enter an email" : null,
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter password',
                      prefixIcon: Icon(Icons.password),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    onChanged: (value){
                      setState(() => password = value);

                    },
                      validator: (value) => value!.length < 6 ? "Enter a password 6+ chars long" : null
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green
                  ),
                  onPressed: () async{
                    if(_formKey.currentState!.validate()){
                      dynamic result = await _auth.signInWithEMailAndPassword(email, password);
                      if(result == null){
                        setState(() => error = 'invalid email or password');
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              HomeScreen(),
                          ),
                        );
                      }

                    }
                  },
                  child: Text(
                      'Login'
                  ),

                ),
                SizedBox(height: 30),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 12.0),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green
                  ),
                  onPressed: () async{
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Register()),
                    );
                  },
                  child: Text(
                      'Register'
                  ),

                ),
              ],
            )),
          )
        ],
      ),
    );
  }
}
