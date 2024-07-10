// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, camel_case_types

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wkwp_mobile/Components/MyCalendar.dart';
import 'package:wkwp_mobile/Components/MyCheckBox.dart';
import 'package:wkwp_mobile/Components/MySelectInput.dart';
import 'package:wkwp_mobile/Components/MyTextInput.dart';
import 'package:wkwp_mobile/Pages/ARF/SubmitButton.dart';
import 'package:wkwp_mobile/Components/TextResponse.dart';
import 'package:wkwp_mobile/Components/TextSmall.dart';
import 'package:wkwp_mobile/Components/Utils.dart';
import 'package:wkwp_mobile/Model/SearchItem.dart';
import 'package:wkwp_mobile/Pages/Components.dart';
import 'package:http/http.dart' as http;

class RMFBasicDetails extends StatefulWidget {
  const RMFBasicDetails({super.key});

  @override
  State<RMFBasicDetails> createState() => _RMFBasicDetailsState();
}

class _RMFBasicDetailsState extends State<RMFBasicDetails> {
  late Position position;
  final storage = const FlutterSecureStorage();
  List<SearchItem> entries = <SearchItem>[];

  var long = 36.0, lat = -2.0;
  String error = '';
  String SectorStakeholder = "";
  String StakeholderType = "";
  String County = "";
  String SubCounty = "";
  String Ward = "";
  String Village = "";
  String Date = "";
  String Longitude = "";
  String Latitude = "";
  String ContactName = "";
  String ContactPhone = "";
  String Designation = "";
  List<String> TA_Provided = [];
  List<String> TAThrough = [];
  String check = '';
  String searchbox = '';
  String searchItem = 'Name';
  String? editing = '';
  String? id = '';
  bool showTextInput = false;
  var myData;
  var si = '';
  var isLoading;

  searchStakeholder(q) async {
    setState(() {
      entries.clear();
    });

    try {
      final response = await http.get(
          Uri.parse("${getUrl()}waterproviders/search/$q"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });

      var data = json.decode(response.body);

      setState(() {
        entries.clear();
        for (var item in data) {
          entries.add(SearchItem(
              item["Name"],
              item["Type"],
              item["County"],
              item["SubCounty"],
              item["Ward"],
              item["Village"],
              item["Longitude"],
              item["Latitude"]));
        }
      });
    } catch (e) {
      // todo
    }
  }

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
        isLoading = null;
        myData = data;
      });
    } catch (e) {
      setState(() {
        isLoading = null;
        id = null;
      });
    }
  }

  checkEditing() async {
    var myId = await storage.read(key: "RMFID");

    setState(() {
      id = myId;
    });

    if (myId != null) {
      prefillForm(myId);
    } else {}
  }

  @override
  void initState() {
    checkEditing();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RMFBasicDetails oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (SectorStakeholder != SectorStakeholder) {
      setState(() {
        // Update any necessary state here
        showTextInput = SectorStakeholder.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
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
                  const Text(
                    "RMF - Basic Details",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  id != null
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 96, 177, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${myData != null ? myData["SectorStakeholder"] : ""}",
                                    style: const TextStyle(
                                        color: Colors.white54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Stakeholder Type: ${myData != null ? myData["StakeholderType"] : ""}",
                                    style: const TextStyle(
                                        color: Colors.white54, fontSize: 18),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "County: ${myData != null ? myData["County"] : ""}",
                                    style: const TextStyle(
                                        color: Colors.white54, fontSize: 18),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "SubCounty: ${myData != null ? myData["SubCounty"] : ""}",
                                    style: const TextStyle(
                                        color: Colors.white54, fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  showTextInput
                      ? Text(
                          SectorStakeholder,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 8,
                  ),
                  id == null
                      ? TextField(
                          onChanged: (value) {
                            if (value.characters.length >=
                                check.characters.length) {
                              searchStakeholder(value);
                            } else {
                              setState(() {
                                entries.clear();
                                SectorStakeholder = '';
                                StakeholderType = '';
                                Village = '';
                                Longitude = '';
                                Latitude = '';
                              });
                            }
                            setState(() {
                              check = value;
                              error = '';
                            });
                          },
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 26, 114, 186))),
                            filled: false,
                            labelText: 'Search Beneficiary Name...',
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 26, 114, 186)),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                        )
                      : const SizedBox(),
                  entries.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Card(
                            elevation: 12,
                            child: SizedBox(
                              width: double.maxFinite,
                              child: ListView.separated(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: entries.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return TextButton(
                                    onPressed: () {
                                      setState(() {
                                        SectorStakeholder = entries[index].Name;
                                        StakeholderType = entries[index].Type;
                                        County = entries[index].County;
                                        SubCounty = entries[index].SubCounty;
                                        Ward = entries[index].Ward;
                                        Village = entries[index].Village;
                                        Longitude = entries[index].Logitude;
                                        Latitude = entries[index].Latitude;
                                        entries.clear();
                                        showTextInput = true;
                                      });
                                    },
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            '${entries[index].Name}, Type: ${entries[index].Type}')),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(
                          height: 10,
                        ),
                  MyCalendar(
                    lines: 1,
                    value: myData != null ? myData["Date"].toString() : "",
                    onSubmit: (value) {
                      setState(() {
                        Date = value;
                      });
                    },
                    label: 'Select Date...',
                  ),
                  const TextSmall(label: "Type of TA Provided"),
                  MyCheckBox(
                    onSubmit: (value) {
                      setState(() {
                        TA_Provided = value;
                      });
                    },
                    options: const [
                      "Operational",
                      "Management",
                      "Engineering",
                      "Capacity Building",
                      "Finance",
                      "Data & Digital Solutions"
                    ],
                    selectedOptions: TA_Provided,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const TextSmall(label: "TA Through"),
                  MyCheckBox(
                    onSubmit: (value) {
                      setState(() {
                        TAThrough = value;
                      });
                    },
                    options: const [
                      "Training",
                      "Grant",
                      "Meeting/coaching/mentoring",
                      "Other"
                    ],
                    selectedOptions: TAThrough,
                  ),
                  TextResponse(
                    label: error,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SubmitButton(
                      label: "Submit",
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
                            SectorStakeholder,
                            StakeholderType,
                            County,
                            SubCounty,
                            Ward,
                            Village,
                            Date,
                            Longitude,
                            Latitude,
                            ContactName,
                            ContactPhone,
                            Designation,
                            TA_Provided,
                            TAThrough);
                        setState(() {
                          isLoading = null;
                          if (res.error == null) {
                            error = res.success;
                          } else {
                            error = res.error;
                          }
                        });
                        if (res.error == null) {
                          storage.write(key: 'RMFID', value: res.id);
                          // PROCEED TO NEXT PAGE
                          Timer(const Duration(seconds: 2), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Components(),
                              ),
                            );
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
  String SectorStakeholder,
  String StakeholderType,
  String County,
  String SubCounty,
  String Ward,
  String Village,
  String Date,
  String Latitude,
  String Longitude,
  String ContactName,
  String ContactPhone,
  String Designation,
  List<String> TA_Provided,
  List<String> TAThrough,
) async {
  if (Date.isEmpty || TA_Provided.isEmpty || TAThrough.isEmpty) {
    return Message(
      id: null,
      token: null,
      success: null,
      error: "All Fields Must Be Filled!",
    );
  }
  try {
    dynamic response;

    if (id == null) {
      response = await http.post(
        Uri.parse("${getUrl()}rmf/create"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'SectorStakeholder': SectorStakeholder,
          'StakeholderType': StakeholderType,
          'County': County,
          'SubCounty': SubCounty,
          'Ward': Ward,
          'Village': Village,
          'Date': Date,
          'Longitude': Longitude,
          'Latitude': Latitude,
          'ContactName': ContactName,
          'ContactPhone': ContactPhone,
          'Designation': Designation,
          'TA_Provided': TA_Provided.join(', '),
          'TAThrough': TAThrough.join(', '),
        }),
      );
    } else {
      response = await http.put(
        Uri.parse("${getUrl()}rmf/$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'SectorStakeholder': SectorStakeholder,
          'StakeholderType': StakeholderType,
          'Date': Date,
          'TA_Provided': TA_Provided.join(', '),
          'TAThrough': TAThrough.join(', '),
        }),
      );
    }

    if (response.statusCode == 200 || response.statusCode == 203) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      return Message(
        token: null,
        success: null,
        id: null,
        error: "Connection to server failed!!",
      );
    }
  } catch (e) {
    return Message(
        token: null,
        success: null,
        error: "Connection to server failed!",
        id: null);
  }
}

class Message {
  var token;
  var success;
  var error;
  var id;

  Message(
      {required this.token,
      required this.success,
      required this.error,
      required this.id});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        token: json['token'],
        success: json['success'],
        error: json['error'],
        id: json['ID']);
  }
}
