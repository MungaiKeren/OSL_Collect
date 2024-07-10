import 'package:flutter/material.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:wkwp_mobile/Components/Intro1.dart';
import 'package:wkwp_mobile/Components/Intro2.dart';
import 'package:wkwp_mobile/Components/Intro3.dart';
import 'dart:async';

import 'package:wkwp_mobile/Pages/Login.dart';

void main() {
  runApp(const ScrollScreen());
}

class ScrollScreen extends StatelessWidget {
  const ScrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ScrollableScreen(),
    );
  }
}

class ScrollableScreen extends StatefulWidget {
  const ScrollableScreen({super.key});

  @override
  _ScrollableScreenState createState() => _ScrollableScreenState();
}

class _ScrollableScreenState extends State<ScrollableScreen> {
  final PageController _pageController = PageController();
  final List<Widget> screens = [
    const Intro1(),
    const Intro2(),
    const Intro3(),
  ];

  final _currentPageNotifier = ValueNotifier<int>(0);
  late Timer _timer;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _changePage();
    });
  }

  void _changePage() {
    final nextPage = (_currentPageIndex + 1) % screens.length;
    _pageController.animateToPage(
      nextPage,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
    _currentPageNotifier.value = nextPage;
    _currentPageIndex = nextPage;

    if (nextPage == 2) {
      _timer.cancel();
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                const Login(), // Replace with your login page widget
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();

    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
             Color.fromRGBO(3, 48, 110, 1),
              Color.fromRGBO(0, 96, 177, 1)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Add CirclePageIndicator here with padding
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
              child: CirclePageIndicator(
                itemCount: screens.length,
                currentPageNotifier: _currentPageNotifier,
                size: 10,
                dotColor: Colors.grey,
                selectedDotColor: Colors.red,
                selectedSize: 12,
              ),
            ),
            // Add PageView here
            Expanded(
              child: PageView(
                controller: _pageController,
                children: screens,
                onPageChanged: (int index) {
                  _currentPageNotifier.value = index;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
