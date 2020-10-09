import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hive/hive.dart';
import 'package:share/share.dart';
import 'package:stg_app/models/FavouriteItem.dart';
import 'package:stg_app/models/SubItem.dart';

class Details extends StatefulWidget {
  // final Content content;
  final SubItem subItem;

  const Details({this.subItem});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String loadedHtml = "<div></div>";

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
  void dispose() {
    super.dispose();
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
                onFavoritePress(FavouriteItem(
                    id: widget.subItem.id,
                    title: widget.subItem.title,
                    address: widget.subItem.address));
              }),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(widget.subItem.address);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: HtmlWidget(
          loadedHtml,
          buildAsync: true,
          enableCaching: true,
          customStylesBuilder: (element) {
            if (element.localName == "table") {
              return AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
                  ? {"border": "1px solid #00000"}
                  : {"border": "1px solid #ffffff"};
            }

            if (element.localName == "td") {
              return {"padding": "5px"};
            }

            debugPrint("Element Local name ${element.localName}");

            return null;
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
    if (Hive.box<FavouriteItem>('favouritesBox')
        .containsKey(widget.subItem.id)) {
      return Icon(
        Icons.favorite,
      );
    }
    return Icon(Icons.favorite_border);
  }

  void onFavoritePress(FavouriteItem favouriteItem) {
    if (Hive.box<FavouriteItem>('favouritesBox')
        .containsKey(favouriteItem.id)) {
      Hive.box<FavouriteItem>('favouritesBox').delete(favouriteItem.id);
      return;
    }
    Hive.box<FavouriteItem>('favouritesBox')
        .put(favouriteItem.id, favouriteItem);
  }
}
