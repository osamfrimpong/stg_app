import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stg_app/components/theme_switch.dart';
import 'package:stg_app/controllers/download_controller.dart';
import 'package:stg_app/models/SubItem.dart';
import 'package:stg_app/screens/HomePage.dart';

class Data extends StatelessWidget {
  final DownloadController c = Get.put(DownloadController());

  @override
  Widget build(BuildContext context) {
    if (c.loadingContents.value == true) c.loadingContents.value = false;

    return Scaffold(
      appBar: AppBar(
        title: Text("Downloader"),
        actions: [themeSwitchButton(context)],
      ),
      body: Obx(
        () {
          String _stateText = c.contentLoadingState.value == "notStarted"
              ? "Download App data. Ensure You have an active internet."
              : "Oops! There was an error downloading";
          String _resultText = c.contentLoadingState.value == "done"
              ? "Download Complete!"
              : _stateText;
          String _buttonText = c.contentLoadingState.value == "notStarted"
              ? "Download Data!"
              : "Retry Download";
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    c.loadingContents.value == true
                        ? "Downloading ${c.item} ${c.percent.toStringAsFixed(2)}%"
                        : _resultText,
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(
                    value: c.percent.value / 100,
                    minHeight: 20.0,
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

                    return c.loadingContents.value == true
                        ? Container()
                        : ElevatedButton(
                            onPressed: () {
                              if (c.contentLoadingState.value == "done") {
                                //done go back to home
                                Get.off(HomePage());
                              } else {
                                c.loadingHTMLItem.value = true;
                                _doUpdate(entries);
                              }
                            },
                            child: Text(c.contentLoadingState.value == "done"
                                ? "Go back!"
                                : _buttonText));
                  }),
            ],
          );
        },
      ),
    );
  }

  void _doUpdate(List<SubItem> subItems) {
    Get.defaultDialog(
        onConfirm: () {
          Get.back();
          c.download(subItems);
        },
        barrierDismissible: false,
        title: "Download Data!",
        middleText:
            "Do you want to download all data? Ensure you have an active internet connection.",
        textConfirm: "Download",
        textCancel: "Cancel",
        confirmTextColor:
            AdaptiveTheme.of(Get.context).mode == AdaptiveThemeMode.light
                ? Colors.white
                : Colors.black);
  }
}
