// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wkwp_mobile/Components/Utils.dart';
import 'package:wkwp_mobile/Pages/Home.dart';
import 'package:wkwp_mobile/Pages/Login.dart';
import 'package:wkwp_mobile/Pages/scrollscreen.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = const FlutterSecureStorage();

  Future<void> isFirstTime() async {
    String? firstTime = await storage.read(key: "firstTime");

    if (firstTime != "firstTime") {
      await storage.write(key: "firstTime", value: "firstTime");
     
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const ScrollScreen()));
    } else {
      authenticateUser();
    }
  }

  Future<void> authenticateUser() async {
    var token = await storage.read(key: "WKWPjwt");
    var decoded = parseJwt(token.toString());
       if (decoded["error"] == "Invalid token") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Login()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Home()));
    }
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      isFirstTime();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Landing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromRGBO(3, 48, 110, 1),
              Color.fromRGBO(0, 96, 177, 1)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Column(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(48, 24, 48, 0),
                      child: Container(
                        color: Colors.white,
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 200, // Set the desired width
                        ),
                      ),
                    ),
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
