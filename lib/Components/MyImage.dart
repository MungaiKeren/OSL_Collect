// ignore_for_file: file_names
import 'package:flutter/material.dart';

class MyImage extends StatelessWidget {
  final String no;

  const MyImage({super.key, required this.no});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: SizedBox(
        height: 80,
        width: 80,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 47, 108, 1.0),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(0),
                  ),
                  border: Border.all(
                    color: const Color.fromRGBO(203, 203, 200, 1.0),
                    width: 1, // Border width
                  ),
                ),
              ),
            ),
            Positioned(
              top: 15,
              left: 15,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 47, 108, 1.0),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(0),
                  ),
                  border: Border.all(
                    color: const Color.fromRGBO(203, 203, 200, 1.0),
                    width: 2, 
                  ),
                ),
                child: Center(
                  child: Text(
                    no, 
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white, 
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
