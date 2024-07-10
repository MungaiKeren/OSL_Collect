// ignore_for_file: file_names
import 'package:flutter/material.dart';

class ReportBar extends StatefulWidget {
  final dynamic item;

  const ReportBar({
    super.key,
    required this.item,
  });

  @override
  State<ReportBar> createState() => _ReportBar();
}

class _ReportBar extends State<ReportBar> {
  String my = '';
  var isLoading;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //  decoration: const BoxDecoration(
      //     gradient: LinearGradient(
      //   colors: [Color.fromRGBO(3, 48, 110, 1), Color.fromRGBO(0, 96, 177, 1)],
      //   begin: Alignment.topCenter,
      //   end: Alignment.bottomCenter,
      // )),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(3, 48, 110, 1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white, // white color
                        width: 1,
                      )),
                  child: Column(children: [
                    Text(
                      "Title: ${widget.item["Task"]}",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Task ID: " + widget.item["ID"],
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Due Date: " + widget.item["Date"],
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Stakeholder: " + widget.item["Stakeholder"],
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(3, 48, 110, 1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white, // white color
                        width: 1,
                      )),
                  child: Column(children: [
                    const Text(
                      "Resources Needed",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.item["ToolsRequired"] == null
                            ? "Resource Needed: " + ''
                            : "Resource Needed: ${widget.item["ToolsRequired"]}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "About Task: " + widget.item["Description"],
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(3, 48, 110, 1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white, // white color
                        width: 1,
                      )),
                  child: Column(children: [
                    const Text(
                      "Task Remarks",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Your Remarks: " + widget.item["TaskRemarks"],
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Supervisor Remarks: " +
                            widget.item["SupervisorRemarks"],
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Task Type: " + widget.item["Type"],
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                  ]),
                ),
              ),
            ],
          )),
    );
  }
}
