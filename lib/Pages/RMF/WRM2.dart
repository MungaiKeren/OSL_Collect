// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, camel_case_types

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wkwp_mobile/Components/MyTextInput.dart';
import 'package:wkwp_mobile/Pages/ARF/SubmitButton.dart';
import 'package:wkwp_mobile/Components/TextResponse.dart';
import 'package:wkwp_mobile/Components/TextSmall.dart';
import 'package:wkwp_mobile/Components/Utils.dart';
import 'package:wkwp_mobile/Pages/Components.dart';
import 'package:http/http.dart' as http;

class WRM2 extends StatefulWidget {
  const WRM2({super.key});

  @override
  State<WRM2> createState() => _WRM2State();
}

class _WRM2State extends State<WRM2> {
  var long = 36.0, lat = -2.0;
  String error = '';
  String pesaction = '';
  String trees = '';
  String springs = '';
  String terracekilometers = '';
  String reparianLand = '';
  String rehabilitatedland = '';
  String wruasscmp = '';
  String nurseries = '';
  String riverine = '';
  String measuresbeneficiaries = '';
  String igasbeneficiaries = '';
  String igasbeneficiariesHH = '';
  String committee = '';
  String solutions = '';
  String? editing = '';
  String? id = '';
  var myData;

  final storage = const FlutterSecureStorage();

  var isLoading;

  prefillForm(String? id) async {
    try {
      isLoading = LoadingAnimationWidget.horizontalRotatingDots(
        color: const Color.fromARGB(248, 186, 12, 47),
        size: 100,
      );

      final response = await http
          .get(Uri.parse("${getUrl()}rmf/$id"), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

      var data = json.decode(response.body);

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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF03306E), Color.fromRGBO(0, 96, 177, 1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
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
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          "RMF - Water Resource Management",
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["WRM_PES_Actions"].toString()
                        : "",
                    type: const TextInputType.numberWithOptions(decimal: false),
                    onSubmit: (value) {
                      setState(() {
                        pesaction = value;
                      });
                    },
                    title: 'Number of PES action plans developed',
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["WRM_Trees_Planted"].toString()
                        : "",
                    type: const TextInputType.numberWithOptions(decimal: false),
                    onSubmit: (value) {
                      setState(() {
                        trees = value;
                      });
                    },
                    title: 'Number of Trees Planted',
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["WRM_Springs_Protected"].toString()
                        : "",
                    type: const TextInputType.numberWithOptions(decimal: false),
                    onSubmit: (value) {
                      setState(() {
                        springs = value;
                      });
                    },
                    title: 'Number of Springs Protected',
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["WRM_Terrace_Kilometers"].toString()
                        : "",
                    type: const TextInputType.numberWithOptions(decimal: false),
                    onSubmit: (value) {
                      setState(() {
                        terracekilometers = value;
                      });
                    },
                    title: 'Number of Kilometers of terrace',
                  ),
                  const TextSmall(
                      label: "Number of hectares of land rehabilitated"),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextInput(
                          lines: 1,
                          value: myData != null
                              ? myData["WRM_Riparian_Rehabilitated"].toString()
                              : "",
                          type: const TextInputType.numberWithOptions(
                              decimal: false),
                          onSubmit: (value) {
                            setState(() {
                              reparianLand = value;
                            });
                          },
                          title: 'Riparian',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: MyTextInput(
                          lines: 1,
                          value: myData != null
                              ? myData["WRM_Forest_Rehabilitated"].toString()
                              : "",
                          type: const TextInputType.numberWithOptions(
                              decimal: false),
                          onSubmit: (value) {
                            setState(() {
                              rehabilitatedland = value;
                            });
                          },
                          title: 'Forest',
                        ),
                      ),
                    ],
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["WRM_WRUAs_SCMP"].toString()
                        : "",
                    type: const TextInputType.numberWithOptions(decimal: false),
                    onSubmit: (value) {
                      setState(() {
                        wruasscmp = value;
                      });
                    },
                    title: 'Number of WRUAs with SCMP',
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["WRM_Tree_Nurseries"].toString()
                        : "",
                    type: const TextInputType.numberWithOptions(decimal: false),
                    onSubmit: (value) {
                      setState(() {
                        nurseries = value;
                      });
                    },
                    title: 'Number of Tree Nurseries Established',
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["WRM_Riverine_Protected"].toString()
                        : "",
                    type: const TextInputType.numberWithOptions(decimal: false),
                    onSubmit: (value) {
                      setState(() {
                        riverine = value;
                      });
                    },
                    title: 'Kilometers of riverine protected',
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["WRM_Beneficiaries_Improved_WRM"].toString()
                        : "",
                    type: const TextInputType.numberWithOptions(decimal: false),
                    onSubmit: (value) {
                      setState(() {
                        measuresbeneficiaries = value;
                      });
                    },
                    title:
                        'Number of beneficiaries benefiting from adoption and implementation of measures to improve water resources management',
                  ),
                  const TextSmall(
                      label:
                          "Number of beneficiaries benefiting from alternative/enhanced IGAs"),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextInput(
                          lines: 1,
                          value: myData != null
                              ? myData["WRM_Beneficiaries_IGA_HH"].toString()
                              : "",
                          type: const TextInputType.numberWithOptions(
                              decimal: false),
                          onSubmit: (value) {
                            setState(() {
                              igasbeneficiariesHH = value;
                            });
                          },
                          title: 'HH',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: MyTextInput(
                          lines: 1,
                          value: myData != null
                              ? myData["WRM_Beneficiaries_IGA_Total"].toString()
                              : "",
                          type: const TextInputType.numberWithOptions(
                              decimal: false),
                          onSubmit: (value) {
                            setState(() {
                              igasbeneficiaries = value;
                            });
                          },
                          title: 'Total',
                        ),
                      ),
                    ],
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["WRM_WRUA_Committees_Trained"].toString()
                        : "",
                    type: const TextInputType.numberWithOptions(decimal: false),
                    onSubmit: (value) {
                      setState(() {
                        committee = value;
                      });
                    },
                    title:
                        'Number of WRUA committees trained on effective WRM practices',
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["WRM_Data_Digital_Solution"].toString()
                        : "",
                    type: TextInputType.text,
                    onSubmit: (value) {
                      setState(() {
                        solutions = value;
                      });
                    },
                    title:
                        'Name of Data management and digital solution adopted and operationalized/functional',
                  ),
                  TextResponse(
                    label: error,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SubmitButton(
                      label: "Next ->",
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
                          pesaction,
                          trees,
                          springs,
                          terracekilometers,
                          rehabilitatedland,
                          wruasscmp,
                          nurseries,
                          riverine,
                          measuresbeneficiaries,
                          igasbeneficiariesHH,
                          igasbeneficiaries,
                          committee,
                          solutions,
                        );
                        setState(() {
                          isLoading = null;
                          if (res.error == null) {
                            error = res.success;
                          } else {
                            error = res.error;
                          }
                        });
                        if (res.error == null) {
                          // PROCEED TO NEXT PAGE
                          Timer(const Duration(seconds: 1), () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Components()));
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
  String pesaction,
  String trees,
  String springs,
  String terracekilometers,
  String rehabilitatedland,
  String wruasscmp,
  String nurseries,
  String riverine,
  String measuresbeneficiaries,
  String igasbeneficiariesHH,
  String igasbeneficiaries,
  String committee,
  String solutions,
) async {
  try {
    final response = await http.put(
      Uri.parse("${getUrl()}rmf/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'WRM_PES_Actions': pesaction,
        'WRM_Trees_Planted': trees,
        'WRM_Springs_Protected': springs,
        'WRM_Terrace_Kilometers': terracekilometers,
        'WRM_Riparian_Rehabilitated': rehabilitatedland,
        'WRM_WRUAs_SCMP': wruasscmp,
        'WRM_Tree_Nurseries': nurseries,
        'WRM_Riverine_Protected': riverine,
        'WRM_Beneficiaries_Improved_WRM': measuresbeneficiaries,
        'WRM_Beneficiaries_IGA_HH': igasbeneficiariesHH,
        'WRM_Beneficiaries_IGA_Total': igasbeneficiaries,
        'WRM_WRUA_Committees_Trained': committee,
        'WRM_Data_Digital_Solution': solutions,
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
