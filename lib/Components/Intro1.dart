// ignore_for_file: file_names, use_super_parameters, avoid_unnecessary_containers
import 'package:flutter/material.dart';
import 'package:wkwp_mobile/Pages/Login.dart';

class Intro1 extends StatelessWidget {
  const Intro1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Feed\nFormulation',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/intro1.png',
              width: 250, // Set the desired width
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Login())),
              child: const Text(
                'Skip',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
