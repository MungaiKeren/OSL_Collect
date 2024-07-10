import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wkwp_mobile/Components/MyDrawer.dart';
import 'package:wkwp_mobile/Components/ComponentRow.dart';
import 'package:wkwp_mobile/Components/TextResponse.dart';
import 'package:wkwp_mobile/Components/Utils.dart';
import 'package:wkwp_mobile/Pages/Home.dart';
import 'package:wkwp_mobile/Pages/RMF/Finance2.dart';
import 'package:wkwp_mobile/Pages/RMF/PolicyGov.dart';
import 'package:wkwp_mobile/Pages/RMF/RMFBasicDetails.dart';
import 'package:wkwp_mobile/Pages/RMF/RMFRuralUrban.dart';
import 'package:wkwp_mobile/Pages/RMF/SignOff.dart';
import 'package:wkwp_mobile/Pages/RMF/WRM2.dart';

class Components extends StatefulWidget {
  const Components({super.key});

  @override
  State<Components> createState() => _ComponentsState();
}

class _ComponentsState extends State<Components> {
  String name = 'Strong';
  String cost = '32,234';
  String? id = '';
  String error = '';

  late Image myimage;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final storage = const FlutterSecureStorage();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Future<void> getUserInfo() async {
    var token = await storage.read(key: "WKWPjwt");
    var decoded = parseJwt(token.toString());
    id = (await storage.read(key: "RMFID"));
    print("RMF FORM ID: $id");

    setState(() {
      name = decoded["Name"];
    });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'WKWP Components',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () => {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => const Home()))
                                  },
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "WKWP Components",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    TextResponse(
                      label: error,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              const RMFBasicDetails(), // Replace with the page you want to navigate to
                        ));
                      },
                      child: ComponentRow(
                        title: 'Basic Details',
                        myimage: Image.asset(
                          'assets/images/urbanwater.png',
                          width: 250, // Set the desired width
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        if (id == null) {
                          setState(() {
                            error =
                                'Basic Details Page Not Filled: Redirecting...';
                          });
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RMFBasicDetails()));
                          });
                        } else {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const RMFRuralUrban()));
                        }
                      },
                      child: ComponentRow(
                        title: 'Rural & Urban\nWater Services',
                        myimage: Image.asset(
                          'assets/images/ruralwater.png',
                          width: 250, // Set the desired width
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        if (id == null) {
                          setState(() {
                            error =
                                'Basic Details Page Not Filled: Redirecting...';
                          });
                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RMFBasicDetails()));
                          });
                        } else {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const Finance2()));
                        }
                      },
                      child: ComponentRow(
                        title: 'Finance &\n Governance',
                        myimage: Image.asset(
                          'assets/images/finance.png',
                          width: 250, // Set the desired width
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        if (id == null) {
                          setState(() {
                            error =
                                'Basic Details Page Not Filled: Redirecting...';
                          });
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RMFBasicDetails()));
                          });
                        } else {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const WRM2()));
                        }
                      },
                      child: ComponentRow(
                        title: 'Water Resource \n Management',
                        myimage: Image.asset(
                          'assets/images/management.png',
                          width: 250, // Set the desired width
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        if (id == null) {
                          setState(() {
                            error =
                                'Basic Details Page Not Filled: Redirecting...';
                          });
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RMFBasicDetails()));
                          });
                        } else {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const PolicyGov()));
                        }
                      },
                      child: ComponentRow(
                        title: 'Policy \n& Governance',
                        myimage: Image.asset(
                          'assets/images/finance.png',
                          width: 250, // Set the desired width
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        if (id == null) {
                          setState(() {
                            error =
                                'Basic Details Page Not Filled: Redirecting...';
                          });
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RMFBasicDetails()));
                          });
                        } else {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const SignOff()));
                        }
                      },
                      child: ComponentRow(
                        title: 'Sign Off',
                        myimage: Image.asset(
                          'assets/images/finance.png',
                          width: 250, // Set the desired width
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
