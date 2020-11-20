import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:stg_app/components/navigation_drawer.dart';
import 'package:stg_app/components/theme_switch.dart';
import 'package:stg_app/controllers/download_controller.dart';
import 'package:stg_app/models/FavouriteItem.dart';
import 'package:stg_app/models/HTML_item.dart';
import 'package:stg_app/models/SubItem.dart';
import 'package:stg_app/screens/provider_details.dart';
import 'package:stg_app/screens/update_detail.dart';
import 'package:stg_app/viewmodels/favourites_model.dart';
import 'package:stg_app/viewmodels/html_data_model.dart';

class DetailsLink extends StatelessWidget {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  final SubItem subItem;
  final DownloadController c = Get.put(DownloadController());
  DetailsLink({Key key, this.subItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text(
          "STG",
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download_rounded),
            onPressed: () => _doUpdate(subItem),
          ),
          themeSwitchButton(context),
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
              Share.share(
                  "Access ${subItem.title} from the STG App at https://osamfrimpong.github.io/stg_app_web/html/${subItem.address}");
            },
          ),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _globalKey.currentState.openDrawer();
            },
          )
        ],
      ),
      body: FutureProvider<HTMLItem>(
        create: (_) => HTMLDataModel().loadHTML(subItem),
        initialData: HTMLItem(address: subItem.address, content: '<div></div>'),
        child: Consumer<HTMLItem>(
          builder: (context, HTMLItem htmlItem, child) => htmlItem == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${subItem.title} is not loaded!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Press Button to Load! Ensure you have and active internet",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.download_rounded),
                          iconSize: 54.0,
                          onPressed: () {
                            _doUpdate(subItem);
                          }),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10.0,
                        top: 10.0,
                        left: 10.0,
                        right: 10.0,
                      ),
                      child: Text(
                        subItem.title.toUpperCase(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(10.0),
                        child: HtmlWidget(
                          htmlItem.content,
                          // buildAsync: true,
                          // enableCaching: true,
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
                          onTapUrl: (url) {
                            print(url);
                            loadDatabaseItemWithAddress(url)
                                .then((htmlItem) => {
                                      if (htmlItem == null)
                                        {
                                          Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Condition Not Added!",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                        }
                                      else
                                        {
                                          Get.to(ProviderDetails(
                                            subItem: SubItem(
                                                title: htmlItem.title,
                                                id: htmlItem.id,
                                                address: htmlItem.address),
                                          ))
                                        }
                                    });
                          },
                          textStyle: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
      drawer: navigationDrawer,
    );
  }

  void _doUpdate(SubItem subItem) {
    Get.defaultDialog(
        onConfirm: () {
          c.loadingHTMLItem.value = true;
          Get.back();
          Get.off(
            UpdateDetail(
              subItem: subItem,
            ),
          );
        },
        barrierDismissible: false,
        title: "Update!",
        middleText:
            "Do you want to update ${subItem.title}? Ensure you have an active internet connection.",
        textConfirm: "Update",
        textCancel: "Cancel",
        confirmTextColor:
            AdaptiveTheme.of(Get.context).mode == AdaptiveThemeMode.light
                ? Colors.white
                : Colors.black);
  }

  Future<HTMLItem> loadDatabaseItemWithAddress(String address) {
    final box = Hive.lazyBox<HTMLItem>('htmlItemBox');
    return box.get(address);
  }
}
