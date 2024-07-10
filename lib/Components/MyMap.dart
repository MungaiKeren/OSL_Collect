// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'Utils.dart';

class MyMap extends StatefulWidget {
  final double lat;
  final double lon;
  const MyMap({Key? key, required this.lat, required this.lon})
      : super(key: key);

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late WebViewController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading = null;

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
            controller
                .runJavaScript('adjustMarker(${widget.lon},${widget.lat})');
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
      ..loadRequest(Uri.parse('${getUrl()}map'));

    super.initState();
  }

  @override
  void didUpdateWidget(covariant MyMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.runJavaScript('adjustMarker(${widget.lat},${widget.lon})');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          Center(
            child: isLoading,
          )
        ],
      ),
    );
  }
}
