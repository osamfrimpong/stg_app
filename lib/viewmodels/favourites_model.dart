import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stg_app/models/FavouriteItem.dart';

class FavouritesModel extends ChangeNotifier {
  IconData _icon = Icons.favorite_border;

  get favouriteIcon => _icon;

  FavouritesModel(int id){ determineIcon(id);}

  void determineIcon(int id) async {
    if (Hive.box<FavouriteItem>('favouritesBox').containsKey(id)) {
      _icon = Icons.favorite;
      notifyListeners();
    }
  }

  void addOrDeleteFavourite(FavouriteItem favouriteItem) async {
    if (Hive.box<FavouriteItem>('favouritesBox')
        .containsKey(favouriteItem.id)) {
      Hive.box<FavouriteItem>('favouritesBox').delete(favouriteItem.id);
      _icon = Icons.favorite_border;
      notifyListeners();
    } else {
      Hive.box<FavouriteItem>('favouritesBox')
          .put(favouriteItem.id, favouriteItem);
      _icon = Icons.favorite;
      notifyListeners();
    }
  }
}
