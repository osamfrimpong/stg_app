import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget themeSwitchButton(context) => IconButton(
      icon: Icon(AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
          ? Icons.brightness_2
          : Icons.wb_sunny),
      onPressed: () {
        AdaptiveTheme.of(context).toggleThemeMode();
      },
    );
