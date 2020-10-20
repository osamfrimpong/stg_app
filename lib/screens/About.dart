import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stg_app/components/theme_switch.dart';

class About extends StatelessWidget {
  final List<String> contributors = [
    "Schandorf Osam-Frimpong ~ App Developer",
    "Silas Agbesi ~ Contributor",
    "Elinam Sosa Armstrong ~ Contributor",
    "Seshie Daniel ~ Contributor",
    "Abigail Naa Kai Anang ~ Contributor",
    "Derrick Attigah Mawuli ~ Contributor",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
        actions: [themeSwitchButton(context)],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 200.00,
                child: Center(
                  child: Image.asset(
                    "assets/images/coat_of_arms.png",
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
            Divider(),
            _aboutText("Copyright 2017 Ministry of Health (GNDP) Ghana"),
            Divider(),
            _aboutHeaderText("Legal Disclaimer"),
            Divider(),
            _aboutText(
                """Care has been taken to confirm the accuracy of the information presented and to describe generally accepted practices. However, the authors, editors and publishers are not responsible for errors and omissions or any consequences from application of the information in this booklet and make no warranty, expressed or implied, with respect to the content of the publication."""),
            Divider(),
            _aboutHeaderText("Credits"),
            Divider(),
            _aboutText(contributors[0]),
            Divider(),
            _aboutText(contributors[1]),
            Divider(),
            _aboutText(contributors[2]),
            Divider(),
            _aboutText(contributors[3]),
            Divider(),
            _aboutText(contributors[4]),
          ],
        ),
      ),
    );
  }

  Widget _aboutText(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text),
    );
  }

  Widget _aboutHeaderText(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
    );
  }
}
