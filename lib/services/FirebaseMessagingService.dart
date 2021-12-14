import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:notification_poc/main.dart';
import 'package:notification_poc/services/NavigationService.dart';
import 'package:notification_poc/widgets/CommonAlertDialog.dart';

class FirebaseMessagingService {
  static final FirebaseMessagingService instance =
      FirebaseMessagingService._internal();

  FirebaseMessagingService._internal();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initializeService() async {
    //Background message functional callback, do not confuse it with actual notification creation
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    //When notification was clicked and app was in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      debugPrint(
          'Clicked on Notification: \n ${event.notification!.body.toString()}');
      performAction(event.data);
    });

    //App was killed and user clicked the notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      if (message != null) {
        debugPrint('getInitialMessage data: ${message.data}');
        performAction(message.data);
      }
    });

    //App is running && foreground && receives message
    FirebaseMessaging.onMessage.listen((event) {
      debugPrint('Received Message: \n ${event.notification!.body.toString()}');
      performAction(event.data);
    });
  }
}

//data field name change here
void performAction(
  Map<String, dynamic> data,
) {
  if (data['action'] != null && data['action_args'] != null) {
    int action = int.parse(data['action']);
    var actionArgs = data['action_args'];

    debugPrint('action: $action, args: $actionArgs');

    if (action == FirebaseMessageAction.game.index) {
      openGame(
        actionArgs,
      );
    } else if (action == FirebaseMessageAction.screen.index) {
      openRoute(
        actionArgs,
      );
    } else if (action == FirebaseMessageAction.dialog.index) {
      actionArgs = jsonDecode(actionArgs);
      String title = actionArgs['title'];
      String body = actionArgs['body'];
      openDialog(
        title,
        body,
      );
    }
  }
}

void openGame(String appName, {bool isAppInForeground = false}) async {
  if (!isAppInForeground) {
    await Future.delayed(Duration(milliseconds: isAppInForeground ? 100 : 350));
  }

  //Navigating to Home first if user comes back from game homepage will be displayed??
  // NavigationService.instance.navigateTo(OldHomeScreen.RouteName);
  // if (User().isMember) {
  //   FlutterIO().launchApp(appName,gameType);
  // }
  //what to do here??
}

void openRoute(String route, {bool isAppInForeground = false}) async {
  if (!isAppInForeground) {
    await Future.delayed(Duration(milliseconds: isAppInForeground ? 100 : 350));
  }
  NavigationService.instance.navigateTo(route);
}

void openDialog(String title, String body,
    {bool isAppInForeground = false}) async {
  await Future.delayed(Duration(milliseconds: isAppInForeground ? 500 : 1500));

  //Change dialog widget here..
  CommonAlertDialog.show(message: title);
  //  Utils.showDialogFor(PitchScreen(orientation: Orientation.portrait),
  //      NavigationService.instance.navigationKey.currentContext!);
}

enum FirebaseMessageAction {
  game,
  screen,
  dialog,
}
