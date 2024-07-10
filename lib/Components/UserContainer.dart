// ignore_for_file: file_names
import 'package:flutter/material.dart';

class UserContainer extends StatelessWidget {
  UserContainer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withOpacity(0.9),
              width: 1,
            )),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: Image.asset(
            'assets/images/person.png',
            width: 24,
          ),
        ),
      ),
    );
  }
}
