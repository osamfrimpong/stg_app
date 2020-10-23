import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stg_app/models/Content.dart';
import 'package:stg_app/models/SubItem.dart';
import 'package:stg_app/screens/HomePage.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'models/FavouriteItem.dart';
import 'models/HTML_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  final applicationDocumentsDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  // debugPrint(applicationDocumentsDirectory.path);
  Hive.init(applicationDocumentsDirectory.path);
  Hive.registerAdapter(ContentAdapter());
  Hive.registerAdapter(SubItemAdapter());
  Hive.registerAdapter(FavouriteItemAdapter());
  Hive.registerAdapter(HTMLItemAdapter());
  await Hive.openBox<FavouriteItem>('favouritesBox');
  await Hive.openBox<Content>('contentsBox');
  await Hive.openBox<SubItem>('entriesBox');
  await Hive.openLazyBox<HTMLItem>('htmlItemBox');
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode savedThemeMode;

  const MyApp({Key key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      builder: (ThemeData lightTheme, ThemeData dark) => GetMaterialApp(
        title: "STG",
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: dark,
        home: HomePage(),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      light: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.teal,
          accentColor: Colors.deepPurple,
          fontFamily: "Trebuc"),
      dark: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.amber,
          fontFamily: "Trebuc"),
    );
  }
}
