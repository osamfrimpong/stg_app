import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stg_app/controllers/download_controller.dart';
import 'package:stg_app/models/SubItem.dart';
import 'package:stg_app/viewmodels/download_model.dart';

class Data extends StatelessWidget {
  final DownloadController c = Get.put(DownloadController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Downloader"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Downloading ${c.item} ${c.percent.toStringAsFixed(2)}%",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
          ),
          Center(
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.all(8.0),
                child: LinearProgressIndicator(
                  value: c.percent.value / 100,
                  minHeight: 20.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(),
          ),
          ValueListenableBuilder(
              valueListenable: Hive.box<SubItem>('entriesBox').listenable(),
              builder: (context, box, widget) {
                var entries = box.values.toList().cast<SubItem>();
                //DownloadModel().setTotal(entries.length);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () => c.download(entries),
                        child: Text("Download Data")),
                  ],
                );
              }),
        ],
      ),
    );
  }
}

class MyText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var downloadModel = Provider.of<DownloadModel>(context, listen: true);
    return Text(downloadModel.percent.toString());
  }

  // void doDownload(List<SubItem> subItems) {
  //   final int total = subItems.length;
  //   int currentSize = 0;

  //   subItems.forEach((element) {
  //     Future.delayed(Duration(seconds: 5)).then((value) {
  //       currentSize++;
  //       // _percent =
  //       // double.parse(((currentSize / total) * 100).toStringAsFixed(2));
  //     });
  //   });
  // }
}
