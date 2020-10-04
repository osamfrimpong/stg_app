import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hive/hive.dart';
import 'package:share/share.dart';
import 'package:stg_app/models/SubItem.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class Details extends StatefulWidget {
  // final Content content;
  final SubItem subItem;

  const Details({this.subItem});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String loadedHtml = "<div></div>";
  WebViewPlusController _controller;

  @override
  void initState() {
    super.initState();
    _loadItemAsset(widget.subItem.address).then((value) {
      setState(() {
        loadedHtml = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subItem.title,
        ),
        actions: [
          IconButton(
              icon: getIcon(widget.subItem.id),
              onPressed: () {
                onFavoritePress(widget.subItem);
              }),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(widget.subItem.address);
            },
          )
        ],
      ),
      body: Container(
        child: WebViewPlus(
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            controller.loadUrl('assets/hm/index.html');
            _controller = controller;
          },
          onPageFinished: (url) {
            debugPrint("onPageFinished Callback: $url");
            _controller.evaluateJavascript("halfmoon.toggleDarkMode()");
          },
        ),
      ),
    );
  }

  Future<String> _loadItemAsset(String address) async {
    String rawData =
        await rootBundle.loadString("assets/html/$address", cache: true);
    return rawData;
  }

  Widget getIcon(int index) {
    if (Hive.box<SubItem>('favouritesBox').containsKey(widget.subItem.id)) {
      return Icon(
        Icons.favorite,
      );
    }
    return Icon(Icons.favorite_border);
  }

  void onFavoritePress(SubItem subItem) {
    if (Hive.box<SubItem>('favouritesBox').containsKey(subItem.id)) {
      Hive.box<SubItem>('favouritesBox').delete(subItem.id);
      return;
    }
    Hive.box<SubItem>('favouritesBox').put(subItem.id, subItem);
  }
}
