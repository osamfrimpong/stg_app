import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:stg_app/models/HTML_item.dart';
import 'package:stg_app/models/SubItem.dart';

class HTMLDataModel extends ChangeNotifier {
  HTMLDataModel();

  Future<HTMLItem> loadHTML(SubItem subItem) async {
    return loadDatabaseItem(subItem);
  }

  // Future<HTMLItem> loadItemAsset(SubItem subItem) async {
  //   String rawData = await rootBundle
  //       .loadString("assets/html/${subItem.address}", cache: true);
  //   return HTMLItem(address: subItem.address, content: rawData, id: subItem.id);
  // }

  Future<HTMLItem> loadDatabaseItem(SubItem subItem) async {
    final box = Hive.lazyBox<HTMLItem>('htmlItemBox');
    print("Box Item: ${box.get(subItem.address)}");
    return box.get(subItem.address);
  }
}
