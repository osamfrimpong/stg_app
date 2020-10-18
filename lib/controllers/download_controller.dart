import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stg_app/models/HTML_item.dart';
import 'package:stg_app/models/SubItem.dart';

class DownloadController extends GetxController {
  var percent = 0.0.obs;
  var loadingHTMLItem = false.obs;
  var item = "".obs;
  var index = 0.obs;
  final baseUrl = "https://osamfrimpong.github.io/stg_app_web/html/";
  final Dio dio = Dio();

  download(List<SubItem> subItems) {
    var total = subItems.length - 1;
    var currentSize = 0;

    // subItems.forEach((element) {
    //   doDownload(element, currentSize, total);
    // });

    Timer.periodic(Duration(milliseconds: 100), (timer) {
      currentSize += 1;
      index.value = currentSize;
      item.value = subItems[currentSize].title;
      dioJob(subItems[currentSize]);
      percent.value = ((currentSize / total) * 100);
      if (currentSize == total) timer?.cancel();
    });
  }

  Future<void> doDownload(SubItem element, currentSize, total) async {
    currentSize += 1;
    index.value = currentSize;
    item.value = element.title;
    print("Title: ${element.title} ID: ${element.id} Index:");
    percent.value = ((currentSize / total) * 100);
    dioJob(element);
  }

  void addToDb(HTMLItem htmlItem) {
    final box = Hive.lazyBox<HTMLItem>("htmlItemBox");
    if (box.containsKey(htmlItem.address)) {
      box.delete(htmlItem.address);
      box.put(htmlItem.address, htmlItem);
    } else {
      box.put(htmlItem.address, htmlItem);
    }

    if (loadingHTMLItem.value == true) loadingHTMLItem.value = false;
  }

  dioJob(SubItem element) async {
    try {
      Response response = await dio.get('$baseUrl${element.address}');
      HTMLItem htmlItem = HTMLItem(
          id: element.id,
          address: element.address,
          content: response.data.toString());
      addToDb(htmlItem);
      print("Response ${response.data.toString()}");
    } catch (e) {
      print(e.toString());
    }
  }
}
