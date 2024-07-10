// ignore_for_file: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:wkwp_mobile/Components/IncidentBars/WPIncidentBar.dart';
import '../Components/Utils.dart';
import '../Model/Item.dart';
import 'IncidentBars/TAFIncidentBar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyScrollController extends StatefulWidget {
  final String id;
  final String status;
  final String active;
  final String day;
  final storage = const FlutterSecureStorage();

  MyScrollController(
      {super.key,
      required this.id,
      required this.status,
      required this.active,
      required this.day});

  @override
  _MyScrollControllerState createState() => _MyScrollControllerState();
}

class _MyScrollControllerState extends State<MyScrollController> {
  final _numberOfPostsPerRequest = 5;
  String name = '';

  final PagingController<int, Item> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    getUserInfo();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  

  @override
  void didUpdateWidget(covariant MyScrollController oldWidget) {
    if (oldWidget.active != widget.active) {
      _pagingController.refresh();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _fetchPage(int pageKey) async {
    var offset = pageKey == 0 ? pageKey : pageKey + _numberOfPostsPerRequest;
    try {
      final response = await get(
        Uri.parse("${getUrl()}workplan/status/${widget.status}"),
      );

      List responseList = json.decode(response.body);

      List<Item> postList = responseList.map((data) => Item(data)).toList();

      print("workplan list: $response");

      final isLastPage = postList.length < _numberOfPostsPerRequest;

      if (isLastPage) {
        _pagingController.appendLastPage(postList);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(postList, nextPageKey);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  Future<void> getUserInfo() async {
    const storage = FlutterSecureStorage();

    var token = await storage.read(key: "WKWPjwt");
    var decoded = parseJwt(token.toString());

    setState(() {
      name = decoded["Name"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => _pagingController.refresh()),
      child: PagedListView<int, Item>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Item>(
            itemBuilder: (context, item, index) {
          String currentDay = item.item["Date"] ?? "";
          if (item.item["Date"] == widget.day) {
            print("date items: ${widget.day}");
            return Padding(
              padding: const EdgeInsets.all(0),
              child: WPIncidentBar(item: item, name: name),
            );
          } else {
            // return Padding(
            //   padding: const EdgeInsets.all(0),
            //   child: IncidentBar(item: item, name: name),
            // );

            return Container(child: Text("Select Day"));
          }
        }),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
