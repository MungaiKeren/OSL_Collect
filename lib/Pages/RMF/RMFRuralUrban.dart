// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, camel_case_types, empty_catches

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wkwp_mobile/Components/MySelectInput.dart';
import 'package:wkwp_mobile/Components/MyTextInput.dart';
import 'package:wkwp_mobile/Pages/ARF/SubmitButton.dart';
import 'package:wkwp_mobile/Components/TextResponse.dart';
import 'package:wkwp_mobile/Components/TextSmall.dart';
import 'package:wkwp_mobile/Components/Utils.dart';
import 'package:http/http.dart' as http;
import 'package:wkwp_mobile/Pages/Components.dart';

class RMFRuralUrban extends StatefulWidget {
  const RMFRuralUrban({super.key});

  @override
  State<RMFRuralUrban> createState() => _RMFRuralUrban2State();
}

class _RMFRuralUrban2State extends State<RMFRuralUrban> {
  var long = 36.0, lat = -2.0;
  String error = '';
  String nrw = '';
  String billing = '';
  String totalCollection = '';
  String pipeline = '';
  String individualConnection = '';
  String yardtaps = '';
  String dwellingunits = '';
  String kiosks = '';
  String newconnections = '';
  String improvedService = '';
  String protectedSprings = '';
  String improvedProtectedSprings = '';
  String qualitystandard = '';
  String watervolume = '';
  String waterstorage = '';
  String improvedservice = '';
  String regstatus = '';
  String supplyhours = '';
  String newmeters = '';
  String others = '';
  String from = '';
  String to = '';
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

      print('BASIC DETAILS: ${data}');

      print('BASIC DETAILS: ${data["TA_Provided"]}');

      setState(() {
        myData = data;
      });

      isLoading = null;
    } catch (e) {
      isLoading = null;
    }
  }

  checkEditing() async {
    var myId = await storage.read(key: "RMFID");

    setState(() {
      id = myId;
    });

    print('$editing, $id');

    if (id != null) {
      print("prefilling form");
      prefillForm(id);
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Components()));
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
            padding: const EdgeInsets.fromLTRB(24, 50, 24, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(3, 48, 110, 1),
                  Color.fromRGBO(0, 96, 177, 1)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
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
                  const Column(
                    children: [
                      Text(
                        "RMF - Rural & Urban Water Services",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null ? myData["RU_NRW"].toString() : "",
                    type: const TextInputType.numberWithOptions(decimal: true),
                    onSubmit: (value) {
                      setState(() {
                        nrw = value;
                      });
                    },
                    title: 'Percentage of Non-Revenue Water(%)',
                  ),
                  const TextSmall(label: "Revenue Collection"),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextInput(
                          lines: 1,
                          value: myData != null
                              ? myData["RU_TotalBilled"].toString()
                              : "",
                          type: const TextInputType.numberWithOptions(
                              decimal: true),
                          onSubmit: (value) {
                            setState(() {
                              billing = value;
                            });
                          },
                          title: 'Total Billing',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextInput(
                          lines: 1,
                          value: myData != null
                              ? myData["RU_TotalCollected"].toString()
                              : "",
                          type: const TextInputType.numberWithOptions(
                              decimal: true),
                          onSubmit: (value) {
                            setState(() {
                              totalCollection = value;
                            });
                          },
                          title: 'Total Collection',
                        ),
                      ),
                    ],
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["RU_WaterPipelineConstructed"].toString()
                        : "",
                    type: const TextInputType.numberWithOptions(
                              decimal: true),
                    onSubmit: (value) {
                      setState(() {
                        pipeline = value;
                      });
                    },
                    title:
                        'Length of water distribution pipelines constructed/rehabilitated (Km)',
                  ),
                  const TextSmall(label: "Number of new water connections"),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextInput(
                          lines: 1,
                          value: myData != null
                              ? myData["RU_NWCIndividualConnection"].toString()
                              : "",
                          type: const TextInputType.numberWithOptions(
                              decimal: false),
                          onSubmit: (value) {
                            try {
                              setState(() {
                                individualConnection = value;
                              });
                            } catch (e) {}
                          },
                          title: 'Individual Connections',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextInput(
                          lines: 1,
                          value: myData != null
                              ? myData["RU_NWCYardTaps"].toString()
                              : "",
                          type: const TextInputType.numberWithOptions(
                              decimal: false),
                          onSubmit: (value) {
                            try {
                              setState(() {
                                yardtaps = value;
                              });
                            } catch (e) {}
                          },
                          title: 'Yard Taps',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextInput(
                          lines: 1,
                          value: myData != null
                              ? myData["RU_NWCMDU"].toString()
                              : "",
                          type: const TextInputType.numberWithOptions(
                              decimal: false),
                          onSubmit: (value) {
                            try {
                              setState(() {
                                dwellingunits = value;
                              });
                            } catch (e) {}
                          },
                          title: 'MDU (small,medium,large)',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextInput(
                          lines: 1,
                          value: myData != null
                              ? myData["RU_NWCKiosks"].toString()
                              : "",
                          type: const TextInputType.numberWithOptions(
                              decimal: false),
                          onSubmit: (value) {
                            try {
                              setState(() {
                                kiosks = value;
                              });
                            } catch (e) {}
                          },
                          title: 'Kiosks',
                        ),
                      ),
                    ],
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["RU_Newbeneficiaries_NewConnections"]
                            .toString()
                        : "",
                    type: const TextInputType.numberWithOptions(
                              decimal: false),
                    onSubmit: (value) {
                      try {
                        setState(() {
                          newconnections = value;
                        });
                      } catch (e) {}
                    },
                    title:
                        'Number of new beneficiaries of water from new connections',
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["RU_Beneficiaries_ImprovedService"].toString()
                        : "",
                    type: const TextInputType.numberWithOptions(
                              decimal: false),
                    onSubmit: (value) {
                      try {
                        setState(() {
                          improvedService = value;
                        });
                      } catch (e) {}
                    },
                    title:
                        'Number of beneficiaries benefiting from improved service',
                  ),
                  const TextSmall(
                      label:
                          "Protected springs and communcal water points not managed by enterprises"),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextInput(
                          lines: 1,
                          value: myData != null
                              ? myData["RU_Newbeneficiaries_ProtectedSprings"]
                                  .toString()
                              : "",
                          type: const TextInputType.numberWithOptions(
                              decimal: false),
                          onSubmit: (value) {
                            try {
                              setState(() {
                                protectedSprings = value;
                              });
                            } catch (e) {}
                          },
                          title: 'Number of new beneficiaries',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextInput(
                          lines: 1,
                          value: myData != null
                              ? myData["RU_Beneficiaries_IS_ProtectedSprings"]
                                  .toString()
                              : "",
                          type: const TextInputType.numberWithOptions(
                              decimal: false),
                          onSubmit: (value) {
                            try {
                              setState(() {
                                improvedProtectedSprings = value;
                              });
                            } catch (e) {}
                          },
                          title: 'Beneficiaries from improved service',
                        ),
                      ),
                    ],
                  ),
                  MySelectInput(
                    onSubmit: (value) {
                      setState(() {
                        qualitystandard = value;
                      });
                    },
                    list: const ["Select", "Yes", "No"],
                    value: myData != null
                        ? myData["RU_QualityStandard"].toString()
                        : "",
                    label: 'Awarded a quality standard for utilities',
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["RU_WaterProduced"].toString()
                        : "",
                    type: const TextInputType.numberWithOptions(
                              decimal: false),
                    onSubmit: (value) {
                      try {
                        setState(() {
                          watervolume = value;
                        });
                      } catch (e) {}
                    },
                    title: 'Volume of water produced (Cubic Meters)',
                  ),
                  MySelectInput(
                    onSubmit: (value) {
                      setState(() {
                        regstatus = value;
                      });
                    },
                    list: const [
                      "Select",
                      "Self Help Group (SHG)",
                      "Community Based Organization (CBO)",
                      "Water Users Association (WUA)",
                      "Company",
                      "Current",
                      "Expired",
                      "Other"
                    ],
                    value: regstatus,
                    label: 'Registration Status',
                  ),
                  const TextSmall(label: "Change in service delivery model"),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextInput(
                          lines: 1,
                          onSubmit: (value) {
                            setState(() {
                              from = value;
                            });
                          },
                          title: 'From',
                          value: myData != null
                              ? myData["RU_SDM_From"].toString()
                              : "",
                          type: TextInputType.text,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: MyTextInput(
                          lines: 1,
                          onSubmit: (value) {
                            setState(() {
                              to = value;
                            });
                          },
                          title: 'To',
                          value: myData != null
                              ? myData["RU_SDM_To"].toString()
                              : "",
                          type: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["RU_WaterStorage"].toString()
                        : "",
                    type: const TextInputType.numberWithOptions(
                              decimal: false),
                    onSubmit: (value) {
                      try {
                        setState(() {
                          waterstorage = value;
                        });
                      } catch (e) {}
                    },
                    title: 'Water storage (M3)',
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["RU_SupplyHours"].toString()
                        : "",
                    type: const TextInputType.numberWithOptions(
                              decimal: false),
                    onSubmit: (value) {
                      try {
                        setState(() {
                          supplyhours = value;
                        });
                      } catch (e) {}
                    },
                    title: 'Hours of supply (Hrs)',
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["RU_New_Meters"].toString()
                        : "",
                    type: const TextInputType.numberWithOptions(
                              decimal: false),
                    onSubmit: (value) {
                      try {
                        setState(() {
                          newmeters = value;
                        });
                      } catch (e) {}
                    },
                    title: 'Number of new meters installed',
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
                            color: const Color.fromARGB(248, 186, 12, 47),
                            size: 100,
                          );
                        });
                        var res = await submitData(
                            id,
                            editing,
                            nrw,
                            billing,
                            totalCollection,
                            pipeline,
                            individualConnection,
                            yardtaps,
                            dwellingunits,
                            kiosks,
                            newconnections,
                            improvedService,
                            protectedSprings,
                            improvedProtectedSprings,
                            qualitystandard,
                            watervolume,
                            regstatus,
                            from,
                            to,
                            waterstorage,
                            supplyhours,
                            newmeters);
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
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Components()));
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
    String nrw,
    String billing,
    String totalCollection,
    String pipeline,
    String individualConnection,
    String yardtaps,
    String dwellingunits,
    String kiosks,
    String newconnections,
    String improvedService,
    String protectedSprings,
    String improvedProtectedSprings,
    String qualitystandard,
    String watervolume,
    String regstatus,
    String from,
    String to,
    String waterstorage,
    String supplyhours,
    String newmeters) async {
  try {
    print("BASIC DETAILS $nrw");
    final response = await http.put(
      Uri.parse("${getUrl()}rmf/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'RU_NRW': nrw,
        'RU_TotalBilled': billing,
        'RU_TotalCollected': totalCollection,
        'RU_WaterPipelineConstructed': pipeline,
        'RU_NWCIndividualConnection': individualConnection,
        'RU_NWCYardTaps': yardtaps,
        'RU_NWCMDU': dwellingunits,
        'RU_NWCKiosks': kiosks,
        'RU_Newbeneficiaries_NewConnections': newconnections,
        'RU_Beneficiaries_ImprovedService': improvedService,
        'RU_Newbeneficiaries_ProtectedSprings': protectedSprings,
        'RU_Beneficiaries_IS_ProtectedSprings': improvedProtectedSprings,
        'RU_QualityStandard': qualitystandard,
        'RU_WaterProduced': watervolume,
        'RU_RegistrationStatus': regstatus,
        'RU_SDM_From': from,
        'RU_SDM_To': to,
        'RU_WaterStorage': waterstorage,
        'RU_SupplyHours': supplyhours,
        'RU_New_Meters': newmeters
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
    print('error is $e');
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
