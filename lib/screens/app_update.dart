import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:stg_app/components/theme_switch.dart';

class UpdateApp extends StatefulWidget {
  @override
  _UpdateAppState createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> {
  AppUpdateInfo _updateInfo;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool _flexibleUpdateAvailable = false;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
        _checking = false;
      });
    }).catchError((e) => _showError(e));
  }

  void _showError(dynamic exception) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(exception.toString())));
  }

  @override
  Widget build(BuildContext context) {
    String _updateStatus = _updateInfo?.updateAvailable == true
        ? "Update Available"
        : "No Update Available";
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Update STG'),
        actions: [themeSwitchButton(context)],
      ),
      body: Center(
        child: _checking
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Text(
                            'Update Status: ${_updateInfo == null ? "Update Not Checked" : _updateStatus}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          child: Text('Check for Update'),
                          onPressed: () {
                            setState(() {
                              _checking = true;
                            });
                            checkForUpdate();
                          },
                        ),
                        ElevatedButton(
                          child: Text('Perform immediate update'),
                          onPressed: _updateInfo?.updateAvailable == true
                              ? () {
                                  InAppUpdate.performImmediateUpdate()
                                      .catchError((e) => _showError(e));
                                }
                              : null,
                        ),
                        ElevatedButton(
                          child: Text('Start flexible update'),
                          onPressed: _updateInfo?.updateAvailable == true
                              ? () {
                                  InAppUpdate.startFlexibleUpdate().then((_) {
                                    setState(() {
                                      _flexibleUpdateAvailable = true;
                                    });
                                  }).catchError((e) => _showError(e));
                                }
                              : null,
                        ),
                        ElevatedButton(
                          child: Text('Complete flexible update'),
                          onPressed: !_flexibleUpdateAvailable
                              ? null
                              : () {
                                  InAppUpdate.completeFlexibleUpdate()
                                      .then((_) {
                                    _scaffoldKey.currentState.showSnackBar(
                                        SnackBar(content: Text('Success!')));
                                  }).catchError((e) => _showError(e));
                                },
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
