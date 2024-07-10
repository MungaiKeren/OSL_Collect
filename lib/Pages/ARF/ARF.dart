// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, file_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wkwp_mobile/Components/MyCalendar.dart';
import 'package:wkwp_mobile/Components/MyDrawer.dart';
import 'package:wkwp_mobile/Components/MyMap.dart';
import 'package:wkwp_mobile/Components/MySelectInput.dart';
import 'package:wkwp_mobile/Components/MyTextInput.dart';
import 'package:wkwp_mobile/Pages/ARF/SubmitButton.dart';
import 'package:wkwp_mobile/Components/TextResponse.dart';
import 'package:wkwp_mobile/Components/TextSmall.dart';
import 'package:wkwp_mobile/Components/Utils.dart';
import 'package:http/http.dart' as http;
import 'package:wkwp_mobile/Pages/Home.dart';

class ARF extends StatefulWidget {
  const ARF({super.key});

  @override
  State<ARF> createState() => _ARFState();
}

class _ARFState extends State<ARF> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final storage = const FlutterSecureStorage();
  late Position position;

  var long = 36.0, lat = -2.0;
  String error = '';
  String activityID = '';
  String activity = '';
  String organiser = '';
  String county = '';
  String subcounty = '';
  String ward = '';
  String village = '';
  String type = '';
  String sector = '';
  String facilitator = '';
  String facOrg = '';
  String facPhone = '';
  String description = '';
  String topic = '';
  String subtopic = '';
  String date = '';
  String placeName = '';
  String youths = '';
  String adults = '';
  String male = '';
  String female = '';
  String pwdattendees = '';
  File? file;
  String erepname = '';
  String erepdesignation = '';
  String erepsignature = '';
  String wkwpname = '';
  String wkwpdesignation = '';
  String wkwprepsignature = '';

  String userid = '';
  String ScannedFile = '';
  String _fileName = '';

  var isLoading;

  final GlobalKey<SignatureState> _signatureKey = GlobalKey<SignatureState>();
  final GlobalKey _containerKey = GlobalKey();
  final GlobalKey<SignatureState> _signatureKey2 = GlobalKey<SignatureState>();
  final GlobalKey _containerKey2 = GlobalKey();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Future<String> _captureSignature() async {
    final sign = _signatureKey.currentState ?? _signatureKey.currentState;
    //retrieve image data, do whatever you want with it (send to server, save locally...)
    final image = await sign!.getData();
    var data = await image.toByteData(format: ui.ImageByteFormat.png);
    // sign.clear();
    final encoded = base64.encode(data!.buffer.asUint8List());

    return encoded;
  }

  Future<String> _captureSignature2() async {
    final sign2 = _signatureKey2.currentState;
    //retrieve image data, do whatever you want with it (send to server, save locally...)
    final image2 = await sign2!.getData();
    var data2 = await image2.toByteData(format: ui.ImageByteFormat.png);
    // sign.clear();
    final encoded = base64.encode(data2!.buffer.asUint8List());

    return encoded;
  }

  Future<void> getUserInfo() async {
    var token = await storage.read(key: "WKWPjwt");
    var decoded = parseJwt(token.toString());

    setState(() {
      userid = decoded["UserID"];
      wkwpname = decoded["Name"];
      wkwpdesignation = decoded["Position"];
    });
    print("useridmy: $userid");
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      long = position.longitude;
      lat = position.latitude;
    });

    print("ARF Location1: $lat, $long,");
    getPlaceName();
  }

  getPlaceName() async {
    try {
      print("ARF Location: $lat, $long,");
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      if (placemarks.isNotEmpty) {
        setState(() {
          var name = placemarks[0].administrativeArea ?? '';
          county = name.replaceAll('County', '').trim();
          ward = placemarks[0].subLocality ?? '';
          subcounty = placemarks[0].name ?? '';
        });

        print("ARF Location: $lat, $long, $county");
      }
    } catch (e) {}
  }

  @override
  void initState() {
    getLocation();
    getUserInfo();

    super.initState();
  }

  Future<String> convertFileToBase64(File file) async {
    List<int> fileBytes = await file.readAsBytes();
    String base64String = base64Encode(fileBytes);
    return base64String;
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
                      height: 32,
                    ),
                    const Center(
                      child: Text(
                        "Activity Registration Form",
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
                        child: SizedBox(
                            height: 250,
                            child: MyMap(
                              lat: lat,
                              lon: long,
                            ))),
                    MyTextInput(
                      lines: 1,
                      value: '',
                      type: TextInputType.text,
                      onSubmit: (value) {
                        setState(() {
                          activity = value;
                        });
                      },
                      title: 'Activity Name',
                    ),
                    MyTextInput(
                      lines: 1,
                      value: '',
                      type: TextInputType.text,
                      onSubmit: (value) {
                        setState(() {
                          organiser = value;
                        });
                      },
                      title: 'Activity Organiser/Convener',
                    ),
                    MyTextInput(
                      lines: 1,
                      value: '',
                      type: TextInputType.text,
                      onSubmit: (value) {
                        setState(() {
                          village = value;
                        });
                      },
                      title: 'Village/Town',
                    ),
                    MySelectInput(
                      onSubmit: (value) {
                        setState(() {
                          type = value;
                        });
                      },
                      list: const [
                        "--Select--",
                        "Training",
                        "Workshop",
                        "Meeting",
                        "Technical Assistance",
                        "Other"
                      ],
                      label: 'Activity Type',
                      value: type,
                    ),
                    MyTextInput(
                      lines: 1,
                      value: '',
                      type: TextInputType.text,
                      onSubmit: (value) {
                        setState(() {
                          sector = value;
                        });
                      },
                      title: 'Activity Sector',
                    ),
                    MyTextInput(
                      lines: 1,
                      value: '',
                      type: TextInputType.text,
                      onSubmit: (value) {
                        setState(() {
                          facilitator = value;
                        });
                      },
                      title: 'Facilitator Name',
                    ),
                    MyTextInput(
                      lines: 1,
                      value: '',
                      type: TextInputType.text,
                      onSubmit: (value) {
                        setState(() {
                          facOrg = value;
                        });
                      },
                      title: 'Organisation of the Facilitator',
                    ),
                    MyTextInput(
                      lines: 1,
                      value: '',
                      type: TextInputType.phone,
                      onSubmit: (value) {
                        setState(() {
                          facPhone = value;
                        });
                      },
                      title: 'Contacts of Facilitator',
                    ),
                    MySelectInput(
                      onSubmit: (value) {
                        setState(() {
                          topic = value;
                        });
                      },
                      list: const [
                        "--Select--",
                        "Governance",
                        "Technical",
                        "Financial Management",
                        "Service Delivery",
                      ],
                      label:
                          'If activity type is training, Enter the topic to be covered',
                      value: topic,
                    ),
                    MySelectInput(
                      onSubmit: (value) {
                        setState(() {
                          subtopic = value;
                        });
                      },
                      list: const [
                        "--Select--",
                        "Training of management committees on leadership and management",
                        "Awareness creation on water sector reforms and their effect on water service provision",
                        "Training of the management committees on operation and maintenance of the water facilities",
                        "Training of rural water management committees on financial management",
                        "Training of the rural water enterprises on customer care",
                        "WRM advocacy and Stakeholder engagement",
                        "Groundwater and surface data collection and management methodologies",
                        "WRUA Organizational Governance and Leadership",
                        "Financial Management and Resource Mobilization",
                        "Training on PES",
                        "Riparian and Catchment restoration and conservation",
                        "Agricultural best management practices",
                        "Water Resource protection and pollution control",
                        "Climate change mitigation ",
                        "Water infrastructure development ",
                        "Alternative Income Generating Activities",
                      ],
                      label:
                          'If activity type is training, Enter the subtopic to be covered',
                      value: subtopic,
                    ),
                    MyCalendar(
                      lines: 1,
                      value: date,
                      onSubmit: (value) {
                        setState(() {
                          date = value;
                        });
                      },
                      label: 'Date',
                    ),
                    MyTextInput(
                      lines: 4,
                      value: '',
                      type: TextInputType.text,
                      onSubmit: (value) {
                        setState(() {
                          description = value;
                        });
                      },
                      title: 'Description of Event',
                    ),
                    MyTextInput(
                      lines: 1,
                      value: '',
                      type: TextInputType.number,
                      onSubmit: (value) {
                        setState(() {
                          youths = value;
                        });
                      },
                      title: 'No. of youths',
                    ),
                    MyTextInput(
                      lines: 1,
                      value: '',
                      type: TextInputType.number,
                      onSubmit: (value) {
                        setState(() {
                          adults = value;
                        });
                      },
                      title: 'No. of adults',
                    ),
                    MyTextInput(
                      lines: 1,
                      value: '',
                      type: TextInputType.number,
                      onSubmit: (value) {
                        setState(() {
                          male = value;
                        });
                      },
                      title: 'No. of men',
                    ),
                    MyTextInput(
                      lines: 1,
                      value: '',
                      type: TextInputType.number,
                      onSubmit: (value) {
                        setState(() {
                          female = value;
                        });
                      },
                      title: 'No. of women',
                    ),
                    MyTextInput(
                      lines: 1,
                      value: '',
                      type: TextInputType.number,
                      onSubmit: (value) {
                        setState(() {
                          pwdattendees = value;
                        });
                      },
                      title: 'No. of People with Disability',
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    MyTextInput(
                        lines: 1,
                        value: '',
                        type: TextInputType.text,
                        onSubmit: (value) {
                          setState(() {
                            erepname = value;
                          });
                        },
                        title: 'Entity Representative Name'),
                    MyTextInput(
                      lines: 1,
                      value: '',
                      type: TextInputType.text,
                      onSubmit: (value) {
                        setState(() {
                          erepdesignation = value;
                        });
                      },
                      title: 'Entity Representative Designation',
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const TextSmall(label: "Entity Representative Signature"),
                    Stack(
                      children: [
                        RepaintBoundary(
                          key: _containerKey,
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                                color: Colors.white70,
                                border:
                                    Border.all(width: 5, color: Colors.blue),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Signature(
                              key: _signatureKey,
                              strokeWidth: 3,
                              color: const Color(0xff0039a6),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 24, 12, 0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                _signatureKey.currentState!.clear();
                              },
                              child: const Icon(
                                Icons.clear,
                                size: 34,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const TextSmall(label: "WKWP Representative Signature"),
                    Stack(
                      children: [
                        RepaintBoundary(
                          key: _containerKey2,
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                                color: Colors.white70,
                                border:
                                    Border.all(width: 5, color: Colors.blue),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Signature(
                              key: _signatureKey2,
                              strokeWidth: 3,
                              color: const Color(0xff0039a6),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 24, 12, 0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                _signatureKey2.currentState!.clear();
                              },
                              child: const Icon(
                                Icons.clear,
                                size: 34,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    const Divider(
                      color: Colors.red,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    const TextSmall(label: "Upload Scanned ARF (PDF only) *"),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: Colors.white70, width: 1)),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: ScannedFile.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _fileName = '';
                                        ScannedFile = '';
                                      });
                                    },
                                    child: Text(_fileName,
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.white)),
                                  )
                                : const Text(
                                    'No file picked',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['pdf'],
                              );

                              if (result != null) {
                                PlatformFile file = result.files.single;
                                File pickedFile = File(file.path!);
                                String fileName = file.name!;
                                String data =
                                    await convertFileToBase64(pickedFile);
                                setState(() {
                                  ScannedFile = data;
                                  _fileName = fileName;
                                });
                              }
                            },
                            child: const Text('Upload File'),
                          ),
                        ],
                      ),
                    ),
                    TextResponse(
                      label: error,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SubmitButton(
                        label: "Submit",
                        onButtonPressed: () async {
                          var value = await _captureSignature();
                          var value2 = await _captureSignature2();

                          setState(() {
                            erepsignature = value;
                            wkwprepsignature = value2;
                          });

                          setState(() {
                            isLoading =
                                LoadingAnimationWidget.horizontalRotatingDots(
                              color: Color.fromARGB(248, 186, 12, 47),
                              size: 100,
                            );
                          });
                          var res = await submitData(
                              activity,
                              organiser,
                              county,
                              subcounty,
                              ward,
                              village,
                              lat.toString(),
                              long.toString(),
                              type,
                              sector,
                              facilitator,
                              facOrg,
                              facPhone,
                              topic,
                              subtopic,
                              date,
                              description,
                              youths,
                              adults,
                              male,
                              female,
                              pwdattendees,
                              ScannedFile,
                              erepname,
                              erepdesignation,
                              wkwpname,
                              wkwpdesignation,
                              userid,
                              erepsignature,
                              wkwprepsignature);

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
                            Timer(const Duration(seconds: 2), () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const Home()));
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 12,
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
  String activity,
  String organiser,
  String county,
  String subcounty,
  String ward,
  String village,
  String lat,
  String long,
  String type,
  String sector,
  String facilitator,
  String facOrg,
  String facPhone,
  String topic,
  String subtopic,
  String date,
  String description,
  String youths,
  String adults,
  String male,
  String female,
  String pwdattendees,
  String ScannedFile,
  String erepname,
  String erepdesignation,
  String wkwpname,
  String wkwpdesignation,
  String userid,
  String erepSign,
  String mySign,
) async {
  if (activity.isEmpty ||
      organiser.isEmpty ||
      village.isEmpty ||
      type.isEmpty ||
      sector.isEmpty ||
      facilitator.isEmpty ||
      facOrg.isEmpty ||
      facPhone.isEmpty ||
      description.isEmpty ||
      topic.isEmpty ||
      subtopic.isEmpty ||
      erepname.isEmpty ||
      erepdesignation.isEmpty ||
      mySign.isEmpty ||
      erepSign.isEmpty) {
    return Message(
      token: null,
      success: null,
      error: "All Fields Must Be Filled!",
    );
  }

  try {
    var response = await http.post(
      Uri.parse("${getUrl()}arf/create"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'Latitude': lat,
        'Longitude': long,
        'ActivityName': activity,
        'ActivityOrganizer': organiser,
        'County': county,
        'SubCounty': subcounty,
        'Ward': ward,
        'Village': village,
        'ActivityType': type,
        'ActivitySector': sector,
        'FacilitatorName': facilitator,
        'FacilitatorOrganisation': facOrg,
        'FacilitatorContact': facPhone,
        'Description': description,
        'TrainingTopics': topic,
        'TrainingSubTopics': subtopic,
        'ActivityDescription': description,
        'Date': date,
        'NumberOfYouths': youths,
        'AdultsABove30': adults,
        'MaleAtendees': male,
        'FemaleAtendees': female,
        'PWDAtendees': pwdattendees,
        'ERepName': erepname,
        'ERepDesignation': erepdesignation,
        'ERepSignature': erepSign,
        'WKWPRepName': wkwpname,
        'WKWPRepDesignation': wkwpdesignation,
        'WKWPRepSignature': mySign,
        'File': ScannedFile,
        'UserID': userid
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 203) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      return Message.fromJson(jsonDecode(response.body));
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
