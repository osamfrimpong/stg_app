import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stg_app/components/theme_switch.dart';
import 'package:stg_app/controllers/download_controller.dart';
import 'package:stg_app/models/SubItem.dart';
import 'package:stg_app/screens/provider_details.dart';

class UpdateDetail extends StatelessWidget {
  final SubItem subItem;
  final DownloadController dc = Get.put(DownloadController());

  UpdateDetail({Key key, this.subItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dc.dioJob(subItem);
    return Scaffold(
      appBar: AppBar(
        title: Text("Update ${subItem.title}"),
        actions: [themeSwitchButton(context)],
      ),
      body: Container(
        child: Center(
          child: Card(
            elevation: 2.0,
            child: Obx(
              () {
                String _resultText = dc.isSuccessful.value == "yes"
                    ? "Update Complete!"
                    : "Oops! There was an error updating ${subItem.title}";
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        dc.loadingHTMLItem.value == true
                            ? "Updating ${subItem.title}"
                            : _resultText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    dc.loadingHTMLItem.value == true
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              if (dc.isSuccessful.value == "no") {
                                dc.loadingHTMLItem.value = true;
                                dc.dioJob(subItem);
                              } else {
                                Get.off(ProviderDetails(
                                  subItem: subItem,
                                ));
                              }
                            },
                            child: Text(dc.isSuccessful.value == "yes"
                                ? "Go Back"
                                : "Retry"))
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
