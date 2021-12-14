import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notification_poc/services/NavigationService.dart';

class CommonAlertDialog {
  static Widget _getDialogWidget(
      {String? title,
      required String message,
      VoidCallback? onOkay,
      BuildContext? context}) {
    print('_getDialogWidget is called');
    // } else if (Platform.isAndroid) {
    return CupertinoAlertDialog(
      title: title == null ? null : Text(title),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          child: const Text("OK"),
          onPressed: onOkay ??
              () {
                if (context != null) {
                  Navigator.of(context, rootNavigator: true).pop("Discard");
                } else {
                  NavigationService.instance.goback();
                }
              },
          isDefaultAction: true,
        )
      ],
    );
  }

  static show(
      {required String message,
      String? title,
      VoidCallback? onOkay,
      BuildContext? context}) {
    print('show dialog is called');
    context = (context != null)
        ? context
        : NavigationService.instance.navigationKey.currentContext!;
    if (context != null) {
      showDialog(
        barrierDismissible: false,
        barrierColor: Color.fromRGBO(71, 71, 71, 0.7),
        context: context,
        builder: (BuildContext context) {
          return _getDialogWidget(
              title: title, message: message, onOkay: onOkay, context: context);
        },
      );
    } else {
      print('NavigationService.instance.navigationKey.currentContext is null');
    }
  }
}
