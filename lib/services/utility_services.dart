import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldKey =
    GlobalKey<ScaffoldMessengerState>();

class UtilityServices {
  bool internetAccess = false;

  Future<bool> hasInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return internetAccess = true;
    }
    return internetAccess;
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
    );
    scaffoldKey.currentState?.showSnackBar(snackBar);
  }
}
