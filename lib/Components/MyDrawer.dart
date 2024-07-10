// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wkwp_mobile/Components/ChangePasswordDialog.dart';
import 'package:wkwp_mobile/Components/FootNote.dart';
import 'package:wkwp_mobile/Pages/ARF/ARFList.dart';
import 'package:wkwp_mobile/Pages/Home.dart';
import 'package:wkwp_mobile/Pages/Login.dart';
import 'package:wkwp_mobile/Pages/Privacy.dart';
import 'package:wkwp_mobile/Pages/RMF/RMFList.dart';
import 'package:wkwp_mobile/Pages/TAF/TAFList.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  TextStyle style = const TextStyle(
      color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
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
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                  )),
                ],
              ),
            ),
            Flexible(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                children: [
                  const Text(
                    'Menu',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const Home()));
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              'Home',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => const TAFList()));
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              'Technical Assistance Forms',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => const ARFList()));
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              'Activity Registration Forms',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const RMFList()));
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              'Results Monitoring Forms',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                         const SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const Privacy()));
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              'Privacy Policy',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const ChangePasswordDialog();
                              },
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              'Settings',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            const store = FlutterSecureStorage();
                            store.deleteAll();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const Login()));
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Align(alignment: Alignment.bottomLeft, child: FootNote())
          ],
        ),
      ),
    );
  }
}
