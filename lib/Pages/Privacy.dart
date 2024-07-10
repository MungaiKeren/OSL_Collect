// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wkwp_mobile/Components/MyDrawer.dart';
// #docregion platform_imports
// Import for Android features.
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
// #enddocregion platform_imports

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  late WebViewController controller;
  var isLoading;

  @override
  void initState() {
    setState(() {
      isLoading = LoadingAnimationWidget.horizontalRotatingDots(
          color: Colors.yellow, size: 100);
    });
    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    params = const PlatformWebViewControllerCreationParams();

    controller = WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              isLoading = null;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isLoading = null;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://mande.dat.co.ke/privacy'));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Jokes Puzzle',
        home: Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.white,
            title: const Text("Privacy Policy"),
            backgroundColor: const Color.fromARGB(255, 28, 100, 140),
          ),
          drawer: const Drawer(child: MyDrawer()),
          
          body: Stack(
            children: [
              WebViewWidget(controller: controller),
              Center(
                child: isLoading,
              )
            ],
          ),
        ));
  }
}
