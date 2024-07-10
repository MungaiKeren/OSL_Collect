// ignore_for_file: file_names
import 'package:wkwp_mobile/Pages/FormTemplate.dart';
import 'package:flutter/material.dart';

class FormsBar extends StatefulWidget {
  final dynamic item;
  final String name;

  const FormsBar({
    super.key,
    required this.item,
    required this.name,
  });

  @override
  State<StatefulWidget> createState() => _StatState();
}

class _StatState extends State<FormsBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
        child: Card(
            elevation: 5,
            color: Colors.white.withOpacity(0.8),
            clipBehavior: Clip.hardEdge,
            child: TextButton(
                onPressed: () {
                  print("custom form info: ${widget.item.item}");

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => FormsTemplate(
                              tbname: widget.item.item['DataTableName'],
                              toolname: widget.item.item['ToolName'])));
                },
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Text(widget.item.item['ToolName'],
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                            )),
                      ),
                    ],
                  ),
                ))));
  }
}
