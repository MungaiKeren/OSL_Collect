// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, file_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wkwp_mobile/Components/MyCalendar.dart';
import 'package:wkwp_mobile/Components/MyCheckBox.dart';
import 'package:wkwp_mobile/Components/MyDrawer.dart';
import 'package:wkwp_mobile/Components/MyTextInput.dart';
import 'package:wkwp_mobile/Pages/ARF/SubmitButton.dart';
import 'package:wkwp_mobile/Components/TextResponse.dart';
import 'package:wkwp_mobile/Components/TextSmall.dart';
import 'package:wkwp_mobile/Components/Utils.dart';
import 'package:wkwp_mobile/Model/SearchItem.dart';
import 'package:wkwp_mobile/Pages/Home.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';

class TAF extends StatefulWidget {
  const TAF({super.key});

  @override
  State<TAF> createState() => _TAFState();
}

class _TAFState extends State<TAF> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final storage = const FlutterSecureStorage();
  late StreamSubscription<Position> positionStream;

  bool servicestatus = false;
  late LocationPermission permission;
  bool haspermission = false;
  late Position position;
  List<SearchItem> entries = <SearchItem>[];

  String long = '';
  String lat = '';
  String error = '';
  String beneficiary = '';
  String beneficiarytype = '';
  String village = '';
  String county = '';
  String subcounty = '';
  String ward = '';
  String name = '';
  String phone = '';
  String designation = '';
  List<String> taprovided = [];
  List<String> mode = [];
  String description = '';
  String date = '';
  String erepname = '';
  String erepdesignation = '';
  String erepsignature = '';
  String wkwprepname = '';
  String wkwprepdesignation = '';
  String wkwprepsignature = '';
  String check = '';
  String userid = '';
  String wkwpname = '';
  String wkwpdesignation = '';
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
    final sign = _signatureKey.currentState;
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

  searchBeneficiary(q) async {
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

  Future<void> getUserInfo() async {
    var token = await storage.read(key: "WKWPjwt");
    var decoded = parseJwt(token.toString());

    setState(() {
      userid = decoded["UserID"];
      wkwpname = decoded["Name"];
      wkwpdesignation = decoded["Position"];
    });
  }

  @override
  void initState() {
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
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
                          "Technical Assistant Form",
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const TextSmall(label: "Name of Beneficiary"),
                      const SizedBox(
                        height: 8,
                      ),
                      beneficiary.isNotEmpty
                          ? Text(
                              beneficiary,
                              style: const TextStyle(color: Colors.white54),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: TextFormField(
                            onChanged: (value) {
                              if (value.characters.length >=
                                  check.characters.length) {
                                searchBeneficiary(value);
                              } else {
                                setState(() {
                                  entries.clear();
                                  beneficiary = '';
                                  beneficiarytype = '';
                                  village = '';
                                  long = '';
                                  lat = '';
                                });
                              }
                              setState(() {
                                check = value;
                                error = '';
                              });
                            },
                            keyboardType: TextInputType.text,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(24, 8, 24, 0),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 0xBA, 0x0C, 0x2F),
                                        width: 2.0)),
                                filled: false,
                                label: Text(
                                  "Search Beneficiary",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always)),
                      ),
                      entries.isNotEmpty
                          ? Card(
                              elevation: 12,
                              child: ListView.separated(
                                padding: const EdgeInsets.all(4),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: entries.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return TextButton(
                                    onPressed: () {
                                      setState(() {
                                        beneficiary = entries[index].Name;
                                        beneficiarytype = entries[index].Type;
                                        county = entries[index].County;
                                        subcounty = entries[index].SubCounty;
                                        ward = entries[index].Ward;
                                        village = entries[index].Village;
                                        long = entries[index].Logitude;
                                        lat = entries[index].Latitude;
                                        entries.clear();
                                      });
                                    },
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            'Name: ${entries[index].Name}, Type: ${entries[index].Type}')),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(),
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 12,
                      ),
                      const TextSmall(label: "Date of Visit/TA"),
                      MyCalendar(
                        value: date,
                        lines: 1,
                        onSubmit: (value) {
                          setState(() {
                            date = value;
                          });
                        },
                        label: 'Click To Select',
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const TextSmall(label: "Contact Person Name"),
                      MyTextInput(
                        lines: 1,
                        value: '',
                        type: TextInputType.text,
                        onSubmit: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                        title: 'Contact Person Name',
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const TextSmall(label: "Contact Person Phone"),
                      MyTextInput(
                        lines: 1,
                        value: '',
                        type: TextInputType.phone,
                        onSubmit: (value) {
                          setState(() {
                            phone = value;
                          });
                        },
                        title: 'Contact Person Phone',
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const TextSmall(label: "Contact Person Designation"),
                      MyTextInput(
                        lines: 1,
                        value: '',
                        type: TextInputType.text,
                        onSubmit: (value) {
                          setState(() {
                            designation = value;
                          });
                        },
                        title: 'Contact Person Designation',
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const TextSmall(label: "Type of TA Provided"),
                      MyCheckBox(
                        onSubmit: (value) {
                          setState(() {
                            taprovided = value;
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
                        selectedOptions: taprovided,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const TextSmall(label: "TA Through"),
                      MyCheckBox(
                        onSubmit: (value) {
                          setState(() {
                            mode = value;
                          });
                        },
                        options: const [
                          "Training",
                          "Grant",
                          "Meeting/Coaching/Mentoring",
                          "Other"
                        ],
                        selectedOptions: mode,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const TextSmall(
                          label: "Brief Description of TA Provided"),
                      MyTextInput(
                        lines: 1,
                        value: '',
                        type: TextInputType.text,
                        onSubmit: (value) {
                          setState(() {
                            description = value;
                          });
                        },
                        title: 'Brief Description of TA Provided',
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const TextSmall(label: "Sign Off"),
                      const SizedBox(
                        height: 12,
                      ),
                      const TextSmall(label: "Entity Representative Name"),
                      MyTextInput(
                        lines: 1,
                        value: '',
                        type: TextInputType.text,
                        onSubmit: (value) {
                          setState(() {
                            erepname = value;
                          });
                        },
                        title: 'Entity Representative Name',
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const TextSmall(
                          label: "Entity Representative Designation"),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
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
                      const TextSmall(label: "Upload Scanned TAF (PDF only) *"),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border:
                                Border.all(color: Colors.white70, width: 1)),
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
                                              fontSize: 18,
                                              color: Colors.white)),
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
                      const SizedBox(
                        height: 12,
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
                                color: const Color.fromARGB(248, 186, 12, 47),
                                size: 100,
                              );
                            });

                            var res = await submitData(
                                beneficiary,
                                beneficiarytype,
                                county,
                                subcounty,
                                ward,
                                village,
                                date,
                                long,
                                lat,
                                name,
                                phone,
                                designation,
                                taprovided,
                                mode,
                                description,
                                ScannedFile,
                                erepname,
                                erepdesignation,
                                userid,
                                wkwpname,
                                wkwpdesignation,
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
      ),
    );
  }
}

Future<Message> submitData(
    String beneficiary,
    String beneficiarytype,
    String county,
    String subcounty,
    String ward,
    String village,
    String date,
    String long,
    String lat,
    String name,
    String phone,
    String designation,
    List<String> taprovided,
    List<String> mode,
    String description,
    String ScannedFile,
    String erepname,
    String erepdesignation,
    String userid,
    String wkwpname,
    String wkwpdesignation,
    String erepSign,
    String mySign) async {
  if (beneficiary.isEmpty ||
      beneficiarytype.isEmpty ||
      subcounty.isEmpty ||
      county.isEmpty ||
      ward.isEmpty ||
      long.isEmpty ||
      lat.isEmpty ||
      date.isEmpty ||
      name.isEmpty ||
      phone.isEmpty ||
      designation.isEmpty ||
      taprovided.isEmpty ||
      mode.isEmpty ||
      description.isEmpty ||
      erepSign.isEmpty ||
      erepname.isEmpty ||
      mySign.isEmpty) {
    return Message(
      token: null,
      success: null,
      error: "All Fields Must Be Filled!",
    );
  }

  try {
    var response = await http.post(
      Uri.parse("${getUrl()}taf/create"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'Beneficiary': beneficiary,
        'BeneficiaryType': beneficiarytype,
        'County': county,
        'SubCounty': subcounty,
        'Ward': ward,
        'Village': village,
        'Date': date,
        'Longitude': long,
        'Latitude': lat,
        'ContactName': name,
        'ContactPhone': phone,
        'Designation': designation,
        'TA_Provided': taprovided.join(', '),
        'TAThrough': mode.join(', '),
        'TADescription': description,
        'ERepSignature': erepSign,
        'ERepName': erepname,
        'ERepDesignation': erepdesignation,
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
