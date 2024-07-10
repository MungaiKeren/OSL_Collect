// ignore_for_file: use_build_context_synchronously, non_constant_identifier_villages, unused_import

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wkwp_mobile/Components/MyDrawer.dart';
import 'package:wkwp_mobile/Components/MyMap.dart';
import 'package:wkwp_mobile/Components/MyTextButton.dart';
import 'package:wkwp_mobile/Components/MyTextInput.dart';
import 'package:wkwp_mobile/Pages/ARF/SubmitButton.dart';
import 'package:wkwp_mobile/Components/TextResponse.dart';
import 'package:wkwp_mobile/Components/TextSmall.dart';
import 'package:wkwp_mobile/Components/UserContainer.dart';
import 'package:wkwp_mobile/Components/Utils.dart';
import 'package:wkwp_mobile/Pages/Components.dart';
import 'package:wkwp_mobile/Pages/Home.dart';
import 'package:http/http.dart' as http;

class PolicyGov extends StatefulWidget {
  const PolicyGov({super.key});

  @override
  State<PolicyGov> createState() => _PolicyGovState();
}

class _PolicyGovState extends State<PolicyGov> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final storage = const FlutterSecureStorage();

  String error = '';

  String policies = '';
  String cidpsdeveloped = '';
  String hrpolicies = '';

  String propoorpolicies = '';
  String meteringpolicies = '';
  String climatepolicies = '';
  String seweragepolicies = '';
  String marketingpolicies = '';
  String strategicplans = '';
  String businesspolicies = '';
  String watersafetypolicies = '';
  String financepolicies = '';
  String pippolicies = '';
  String waterandsanitationact = '';
  String newmanuals = '';
  String operationsandmaintenance = '';
  String servicecharter = '';
  String sanctions = '';
  String officialstrained = '';
  var myData = null;

  String? editing = '';
  String? id = '';

  var isLoading;

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  prefillForm(String? id) async {
    setState(() {
      isLoading = LoadingAnimationWidget.horizontalRotatingDots(
        color: const Color.fromARGB(248, 186, 12, 47),
        size: 100,
      );
    });

    try {
      final response = await http
          .get(Uri.parse("${getUrl()}rmf/$id"), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

      var data = json.decode(response.body);

      print("mydata $data");

      setState(() {
        myData = data;
        isLoading = null;
      });
    } catch (e) {
      setState(() {
        isLoading = null;
      });
    }
  }

  checkEditing() async {
    var myId = await storage.read(key: "RMFID");
    var edit = await storage.read(key: "Editing");

    setState(() {
      id = myId;
      editing = edit;
    });

    print('$editing, $id');

    if (editing == 'True' || id != null) {
      print("prefilling form");
      prefillForm(id);
    } else {
      print("mapping new");
    }
  }

  @override
  void initState() {
    checkEditing();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MyDrawer(),
      body: Stack(
        children: [
          Container(
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () => {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const Components()))
                              },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                    ),
                    const Text(
                      "RMF - Policy & Governance",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    MyTextInput(
                        lines: 1,
                        value: myData != null
                            ? myData["PG_ProPoorPolicies_Developed"].toString()
                            : "",
                        type: const TextInputType.numberWithOptions(
                            decimal: false),
                        onSubmit: (value) {
                          setState(() {
                            propoorpolicies = value;
                          });
                        },
                        title: "Pro Poor Policies developed/reviewed"),
                    MyTextInput(
                        lines: 1,
                        value: myData != null
                            ? myData["PG_MeteringPolicies_Developed"].toString()
                            : "",
                        type: const TextInputType.numberWithOptions(
                            decimal: false),
                        onSubmit: (value) {
                          setState(() {
                            meteringpolicies = value;
                          });
                        },
                        title: "Metering Policies developed/reviewed"),
                    MyTextInput(
                        lines: 1,
                        value: myData != null
                            ? myData["PG_Sewerage_Policy"].toString()
                            : "",
                        type: const TextInputType.numberWithOptions(
                            decimal: false),
                        onSubmit: (value) {
                          setState(() {
                            seweragepolicies = value;
                          });
                        },
                        title: "Sewerage Policies Developed"),
                    MyTextInput(
                        lines: 1,
                        value: myData != null
                            ? myData["PG_ClimateChangePolicies_Developed"]
                                .toString()
                            : "",
                        type: const TextInputType.numberWithOptions(
                            decimal: false),
                        onSubmit: (value) {
                          setState(() {
                            climatepolicies = value;
                          });
                        },
                        title: "Climate Change Policies developed/reviewed"),
                    MyTextInput(
                        lines: 1,
                        value: myData != null
                            ? myData["PG_MarketingPolicies_Developed"]
                                .toString()
                            : "",
                        type: const TextInputType.numberWithOptions(
                            decimal: false),
                        onSubmit: (value) {
                          setState(() {
                            marketingpolicies = value;
                          });
                        },
                        title: "Marketing Policies developed/reviewed"),
                    MyTextInput(
                        lines: 1,
                        value: myData != null
                            ? myData["PG_Strategic_Plan"].toString()
                            : "",
                        type: const TextInputType.numberWithOptions(
                            decimal: false),
                        onSubmit: (value) {
                          setState(() {
                            strategicplans = value;
                          });
                        },
                        title: "Strategic Plans developed/reviewed"),
                    MyTextInput(
                        lines: 1,
                        value: myData != null
                            ? myData["PG_BusinessPlans_Developed"].toString()
                            : "",
                        type: const TextInputType.numberWithOptions(
                            decimal: false),
                        onSubmit: (value) {
                          setState(() {
                            businesspolicies = value;
                          });
                        },
                        title: "Number of Business Plans developed/reviewed"),
                    MyTextInput(
                        lines: 1,
                        value: myData != null
                            ? myData["PG_WaterSafetyPlan_Developed"].toString()
                            : "",
                        type: const TextInputType.numberWithOptions(
                            decimal: false),
                        onSubmit: (value) {
                          setState(() {
                            watersafetypolicies = value;
                          });
                        },
                        title: "Water Safety Plans developed/reviewed"),
                    MyTextInput(
                        lines: 1,
                        value: myData != null
                            ? myData["PG_Finance_Policy"].toString()
                            : "",
                        type: const TextInputType.numberWithOptions(
                            decimal: false),
                        onSubmit: (value) {
                          setState(() {
                            financepolicies = value;
                          });
                        },
                        title: "Finance Policies developed/reviewed"),
                    MyTextInput(
                        lines: 1,
                        value: myData != null
                            ? myData["PG_PIPs_Developed"].toString()
                            : "",
                        type: const TextInputType.numberWithOptions(
                            decimal: false),
                        onSubmit: (value) {
                          setState(() {
                            pippolicies = value;
                          });
                        },
                        title: "PIPs developed/reviewed"),
                    MyTextInput(
                      lines: 1,
                      value: myData != null
                          ? myData["PG_CIDP_Developed"].toString()
                          : "",
                      type:
                          const TextInputType.numberWithOptions(decimal: false),
                      onSubmit: (value) {
                        setState(() {
                          cidpsdeveloped = value;
                        });
                      },
                      title: 'CIDPs developed/reviewed',
                    ),
                    MyTextInput(
                      lines: 1,
                      value: myData != null
                          ? myData["PG_HR_Policy"].toString()
                          : "",
                      type:
                          const TextInputType.numberWithOptions(decimal: false),
                      onSubmit: (value) {
                        setState(() {
                          hrpolicies = value;
                        });
                      },
                      title: 'HR Policies developed/reviewed',
                    ),
                    MyTextInput(
                      lines: 1,
                      value: myData != null
                          ? myData["PG_WaterSanitationAct_Developed"].toString()
                          : "",
                      type:
                          const TextInputType.numberWithOptions(decimal: false),
                      onSubmit: (value) {
                        setState(() {
                          waterandsanitationact = value;
                        });
                      },
                      title: 'Water and Sanitation Acts developed/reviewed',
                    ),
                    MyTextInput(
                      lines: 1,
                      value: myData != null
                          ? myData["PG_NRWManual_Developed"].toString()
                          : "",
                      type:
                          const TextInputType.numberWithOptions(decimal: false),
                      onSubmit: (value) {
                        setState(() {
                          newmanuals = value;
                        });
                      },
                      title: 'NRW Manuals developed/reviewed',
                    ),
                    MyTextInput(
                      lines: 1,
                      value: myData != null
                          ? myData["PG_Operations_Maintenance"].toString()
                          : "",
                      type:
                          const TextInputType.numberWithOptions(decimal: false),
                      onSubmit: (value) {
                        setState(() {
                          operationsandmaintenance = value;
                        });
                      },
                      title:
                          'Operations and Maintenance Policies Developed/reviewed',
                    ),
                    MyTextInput(
                      lines: 1,
                      value: myData != null
                          ? myData["PG_ServiceCharter_Developed"].toString()
                          : "",
                      type:
                          const TextInputType.numberWithOptions(decimal: false),
                      onSubmit: (value) {
                        setState(() {
                          servicecharter = value;
                        });
                      },
                      title: 'Service Charters developed/reviewed',
                    ),
                    MyTextInput(
                      lines: 1,
                      value: myData != null
                          ? myData["PG_Sanctions_Rewards_Policy"].toString()
                          : "",
                      type:
                          const TextInputType.numberWithOptions(decimal: false),
                      onSubmit: (value) {
                        setState(() {
                          sanctions = value;
                        });
                      },
                      title: 'Sanctions and Rewards_Policy',
                    ),
                    MyTextInput(
                      lines: 1,
                      value: myData != null
                          ? myData["PG_Officials_Trained"].toString()
                          : "",
                      type:
                          const TextInputType.numberWithOptions(decimal: false),
                      onSubmit: (value) {
                        setState(() {
                          officialstrained = value;
                        });
                      },
                      title:
                          'Number of county and government officials trained in corporate governance',
                    ),
                    TextResponse(
                      label: error,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SubmitButton(
                        label: "Finish",
                        onButtonPressed: () async {
                          setState(() {
                            isLoading =
                                LoadingAnimationWidget.horizontalRotatingDots(
                              color: Color.fromARGB(248, 186, 12, 47),
                              size: 100,
                            );
                          });
                          var res = await submitData(
                              id,
                              editing,
                              propoorpolicies,
                              meteringpolicies,
                              climatepolicies,
                              seweragepolicies,
                              marketingpolicies,
                              strategicplans,
                              businesspolicies,
                              watersafetypolicies,
                              financepolicies,
                              pippolicies,
                              cidpsdeveloped,
                              hrpolicies,
                              waterandsanitationact,
                              newmanuals,
                              operationsandmaintenance,
                              servicecharter,
                              sanctions,
                              officialstrained);
                          setState(() {
                            isLoading = null;
                            if (res.error == null) {
                              error = res.success;
                            } else {
                              error = res.error;
                            }
                          });
                          if (res.error == null) {
                            Timer(const Duration(seconds: 1), () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const Components()));
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: isLoading ?? const SizedBox(),
          ),
        ],
      ),
    );
  }
}

Future<Message> submitData(
    String? id,
    String? editing,
    String propoorpolicies,
    String meteringpolicies,
    String climatepolicies,
    String seweragepolicies,
    String marketingpolicies,
    String strategicplans,
    String businesspolicies,
    String watersafetypolicies,
    String financepolicies,
    String pippolicies,
    String cidpsdeveloped,
    String hrpolicies,
    String waterandsanitationact,
    String newmanuals,
    String operationsandmaintenance,
    String servicecharter,
    String sanctions,
    String officialstrained) async {
  try {
    final response = await http.put(
      Uri.parse("${getUrl()}rmf/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'PG_ProPoorPolicies_Developed': propoorpolicies,
        'PG_MeteringPolicies_Developed': meteringpolicies,
        'PG_ClimateChangePolicies_Developed': climatepolicies,
        'PG_MarketingPolicies_Developed': marketingpolicies,
        'PG_BusinessPlans_Developed': businesspolicies,
        'PG_WaterSafetyPlan_Developed': watersafetypolicies,
        'PG_PIPs_Developed': pippolicies,
        'PG_CIDP_Developed': cidpsdeveloped,
        'PG_WaterSanitationAct_Developed': waterandsanitationact,
        'PG_NRWManual_Developed': newmanuals,
        'PG_ServiceCharter_Developed': servicecharter,
        'PG_Sewerage_Policy': seweragepolicies,
        'PG_Strategic_Plan': strategicplans,
        'PG_Sanctions_Rewards_Policy': sanctions,
        'PG_Operations_Maintenance': operationsandmaintenance,
        'PG_HR_Policy': hrpolicies,
        'PG_Finance_Policy': financepolicies,
        'PG_Officials_Trained': officialstrained
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 203) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      return Message(
        token: null,
        success: null,
        error: "Connection to server failed!!",
      );
    }
  } catch (e) {
    return Message(
      token: null,
      success: null,
      error: "Connection to server failed!",
    );
  }
}

class Message {
  var token;
  var success;
  var error;

  Message({
    required this.token,
    required this.success,
    required this.error,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      token: json['token'],
      success: json['success'],
      error: json['error'],
    );
  }
}
