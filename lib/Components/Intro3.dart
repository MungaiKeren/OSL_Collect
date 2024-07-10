// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:wkwp_mobile/Pages/Login.dart';

class Intro3 extends StatelessWidget {
  const Intro3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Automated\nReporting',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Center(
          child: Image.asset(
            'assets/images/intro3.png',
            width: 250, // Set the desired width
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: GestureDetector(
             onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Login())),
            child: const Text(
              'Skip',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
