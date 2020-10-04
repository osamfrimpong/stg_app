import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stg_app/models/SubItem.dart';
import 'package:stg_app/screens/Details.dart';

const favoritesBox = 'favorite_books';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // if (Hive.box<SubItem>('favouritesBox').isOpen) {
    //   Hive.box<SubItem>('favouritesBox').compact();
    //   Hive.box<SubItem>('favouritesBox').close();
    // }
  }

  void onFavoritePress(int index) {
    if (Hive.box<SubItem>('favouritesBox').containsKey(index)) {
      Hive.box<SubItem>('favouritesBox').delete(index);
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
          valueListenable: Hive.box<SubItem>('favouritesBox').listenable(),
          builder: (context, Box<SubItem> box, _) {
            final favourites = box.values.toList().cast<SubItem>();
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
                              builder: (context) => Details(
                                subItem: favourites[listIndex],
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
