// ignore_for_file: file_names, library_private_types_in_public_api
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:wkwp_mobile/Components/FormsBar.dart';
import '../Components/Utils.dart';
import '../Model/Item.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FormsScrollController extends StatefulWidget {
  final String id;
  final String status;
  final String active;
  final storage = const FlutterSecureStorage();

  const FormsScrollController({
    super.key,
    required this.id,
    required this.status,
    required this.active,
  });


  Future<List<Item>> fetchFormData() async {
    final response = await get(
      Uri.parse("${getUrl()}toolslist"),
    );

    List responseList = json.decode(response.body);
    List<Item> postList = responseList.map((data) => Item(data)).toList();
    return postList;
  }

  @override
  _FormsScrollControllerState createState() => _FormsScrollControllerState();
}


class _FormsScrollControllerState extends State<FormsScrollController> {
  final _numberOfPostsPerRequest = 5;
  String name = '';

  final PagingController<int, Item> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
      getUserInfo();
    });
  }

  @override
  void didUpdateWidget(covariant FormsScrollController oldWidget) {
    if (oldWidget.active != widget.active) {
      _pagingController.refresh();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await get(
        Uri.parse("${getUrl()}toolslist"),
      );

      List responseList = json.decode(response.body);
     
      List<Item> postList = responseList.map((data) => Item(data)).toList();

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
          itemBuilder: (context, item, index) => Padding(
            padding: const EdgeInsets.all(0),
            child: FormsBar(item: item, name: name),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
