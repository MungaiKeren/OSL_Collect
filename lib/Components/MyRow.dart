// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:wkwp_mobile/Components/MyImage.dart';

class MyRow extends StatefulWidget {
  final String no;
  final String title;
  const MyRow({super.key, required this.no, required this.title});

  @override
  State<MyRow> createState() => _MyRowState();
}

class _MyRowState extends State<MyRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromRGBO(203, 203, 200, 1.0),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white, // white color
            width: 1,
          )),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyImage(no: widget.no),
            const SizedBox(
              width: 16,
            ),
            Text(
              widget.title,
              style: const TextStyle(
                  fontSize: 30,
                  color: Color.fromRGBO(34, 73, 126, 1.0),
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
