// ignore_for_file: file_names
import 'package:flutter/material.dart';

class FootNote extends StatelessWidget {
  const FootNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: const Center(
          child: Column(
            children: [
              Text(
                'Powered by',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Oakar Service LTD',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'www.osl.co.ke',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
