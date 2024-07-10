// ignore_for_file: prefer_typing_uninitialized_variables, file_names, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wkwp_mobile/Components/WorkPlanBar.dart';
import 'package:wkwp_mobile/Components/Utils.dart';
import 'package:wkwp_mobile/Pages/WorkPlans.dart';

class WorkPlanInfo extends StatefulWidget {
  final Map<String, dynamic> item;
  // final String id;
  // final String name;
  const WorkPlanInfo({super.key, required this.item});

  @override
  State<WorkPlanInfo> createState() => _WorkPlanInfoState();
}

class _WorkPlanInfoState extends State<WorkPlanInfo> {
  var isLoading;
  bool reviewed = false;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    setState(() {
      isLoading = LoadingAnimationWidget.horizontalRotatingDots(
        color: Color.fromARGB(248, 186, 12, 47),
        size: 100,
      );
    });


    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Work Plan",
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text(
            "Workplan",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const WorkPlan()))
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          backgroundColor: const Color.fromRGBO(3, 48, 110, 1),
        ),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: widget.item.isNotEmpty
                ? SingleChildScrollView(child: WorkPlanBar(item: widget.item))
                : const SizedBox(),
          ),
        ]),
      ),
    );
  }
}
