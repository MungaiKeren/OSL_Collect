// ignore_for_file: file_names
import 'package:flutter/material.dart';

class ComponentImage extends StatelessWidget {
  final Image myimage;

  const ComponentImage({super.key, required this.myimage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: SizedBox(
        height: 60,
        width: 60,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                width: 40,
                height: 40,
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
              top: 10,
              left: 10,
              child: Container(
                width: 40,
                height: 40,
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
                child: Center(
                  child: myimage
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
