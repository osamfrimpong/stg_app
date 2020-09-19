import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:stg_app/models/Content.dart';
import 'package:stg_app/models/SubItem.dart';

class Details extends StatefulWidget {
  final Content content;
  final SubItem subItem;

  const Details({this.content, this.subItem});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String loadedHtml = "<div></div>";

  @override
  void initState() {
    super.initState();
    _loadConstitutionAsset(widget.subItem.address).then((value) {
      setState(() {
        loadedHtml = value;
      });
    });

    // setState(() {
    //   loadedHtml = _loadConstitutionAsset(widget.subItem.address);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subItem.title,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: HtmlWidget(
          loadedHtml,
          buildAsync: true,
          customStylesBuilder: (element) {
            if (element.classes.contains("table")) {
              return {"border-color": "red", 'color': 'red'};
            }

            return null;
          },
        ),
      ),
    );
  }

  Future<String> _loadConstitutionAsset(String address) async {
    String rawData =
        await rootBundle.loadString("assets/html/$address", cache: true);
    return rawData;
  }
}
