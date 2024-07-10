import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wkwp_mobile/Components/MyDrawer.dart';
import 'package:wkwp_mobile/Components/MyRow.dart';
import 'package:wkwp_mobile/Components/MyRowII.dart';
import 'package:wkwp_mobile/Components/MyRowIII.dart';
import 'package:wkwp_mobile/Components/UserContainer.dart';
import 'package:wkwp_mobile/Components/Utils.dart';
import 'package:wkwp_mobile/Pages/ARF/ARF.dart';
import 'package:wkwp_mobile/Pages/Components.dart';
import 'package:wkwp_mobile/Pages/CustomForms.dart';
import 'package:wkwp_mobile/Pages/TAF/TAF.dart';
import 'package:wkwp_mobile/Pages/WorkPlans.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late StreamSubscription<Position> positionStream;

  bool servicestatus = false;
  late LocationPermission permission;
  bool haspermission = false;
  late Position position;

  String name = '';
  String cost = '32,234';
  String workplan = '';
  String rmf = '';
  String arf = '';
  String taf = '';

  var long = 36.0, lat = -2.0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final storage = const FlutterSecureStorage();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      long = position.longitude;
      lat = position.latitude;
    });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    );
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      setState(() {
        long = position.longitude;
        lat = position.latitude;
      });
    });
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        } else if (permission == LocationPermission.deniedForever) {
          permission = await Geolocator.requestPermission();
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        getLocation();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Location is required! You will be logged out. Please turn on your location"),
      ));
    }
  }

  Future<void> fetchStats(String id) async {
    try {
      final dynamic response;

      response = await http.get(
        Uri.parse("${getUrl()}home/mobile/stats/$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var data = json.decode(response.body);
      print("stats $data");
      setState(() {
        workplan = data["workplan"].toString();
        rmf = data["rmf"].toString();
        arf = data["arf"].toString();
        taf = data["taf"].toString();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUserInfo() async {
    var token = await storage.read(key: "WKWPjwt");
    var decoded = parseJwt(token.toString());

    setState(() {
      name = decoded["Name"];
    });
    print("decoded: $decoded");
    await fetchStats(decoded["UserID"]);
  }

  @override
  void initState() {
    checkGps();
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MyDrawer(),
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
        padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _openDrawer,
                      child: Image.asset(
                        'assets/images/menuicon.png',
                        width: 24,
                      ),
                    ),
                    UserContainer(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello, $name!",
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Welcome to MEL-MIS Data Collection App",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 250, 246, 246),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const WorkPlan(),
                            ));
                          },
                          child: MyRow(
                            no: workplan,
                            title: 'Work Plan',
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const CustomForms(),
                            ));
                          },
                          child: const MyRowII(
                            title: 'My Forms',
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const TAF(),
                                  ));
                                },
                                child: MyRowIII(
                                  no: taf,
                                  title: 'TAF',
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const ARF(),
                                  ));
                                },
                                child: MyRowIII(
                                  no: arf,
                                  title: 'ARF',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const Components(),
                                  ));
                                },
                                child: MyRowIII(
                                  no: rmf,
                                  title: 'RMF',
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
