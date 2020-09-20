import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:stg_app/models/Content.dart';
import 'package:stg_app/models/SubItem.dart';
import 'package:stg_app/models/podo/ContentPODO.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Data extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox('contentsBox'),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Data Screen"),
          ),
          body: Container(
            color: Colors.white,
            child: Center(
              child: snapshot.hasData
                  ? Column(
                      children: [
                        ValueListenableBuilder(
                            valueListenable:
                                Hive.box('contentsBox').listenable(),
                            builder: (context, box, widget) {
                              return Text(snapshot.data.length.toString());
                            }),
                        RaisedButton(onPressed: () {
                          _loadContent().then((value) => addContents(value));
                        })
                      ],
                    )
                  : CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }

  Future<List<ContentPODO>> _loadContent() async {
    String rawData = await rootBundle
        .loadString("assets/json/table_of_contents.json", cache: true);
    final contentsJSON = jsonDecode(rawData) as List;
    List<ContentPODO> contentsList =
        contentsJSON.map((e) => ContentPODO.fromJson(e)).toList();
    return contentsList;
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

    final contentBox = Hive.box('contentsBox');
    contentBox.clear().then((value) => contentBox.addAll(contentList));
  }
}
