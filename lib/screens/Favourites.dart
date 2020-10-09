import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stg_app/models/FavouriteItem.dart';
import 'package:stg_app/models/SubItem.dart';
import 'package:stg_app/screens/Details.dart';
import 'package:stg_app/screens/provider_details.dart';



class Favourites extends StatelessWidget {

  void onFavoritePress(int index) {
    if (Hive.box<FavouriteItem>('favouritesBox').containsKey(index)) {
      Hive.box<FavouriteItem>('favouritesBox').delete(index);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Favourites"),
        ),
        body: ValueListenableBuilder(
          valueListenable:
              Hive.box<FavouriteItem>('favouritesBox').listenable(),
          builder: (context, Box<FavouriteItem> box, _) {
            final favourites = box.values.toList().cast<FavouriteItem>();

            return box.isEmpty
                ? Center(
                    child: Text("No Favourites!"),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: favourites.length,
                    itemBuilder: (context, listIndex) {
                      return ListTile(
                        title: Text(favourites[listIndex].title),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () =>
                              onFavoritePress(favourites[listIndex].id),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProviderDetails(
                                subItem: SubItem(
                                    id: favourites[listIndex].id,
                                    title: favourites[listIndex].title,
                                    address: favourites[listIndex].address),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
          },
        ));
  }
}
