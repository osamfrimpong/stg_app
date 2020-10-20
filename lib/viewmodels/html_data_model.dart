import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:stg_app/models/HTML_item.dart';
import 'package:stg_app/models/SubItem.dart';

class HTMLDataModel extends ChangeNotifier {
  HTMLDataModel();

  Future<HTMLItem> loadHTML(SubItem subItem) async {
    return loadDatabaseItem(subItem);
  }

  Future<HTMLItem> loadDatabaseItem(SubItem subItem) async {
    final box = Hive.lazyBox<HTMLItem>('htmlItemBox');
    return box.get(subItem.address);
  }
}
