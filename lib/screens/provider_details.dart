import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:stg_app/models/FavouriteItem.dart';
import 'package:stg_app/models/SubItem.dart';
import 'package:stg_app/viewmodels/favourites_model.dart';
import 'package:stg_app/viewmodels/html_data_model.dart';

class ProviderDetails extends StatelessWidget {
  final SubItem subItem;

  const ProviderDetails({Key key, this.subItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          subItem.title,
        ),
        actions: [
          ChangeNotifierProvider<FavouritesModel>(
            create: (_) => FavouritesModel(subItem.id),
            child: Consumer<FavouritesModel>(
              builder: (context, model, child) => IconButton(
                  icon: Icon(model.favouriteIcon),
                  onPressed: () {
                    model.addOrDeleteFavourite(FavouriteItem(
                        id: subItem.id,
                        title: subItem.title,
                        address: subItem.address));
                  }),
            ),
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(subItem.address);
            },
          )
        ],
      ),
      body: FutureProvider<String>(
        create: (_) => HTMLDataModel().loadItemAsset(subItem.address),
        initialData: '<div></div>',
        child: Consumer<String>(
          builder: (context, html, child) => SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: HtmlWidget(
              html,
              // buildAsync: true,
              enableCaching: true,
              customStylesBuilder: (element) {
                if (element.localName == "table") {
                  return AdaptiveTheme.of(context).mode ==
                          AdaptiveThemeMode.light
                      ? {"border": "1px solid #00000"}
                      : {"border": "1px solid #ffffff"};
                }

                if (element.localName == "td") {
                  return {"padding": "5px"};
                }

                return null;
              },
            ),
          ),
        ),
      ),
    );
  }
}
