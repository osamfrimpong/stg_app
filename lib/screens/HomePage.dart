import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:stg_app/models/Content.dart';
import 'package:stg_app/models/SubItem.dart';

class HomePage extends StatelessWidget {
  final List<Content> items = List<Content>.generate(
      25,
      (index) => Content(
          title: "Disorders of the Gastrointestinal Tract",
          subItems: [SubItem(title: "Diarrhoea", address: "index.html")]));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("STG"),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.dashboard),
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
            return _faqItem(items[index], index: index);
          }),
      drawer: Drawer(
        child: ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _faqItem(items[index], index: index);
            }),
      ),
    );
  }

  Widget _faqItem(Content content, {int index}) {
    return ExpandableNotifier(
      child: ScrollOnExpand(
        scrollOnExpand: true,
        child: Card(
          child: ExpandablePanel(
            header: Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
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
                subtitle: Text(" ${content.title}"),
              ),
            ),
            expanded: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: content.subItems
                    .map((e) => Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(e.title),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
