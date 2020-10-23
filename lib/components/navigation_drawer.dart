import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stg_app/models/Content.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stg_app/screens/provider_details.dart';

Widget navigationDrawer = ValueListenableBuilder(
    valueListenable: Hive.box<Content>('contentsBox').listenable(),
    builder: (context, Box<Content> box, _) {
      final contents = box.values.toList().cast<Content>();
      return Drawer(
        child: ListView.separated(
            itemBuilder: (context, index) {
              return _drawerItem(
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
    });

Widget _drawerItem(Content content, {int index, BuildContext context}) {
  return ExpansionTile(
    title: Text("Chapter ${index + 1}"),
    subtitle: Text("${content.title}"),
    children: [
      ListView.separated(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(content.subItems[index].title),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProviderDetails(
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
