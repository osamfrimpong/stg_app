import 'dart:async';

// import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stg_app/models/HTML_item.dart';
import 'package:stg_app/models/SubItem.dart';
import 'package:http/http.dart' as http;

class DownloadController extends GetxController {
  var percent = 0.0.obs;
  var loadingHTMLItem = false.obs;
  var loadingContents = false.obs;
  var isSuccessful = "no".obs;
  var contentLoadingState = "notStarted".obs;
  var item = "".obs;
  var index = 0.obs;
  final baseUrl = "https://raw.githubusercontent.com/osamfrimpong/stg_app_web/main/html/";
  // final Dio dio = Dio();

  download(List<SubItem> subItems) {
    var total = subItems.length - 1;
    var currentSize = 0;
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      currentSize += 1;
      index.value = currentSize;
      item.value = subItems[currentSize].title;
      dioJob(subItems[currentSize]);
      percent.value = ((currentSize / total) * 100);
      if (currentSize == total) {
        timer.cancel();
        loadingContents.value = false;
        contentLoadingState.value = "done";
      }
    });
  }

  Future<void> doDownload(SubItem element, currentSize, total) async {
    currentSize += 1;
    index.value = currentSize;
    item.value = element.title;
    // print("Title: ${element.title} ID: ${element.id} Index:");
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
      http.Response response =
          await http.get(Uri.parse('$baseUrl${element.address}'));

      if (response.statusCode < 200 || response.statusCode > 400) {
        //error or not found
        isSuccessful.value = "no";
        if (loadingHTMLItem.value == true) loadingHTMLItem.value = false;

      } else {
        HTMLItem htmlItem = HTMLItem(
            id: element.id,
            address: element.address,
            content: response.body.toString(),
            title: element.title);
        addToDb(htmlItem);
        isSuccessful.value = "yes";
        if (loadingHTMLItem.value == true) loadingHTMLItem.value = false;

      }
      
    } catch (e) {
      if (loadingHTMLItem.value == true) loadingHTMLItem.value = false;
      // print(e.toString());
    }
  }
}
