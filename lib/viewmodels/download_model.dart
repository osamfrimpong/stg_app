import 'package:flutter/foundation.dart';
import 'package:stg_app/models/SubItem.dart';

class DownloadModel extends ChangeNotifier {
  double _percent = 0;
  get percent => _percent;

  void doDownload(List<SubItem> subItems) {
    final int total = subItems.length;
    int currentSize = 0;

    subItems.forEach((element) {
      Future.delayed(Duration(seconds: 5)).then((value) {
        currentSize++;
        _percent =
            double.parse(((currentSize / total) * 100).toStringAsFixed(2));
        debugPrint("Percent: $percent");
        notifyListeners();
      });
    });
  }
}
