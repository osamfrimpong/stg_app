import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:share/share.dart';
import 'package:stg_app/controllers/custom_search_delegate.dart';
import 'package:stg_app/models/Content.dart';
import 'package:stg_app/models/SubItem.dart';
import 'package:stg_app/models/podo/ContentPODO.dart';
import 'package:stg_app/screens/About.dart';
import 'package:stg_app/screens/Data.dart';
import 'package:stg_app/screens/Details.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stg_app/screens/Favourites.dart';
import 'package:stg_app/screens/provider_details.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("STG 2017"),
        elevation: 0.0,
        actions: [
          ValueListenableBuilder(
              valueListenable: Hive.box<SubItem>('entriesBox').listenable(),
              builder: (context, Box<SubItem> box, _) {
                final searchItems = box.values.toList().cast<SubItem>();
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch<SubItem>(
                      context: context,
                      delegate: CustomSearchDelegate(searchItems),
                    );
                  },
                );
              }),
          IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Data()));
              }),
          IconButton(
            icon: Icon(AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
                ? Icons.brightness_2
                : Icons.wb_sunny),
            onPressed: () {
              AdaptiveTheme.of(context).toggleThemeMode();
            },
          ),
          PopupMenuButton(
            onSelected: (value) {
              if (value == "about") {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => About()));
              } else if (value == "share") {
                Share.share("Get App from playstore");
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(child: Text('About'), value: "about"),
              PopupMenuItem(child: Text('Share'), value: "share"),
            ],
          )
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<Content>('contentsBox').listenable(),
          builder: (context, Box<Content> box, _) {
            final contents = box.values.toList().cast<Content>();
            return box.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "No Content!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                        ),
                        Text(
                          "Press Button to Load!",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18.0),
                        ),
                        IconButton(
                            icon: Icon(Icons.cloud_download),
                            iconSize: 54.0,
                            onPressed: () {
                              _loadContent()
                                  .then((value) => addContents(value))
                                  .then((value) {
                                Get.to(Data());
                              });
                            }),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: contents.length,
                    itemBuilder: (context, index) {
                      return _contentItem(contents[index],
                          index: index, context: context);
                    });
          }),
      drawer: ValueListenableBuilder(
          valueListenable: Hive.box<Content>('contentsBox').listenable(),
          builder: (context, Box<Content> box, _) {
            final contents = box.values.toList().cast<Content>();
            return Drawer(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return _newItem(
                      contents[index],
                      index: index,
                      context: context,
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                        height: 5.0,
                        thickness: 1.0,
                      ),
                  itemCount: contents.length),
            );
          }),
    );
  }

  Widget _contentItem(Content content, {int index, BuildContext context}) {
    return ExpandableNotifier(
      child: ScrollOnExpand(
        scrollOnExpand: true,
        child: Card(
          child: ExpandablePanel(
            header: Padding(
              padding: const EdgeInsets.only(
                top: 5.0,
                bottom: 5.0,
              ),
              child: ListTile(
                title: Text(
                  "Chapter ${index + 1}",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text("${content.title}"),
              ),
            ),
            expanded: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(content.subItems[index].title),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProviderDetails(
                            subItem: content.subItems[index],
                          ),
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) => Divider(
                      height: 5.0,
                      thickness: 1.0,
                    ),
                itemCount: content.subItems.length),
          ),
        ),
      ),
    );
  }

  Widget _newItem(Content content, {int index, BuildContext context}) {
    return ExpansionTile(
      title: Text("Chapter ${index + 1}"),
      subtitle: Text("${content.title}"),
      children: [
        ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(content.subItems[index].title),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Details(
                            subItem: content.subItems[index],
                          )));
                },
              );
            },
            separatorBuilder: (context, index) => Divider(
                  height: 5.0,
                  thickness: 1.0,
                ),
            itemCount: content.subItems.length)
      ],
    );
  }

  Future<List<ContentPODO>> _loadContent() async {
    // String rawData = await rootBundle
    //     .loadString("assets/json/table_of_contents.json", cache: true);
    try {
      // final Dio dio = Dio();
      // Response response = await dio.get(
      //     "https://osamfrimpong.github.io/stg_app_web/json/table_of_contents.json");
      var response = await http.get(
          "https://osamfrimpong.github.io/stg_app_web/json/table_of_contents.json");
      print("Output data: ${response.body}");
      final contentsJSON = jsonDecode(response.body.toString()) as List;
      List<ContentPODO> contentsList =
          contentsJSON.map((e) => ContentPODO.fromJson(e)).toList();
      return contentsList;
    } catch (e) {
      print(e.toString());
    }
  }

  void addContents(List<ContentPODO> contents) {
    List<Content> contentList = contents
        .map((content) => Content(
            id: content.chapter,
            title: content.title,
            subItems: content.subItems
                .map((item) => SubItem(
                    id: item.id, title: item.title, address: item.address))
                .toList()))
        .toList();

    final contentBox = Hive.box<Content>('contentsBox');
    contentBox.clear().then((value) => contentBox
        .addAll(contentList)
        .then((value) => addEntries(contentList)));
  }

  void addEntries(List<Content> contents) {
    final entriesBox = Hive.box<SubItem>('entriesBox');
    contents.forEach((element) {
      entriesBox.addAll(element.subItems);
    });
  }
}
