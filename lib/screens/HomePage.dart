import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:stg_app/models/Content.dart';
import 'package:stg_app/models/SubItem.dart';
import 'package:stg_app/screens/Data.dart';
import 'package:stg_app/screens/Details.dart';

class HomePage extends StatelessWidget {
  final List<Content> items = List<Content>.generate(
      25,
      (index) =>
          Content(title: "Disorders of the Gastrointestinal Tract", subItems: [
            SubItem(title: "Preface", address: "preface.html"),
            SubItem(title: "Stridor", address: "stridor.html"),
            SubItem(title: "Preface", address: "preface.html"),
            SubItem(title: "Stridor", address: "stridor.html"),
            SubItem(title: "Preface", address: "preface.html"),
            SubItem(title: "Stridor", address: "stridor.html"),
          ]));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("STG"),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
                ? Icons.brightness_3
                : Icons.wb_sunny),
            onPressed: () {
              AdaptiveTheme.of(context).toggleThemeMode();
            },
          ),
        ],
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return _contentItem(items[index], index: index, context: context);
          }),
      drawer: Drawer(
        child: ListView.separated(
            itemBuilder: (context, index) {
              return _newItem(
                items[index],
                index: index,
                context: context,
              );
            },
            separatorBuilder: (context, index) => Divider(
                  height: 5.0,
                  thickness: 1.0,
                ),
            itemCount: items.length),
      ),
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
                          builder: (context) => Data(),
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
                            content: content,
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
}
