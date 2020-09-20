import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stg_app/models/SubItem.dart';

class Favourites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourites"),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: Hive.openBox('favouritesBox'),
          builder: (context, snapshot) {
            final List<SubItem> favourites = snapshot.data;
            return ListView.separated(
                itemBuilder: (context, index) {
                  return _favouriteItem(favourites[index], index);
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: favourites.length);
          }),
    );
  }

  Widget _favouriteItem(SubItem favouriteItem, int index) {
    return ListTile(
      title: Text(favouriteItem.title),
      trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            final favouriteBox = Hive.box('favouritesBox');
            favouriteBox.deleteAt(index);
          }),
    );
  }
}
