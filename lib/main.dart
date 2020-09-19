import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stg_app/screens/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode savedThemeMode;

  const MyApp({Key key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      builder: (ThemeData lightTheme, ThemeData dark) => MaterialApp(
        title: "STG",
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: dark,
        home: HomePage(),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      light: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.teal,
          accentColor: Colors.tealAccent,
          fontFamily: "Trebuc"),
      dark: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          accentColor: Colors.amber,
          fontFamily: "Trebuc"),
    );
  }
}
