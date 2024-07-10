// ignore_for_file: use_build_context_synchronously, non_constant_identifier_villages, unused_import, file_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
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
import 'package:wkwp_mobile/Pages/RMF/PolicyGov.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';

class SignOff extends StatefulWidget {
  const SignOff({super.key});

  @override
  State<SignOff> createState() => _SignOffState();
}

class _SignOffState extends State<SignOff> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final storage = const FlutterSecureStorage();

  String error = '';

  String erepname = '';
  String erepdesignation = '';
  String erepsignature = '';
  String userid = '';
  String wkwpname = '';
  String wkwpdesignation = '';
  String wkwprepsignature = '';

  String ScannedFile = '';
  String _fileName = '';

  var isLoading;

  final GlobalKey<SignatureState> _signatureKey = GlobalKey<SignatureState>();
  final GlobalKey _containerKey = GlobalKey();
  final GlobalKey<SignatureState> _signatureKey2 = GlobalKey<SignatureState>();
  final GlobalKey _containerKey2 = GlobalKey();

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
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Components()))
                              },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                    ),
                    const Text(
                      "RMF - Sign Off",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
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
                      title: 'Entity Representative Name',
                    ),
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
                      height: 12,
                    ),
                    const TextSmall(label: "Upload Scanned RMF (PDF only) *"),
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
                        label: "Finish",
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
                              userid,
                              ScannedFile,
                              erepname,
                              erepdesignation,
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
                            storage.delete(key: "RMFID");
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
    String userid,
    String ScannedFile,
    String erepname,
    String erepdesignation,
    String wkwpname,
    String wkwpdesignation,
    String erepSign,
    String mySign) async {
  if (mySign.isEmpty ||
      erepSign.isEmpty ||
      erepdesignation.isEmpty ||
      erepname.isEmpty) {
    return Message(
      token: null,
      success: null,
      error: "All Fields Must Be Filled!",
    );
  }

  try {
    const storage = FlutterSecureStorage();

    var id = await storage.read(key: "RMFID");

    var response = await http.put(
      Uri.parse("${getUrl()}rmf/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
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
