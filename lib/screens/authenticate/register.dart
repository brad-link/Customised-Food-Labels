import 'package:cfl_app/main.dart';
import 'package:cfl_app/screens/account_setup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/auth.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final Auth _auth = Auth();
  final _formKey = GlobalKey<FormState>();
    String email = "";
    String password = '';
    String error = '';
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Register'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            const Text(
              'Register',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                color: myColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Form(
                key: _formKey,
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
                      onChanged: (value) {
                        setState(() => email = value);
                      },
                        validator: (value) => value!.isEmpty ? "Enter an email" : null
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
                      onChanged: (value) {
                        setState(() => password = value);
                      },
                        validator: (value) => value!.length < 6 ? "Enter a password 6+ chars long" : null
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        //backgroundColor: Colors.green
                    ),
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        dynamic result = await _auth.registerWithEMailAndPassword(email, password);
                        if(result == null){
                          setState(() => error = 'invalid email address');
                        } else {
                          if(!mounted) return;
                          Navigator.of(
                            context).push(MaterialPageRoute(builder: (context) =>
                                const SetupForm()),
                          );
                        }

                      }
                    },
                    child: const Text(
                        'Register'
                    ),

                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 12.0),
                  )
                ],
              )),
            )
          ],
        ),
        ),
      );
    }
  }