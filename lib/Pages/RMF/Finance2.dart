// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, camel_case_types, unused_import

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
import 'package:wkwp_mobile/Pages/Components.dart';
import 'package:http/http.dart' as http;
import 'package:wkwp_mobile/Pages/RMF/RMFRuralUrban.dart';

class Finance2 extends StatefulWidget {
  const Finance2({super.key});

  @override
  State<Finance2> createState() => _Finance2State();
}

class _Finance2State extends State<Finance2> {
  var long = 36.0, lat = -2.0;
  String error = '';
  String capital = '';
  String debt = '';
  String leveraged = '';
  String privatefundingsource = '';
  String philanthropicfunding = '';
  String philanthropicsource = '';
  String countygovfund = '';
  String natgovfund = '';
  String privateFundBeneficiaries = '';
  String improvedServBen = '';
  String philFundBen = '';
  String philFundBenIS = '';
  String publicFundBen = '';
  String publicFundBenIS = '';
  String? editing = '';
  String? id = '';
  var myData = null;

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
      print("mydata: $data");

      setState(() {
        myData = data;
        isLoading = null;
      });
    } catch (e) {
      print("mydata: $e");
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
                colors: [
                  Color.fromRGBO(3, 48, 110, 1),
                  Color.fromRGBO(0, 96, 177, 1)
                ],
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
                          "RMF - Finance & Private Engagements",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  const TextSmall(
                      label:
                          "Amount of private funding invested by WSPs/Enterprises"),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextInput(
                          lines: 1,
                          value: myData != null
                              ? myData["FPS_PrivateFunding_Own"].toString()
                              : "",
                          type: const TextInputType.numberWithOptions(
                              decimal: false),
                          onSubmit: (value) {
                            setState(() {
                              capital = value;
                            });
                          },
                          title: 'Own Capital',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: MyTextInput(
                          lines: 1,
                          value: myData != null
                              ? myData["FPS_PrivateFunding_Debt"].toString()
                              : "",
                          type: const TextInputType.numberWithOptions(
                              decimal: false),
                          onSubmit: (value) {
                            setState(() {
                              debt = value;
                            });
                          },
                          title: 'Debt',
                        ),
                      ),
                    ],
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["FPS_PrivateFunding_Leveraged"].toString()
                        : "",
                    type: const TextInputType.numberWithOptions(decimal: false),
                    onSubmit: (value) {
                      setState(() {
                        leveraged = value;
                      });
                    },
                    title: 'Amount Leveraged',
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  MySelectInput(
                    onSubmit: (value) {
                      setState(() {
                        privatefundingsource = value;
                      });
                    },
                    list: const ["Select", "Bank", "Sacco", "MFI", "Other"],
                    label: 'Source of Private Funding',
                    value: myData != null
                        ? myData["FPS_PrivateFunding_Source"].toString()
                        : "",
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["FPS_PhilanthropicFunding"].toString()
                        : "",
                    type: const TextInputType.numberWithOptions(decimal: true),
                    onSubmit: (value) {
                      setState(() {
                        philanthropicfunding = value;
                      });
                    },
                    title:
                        'Amount of philanthropic funding mobiled by WSPs/Enterprises',
                  ),
                  MySelectInput(
                    onSubmit: (value) {
                      setState(() {
                        philanthropicsource = value;
                      });
                    },
                    list: const [
                      "Select",
                      "Corporate CSR",
                      "NGOs",
                      "Foundations",
                      "Other"
                    ],
                    value: myData != null
                        ? myData["FPS_PhilanthropicFunding_Source"].toString()
                        : "",
                    label: 'Source of Philanthropic Funding',
                  ),
                  const TextSmall(
                      label:
                          "Amount of public funding invested by WSPs/Enterprises"),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextInput(
                          lines: 1,
                          value: myData != null
                              ? myData["FPS_PublicFunding_CountyGov"].toString()
                              : "",
                          type: const TextInputType.numberWithOptions(
                              decimal: true),
                          onSubmit: (value) {
                            setState(() {
                              countygovfund = value;
                            });
                          },
                          title: 'County Government (Ksh)',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: MyTextInput(
                          lines: 1,
                          value: myData != null
                              ? myData["FPS_PublicFunding_NationalGov"]
                                  .toString()
                              : "",
                          type: const TextInputType.numberWithOptions(
                              decimal: true),
                          onSubmit: (value) {
                            setState(() {
                              natgovfund = value;
                            });
                          },
                          title: 'National Government (KSh)',
                        ),
                      ),
                    ],
                  ),
                  const TextSmall(label: "Private Funding Investment"),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["FPS_NewBeneficiaries_PrivateFunding"]
                            .toString()
                        : "",
                    type: const TextInputType.numberWithOptions(decimal: false),
                    onSubmit: (value) {
                      setState(() {
                        privateFundBeneficiaries = value;
                      });
                    },
                    title:
                        'Number of new beneficiaries benefiting from private funding investment',
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["FPS_IS_Beneficiaries_PrivateFunding"]
                            .toString()
                        : "",
                    type: const TextInputType.numberWithOptions(decimal: false),
                    onSubmit: (value) {
                      setState(() {
                        improvedServBen = value;
                      });
                    },
                    title:
                        'Number of beneficiaries benefiting from improved service',
                  ),
                  const TextSmall(label: "Philanthropic Funding Investment"),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["FPS_NewBeneficiaries_PhilanthropicFunding"]
                            .toString()
                        : "",
                    type: const TextInputType.numberWithOptions(decimal: false),
                    onSubmit: (value) {
                      setState(() {
                        philFundBen = value;
                      });
                    },
                    title:
                        'Number of new beneficiaries benefiting from philanthropic funding investment',
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["FPS_IS_Beneficiaries_PhilanthropicFunding"]
                            .toString()
                        : "",
                    type: const TextInputType.numberWithOptions(decimal: false),
                    onSubmit: (value) {
                      setState(() {
                        philFundBenIS = value;
                      });
                    },
                    title:
                        'Number of beneficiaries benefiting from improved service',
                  ),
                  const TextSmall(label: "Public Funding Investment"),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["FPS_NewBeneficiaries_PublicFunding"]
                            .toString()
                        : "",
                    type: const TextInputType.numberWithOptions(decimal: false),
                    onSubmit: (value) {
                      setState(() {
                        publicFundBen = value;
                      });
                    },
                    title:
                        'Number of new beneficiaries benefiting from public funding investment',
                  ),
                  MyTextInput(
                    lines: 1,
                    value: myData != null
                        ? myData["FPS_IS_Beneficiaries_PublicFunding"]
                            .toString()
                        : "",
                    type: const TextInputType.numberWithOptions(decimal: false),
                    onSubmit: (value) {
                      setState(() {
                        publicFundBenIS = value;
                      });
                    },
                    title:
                        'Number of beneficiaries benefiting from improved service',
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
                            capital,
                            debt,
                            leveraged,
                            privatefundingsource,
                            philanthropicfunding,
                            philanthropicsource,
                            countygovfund,
                            natgovfund,
                            privateFundBeneficiaries,
                            improvedServBen,
                            philFundBen,
                            philFundBenIS,
                            publicFundBen,
                            publicFundBenIS);
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
    String capital,
    String debt,
    String leveraged,
    String privatefundingsource,
    String philanthropicfunding,
    String philanthropicsource,
    String countygovfun,
    String natgovfund,
    String privateFundBeneficiaries,
    String improvedServBen,
    String philFundBen,
    String philFundBenIS,
    String publicFundBen,
    String publicFundBenIS) async {
  try {
    print("data $philanthropicfunding, $countygovfun, $natgovfund");
    final response = await http.put(
      Uri.parse("${getUrl()}rmf/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'FPS_PrivateFunding_Own': capital,
        'FPS_PrivateFunding_Debt': debt,
        'FPS_PrivateFunding_Leveraged': leveraged,
        'FPS_PrivateFunding_Source': privatefundingsource,
        'FPS_PhilanthropicFunding': philanthropicfunding,
        'FPS_PhilanthropicFunding_Source': philanthropicsource,
        'FPS_PublicFunding_CountyGov': countygovfun,
        'FPS_PublicFunding_NationalGov': natgovfund,
        'FPS_NewBeneficiaries_PrivateFunding': privateFundBeneficiaries,
        'FPS_IS_Beneficiaries_PrivateFunding': improvedServBen,
        'FPS_NewBeneficiaries_PhilanthropicFunding': philFundBen,
        'FPS_IS_Beneficiaries_PhilanthropicFunding': philFundBenIS,
        'FPS_NewBeneficiaries_PublicFunding': publicFundBen,
        'FPS_IS_Beneficiaries_PublicFunding': publicFundBenIS
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
