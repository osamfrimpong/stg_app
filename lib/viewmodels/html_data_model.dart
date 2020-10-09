import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class HTMLDataModel{

  String _htmlData;

  get htmlData => _htmlData;

  HTMLDataModel(){}

  Future<String> loadItemAsset(String address) async {
    String rawData =
    await rootBundle.loadString("assets/html/$address", cache: true);
    return rawData;

  }

  void loadDatabaseItem(String address) async{

  }
}