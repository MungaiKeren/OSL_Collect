// ignore_for_file: file_names, unused_import
import 'package:flutter/material.dart';
import 'package:wkwp_mobile/Pages/WorkPlanInfo.dart';

class ARFIncidentBar extends StatefulWidget {
  final dynamic item;
  final String name;

  const ARFIncidentBar({
    super.key,
    required this.item,
    required this.name,
  });

  @override
  State<StatefulWidget> createState() => _StatState();
}

class _StatState extends State<ARFIncidentBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
        child: Card(
            elevation: 5,
            color: Colors.white,
            clipBehavior: Clip.hardEdge,
            child: TextButton(
                onPressed: () {
                 
                },
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Text(widget.item.item['ActivityName'],
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                            )),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        "${widget.item.item['Date']}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
