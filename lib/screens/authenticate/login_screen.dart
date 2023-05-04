
import 'package:cfl_app/screens/authenticate/register.dart';
import 'package:cfl_app/screens/home/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../components/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Auth _auth = Auth();
  final signInformKey = GlobalKey<FormState>();
  String email = "";
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          const Text(
            'Login',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: myColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Form(
              key: signInformKey,
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
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
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(
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
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async{
                    if(signInformKey.currentState!.validate()){
                      dynamic result = await _auth.signInWithEMailAndPassword(email, password);
                      if(result == null){
                        setState(() => error = 'invalid email or password');
                      } else {
                        if(!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              const HomeScreen(),
                          ),
                        );
                      }

                    }
                  },
                  child: Text(
                      'Login'
                  ),

                ),
                const SizedBox(height: 30),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 12.0),
                ),
                TextButton(

                  onPressed: () async{
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Register()),
                    );
                  },
                  child: const Text(
                      "Don't have an account?\nregister here",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      decoration: TextDecoration.underline
                    ),
                  ),

                ),
              ],
            )),
          )
        ],
      ),
      ),
    );
  }
}
