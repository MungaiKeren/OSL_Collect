// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wkwp_mobile/Components/MyTextInput.dart';
import 'package:wkwp_mobile/Components/ForgotPasswordDialog.dart';
import 'package:wkwp_mobile/Pages/ARF/SubmitButton.dart';
import 'package:wkwp_mobile/Components/TextResponse.dart';
import 'package:wkwp_mobile/Components/Utils.dart';
import 'package:wkwp_mobile/Pages/Home.dart';
import 'package:wkwp_mobile/Pages/Privacy.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String error = '';
  String email = '';
  String password = '';
  var isLoading;
  bool termsAccepted = false; // Added boolean to track terms acceptance

  final storage = const FlutterSecureStorage();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void resetPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ForgotPasswordDialog();
      },
    );
  }

  goToHome() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const Home()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Staff Login",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 250, 246, 246),
                      ),
                    ),
                    TextResponse(label: error),
                    MyTextInput(
                      title: 'Email Address',
                      lines: 1,
                      value: '',
                      type: TextInputType.emailAddress,
                      onSubmit: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    MyTextInput(
                      title: 'Password',
                      lines: 1,
                      value: '',
                      type: TextInputType.visiblePassword,
                      onSubmit: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                      Row(
                      children: [
                        Checkbox(
                          value: termsAccepted,
                          onChanged: (value) {
                            setState(() {
                              termsAccepted = value!;
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const Privacy()));
                          },
                          child: const Text(
                            'I accept the Terms & Conditions',
                            style: TextStyle(
                              fontSize: 16.0,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () => resetPassword(),
                        child: const Text(
                          "Reset Password",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SubmitButton(
                        label: "Login",
                        onButtonPressed: () async {
                          if (!termsAccepted) {
                            // Show error message if terms not accepted
                            setState(() {
                              error = 'Please accept Terms & Conditions';
                            });
                            return;
                          }
                          // return  goToHome();
                          setState(() {
                            error = "";
                            isLoading =
                                LoadingAnimationWidget.horizontalRotatingDots(
                              color: const Color.fromARGB(248, 186, 12, 47),
                              size: 100,
                            );
                          });
                          var res = await submitData(email, password);
                          setState(() {
                            isLoading = null;
                            if (res.error == null) {
                              error = res.success;
                            } else {
                              error = res.error;
                            }
                          });
                          if (res.error == null) {
                            print("the response is $res");
                            await storage.write(
                                key: 'WKWPjwt', value: res.token);
                            goToHome();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(child: isLoading),
          ],
        ),
      ),
    );
  }
}

Future<Message> submitData(String email, String password) async {
  if (email.isEmpty || !EmailValidator.validate(email)) {
    return Message(
      token: null,
      success: null,
      error: "Email is invalid!",
    );
  }

  if (password.length < 6) {
    return Message(
      token: null,
      success: null,
      error: "Password is too short!",
    );
  }

  try {
    final response = await http.post(
      Uri.parse("${getUrl()}mobile/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'Email': email, 'Password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 203) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      return Message(
        token: null,
        success: null,
        error: "Connection to server failed!",
      );
    }
  } catch (e) {
    print("error $e");
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
