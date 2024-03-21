import 'dart:io';

import 'package:e_commerce/utils/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin Constants {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final screenHeight =
      MediaQuery.sizeOf(navigatorKey.currentContext!).height;
  static final screenWidth =
      MediaQuery.sizeOf(navigatorKey.currentContext!).width;
  static bool enableShimmer = false;
  static void closeAppFunction() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
      return;
    }
    exit(0);
  }

  static void unFocusFunc() {
    //close keyboard with a random tap on screen
    FocusScope.of(navigatorKey.currentContext!).unfocus();
  }

  static Future<void> showLoading() async {
    return showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Center(
            child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
        ));
      },
    );
  }

  static void showSnackbar(String message) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        dismissDirection: DismissDirection.down,
        duration: const Duration(seconds: 5),
        clipBehavior: Clip.hardEdge,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
                child: Text(
              message,
              style: const TextStyle(color: Colors.black, fontSize: 13),
              overflow: TextOverflow.visible,
            )),
            const SizedBox(
              width: 5,
            ),
            const Icon(
              Icons.info_outline,
              color: Colors.red,
              size: 20,
            )
          ],
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 20,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static void hideLoadingOrNavBack() => navigatorKey.currentState!.pop();

  static Future<void> navigateTo(Widget screen,
          {bool pushReplacment = false,
          bool pushAndRemoveUntil = false}) async =>
      pushReplacment
          ? await Navigator.pushReplacement(navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => screen))
          : pushAndRemoveUntil
              ? await Navigator.pushAndRemoveUntil(navigatorKey.currentContext!,
                  MaterialPageRoute(builder: (_) => screen), (r) => false)
              : await Navigator.push(navigatorKey.currentContext!,
                  MaterialPageRoute(builder: (_) => screen));

  static Future<void> navigateToName(String name,
          {bool pushReplacment = false,
          bool pushAndRemoveUntil = false}) async =>
      pushReplacment
          ? await Navigator.pushReplacementNamed(
              navigatorKey.currentContext!, name)
          : pushAndRemoveUntil
              ? await Navigator.pushNamedAndRemoveUntil(
                  navigatorKey.currentContext!, name, (r) => false)
              : await Navigator.pushNamed(navigatorKey.currentContext!, name);

  static Future<dynamic> errorMessage(
      {String? title,
      String? description,
      Function? onPressed,
      bool removeCancelButton = true}) async {
    return navigatorKey.currentContext == null
        ? const SizedBox.shrink()
        : showDialog<void>(
            context: navigatorKey.currentContext!,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title ?? "Alert"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(description ?? "Error Occured"),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      if (onPressed != null) {
                        onPressed();
                      } else {
                        hideLoadingOrNavBack();
                      }
                    },
                  ),
                  removeCancelButton
                      ? const SizedBox.shrink()
                      : TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            hideLoadingOrNavBack();
                          },
                        ),
                ],
              );
            },
          );
  }

  static Future<dynamic> twoOptionDialog(
      {String? title,
      String? description,
      Function? onPressedOk,
      Function? onPressedCancel,
      Function? firstChoiceFunction,
      Function? secondChoiceFunction,
      bool removeCancelButton = true}) async {
    return navigatorKey.currentContext == null
        ? const SizedBox.shrink()
        : showDialog<void>(
            context: navigatorKey.currentContext!,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title ?? "Alert"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      TextButton(
                          onPressed: () {
                            if (firstChoiceFunction != null) {
                              firstChoiceFunction();
                            }
                          },
                          child: const Text("Open Camera")),
                      TextButton(
                          onPressed: () {
                            if (secondChoiceFunction != null) {
                              secondChoiceFunction();
                            }
                          },
                          child: const Text("Open File Manager")),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      if (onPressedOk != null) {
                        onPressedOk();
                      } else {
                        hideLoadingOrNavBack();
                      }
                    },
                  ),
                  removeCancelButton
                      ? const SizedBox.shrink()
                      : TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            if (onPressedCancel != null) {
                              onPressedCancel();
                            } else {
                              hideLoadingOrNavBack();
                            }
                          },
                        ),
                ],
              );
            },
          );
  }
}
