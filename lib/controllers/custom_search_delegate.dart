import 'package:flutter/material.dart';
import 'package:stg_app/models/SubItem.dart';
import 'package:stg_app/screens/provider_details.dart';

class CustomSearchDelegate extends SearchDelegate<SubItem> {
  final List<SubItem> searchItems;

  CustomSearchDelegate(this.searchItems);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // throw UnimplementedError();
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // throw UnimplementedError();
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // throw UnimplementedError();
    List<SubItem> suggestions = [];
    suggestions.addAll(searchItems.where((element) =>
        element.title.toLowerCase().contains(query.toLowerCase())));
    return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(suggestions[index].title),
            onTap: () {
              // Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProviderDetails(
                        subItem: suggestions[index],
                      )));
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: suggestions.length);
  }
}
