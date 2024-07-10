// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:wkwp_mobile/Pages/WorkPlanInfo.dart';

class WPIncidentBar extends StatefulWidget {
  final dynamic item;
  final String name;

  const WPIncidentBar({
    super.key,
    required this.item,
    required this.name,
  });

  @override
  State<StatefulWidget> createState() => _StatState();
}

class _StatState extends State<WPIncidentBar> {
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => WorkPlanInfo(
                            item: widget.item.item,
                                // id: widget.item.item['ID'],
                                // name: widget.item.item['MelIndicator'],
                              )));
                },
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Text(widget.item.item['Date'],
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                            )),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              widget.item.item['Description'],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.item.item['MelIndicator'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.lightGreen,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "${widget.item.item['Partner']}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ])
                    ],
                  ),
                ))));
  }
}
