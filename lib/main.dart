
import 'package:cfl_app/Wrapper.dart';
import 'package:cfl_app/DataClasses/appUser.dart';
import 'package:cfl_app/components/auth.dart';
import 'package:cfl_app/screens/authenticate/login_screen.dart';
import 'package:cfl_app/screens/authenticate/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'nutritionInfo.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:firebase_core/firebase_core.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //debugPaintSizeEnabled = true;
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  runApp(MyApp());
}

const myColor = Color(0xFF7B6AF2);




class MyApp extends StatelessWidget {
  final Future<FirebaseApp> cflApp = Firebase.initializeApp();

   MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const defaultText = TextStyle(
      fontFamily: 'Fig-tree',
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    );
    return StreamProvider<AppUser?>.value(
      initialData: null,
      value: Auth().user,
      child: MaterialApp(
        theme: ThemeData(
          textTheme: TextTheme(
            bodyMedium: defaultText,
            bodyLarge: defaultText,
            bodySmall: defaultText,
            titleLarge: defaultText.copyWith(fontSize: 24),
            titleMedium: defaultText.copyWith(fontSize: 20)
          ),
          colorScheme: const ColorScheme(
            primary: myColor,
            onPrimary: Colors.white,
            secondary: myColor,
            onSecondary: Colors.white,
            background: Colors.white,
            onBackground: Colors.black,
            surface: Colors.grey,
            onSurface: Colors.black,
            brightness: Brightness.light,
            error: myColor,
            onError: myColor,
          ),

        ),
          debugShowCheckedModeBanner: false,
        home: Wrapper()
        // BarcodeScanner()
      ),
    );
  }
}

