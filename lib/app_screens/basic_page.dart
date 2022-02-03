import 'dart:io' show Platform;

import 'package:baked_pos/app_screens/cart.dart';
import 'package:baked_pos/app_screens/menu.dart';
import 'package:baked_pos/app_screens/profile.dart';
import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:upgrader/upgrader.dart';

class BasicPage extends StatefulWidget {
  const BasicPage({Key? key}) : super(key: key);

  @override
  _BasicPageState createState() => _BasicPageState();
}

class _BasicPageState extends State<BasicPage> with TickerProviderStateMixin {
  // fcmListen() async {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage event) {
  //     if (event.data['id'] == userResponse['id']) {
  //       LocalNotificationsService.instance
  //           .showChatNotification(
  //         title: '${event.notification!.title}',
  //         body: '${event.notification!.body}',
  //       )
  //           .then((value) async {
  //         await FlutterRingtonePlayer.play(
  //           android: AndroidSounds.ringtone,
  //           ios: IosSounds.bell,
  //           looping: true,
  //           volume: 1.0,
  //           asAlarm: true,
  //         );
  //         return CoolAlert.show(
  //           context: customContext,
  //           title: '${event.notification!.title}',
  //           text: '${event.notification!.body}',
  //           type: CoolAlertType.info,
  //           confirmBtnText: "OK",
  //           backgroundColor: myYellow,
  //           barrierDismissible: false,
  //           showCancelBtn: false,
  //           confirmBtnColor: myYellow,
  //           lottieAsset: "assets/bell.json",
  //           confirmBtnTextStyle: TextStyle(
  //             fontSize: dynamicWidth(context, 0.04),
  //             color: myWhite,
  //           ),
  //           onConfirmBtnTap: () {
  //             FlutterRingtonePlayer.stop();
  //             Navigator.of(context, rootNavigator: true).pop();
  //           },
  //         );
  //       });
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // FCMServices.fcmGetTokenAndSubscribe();
    // fcmListen();
  }

  @override
  Widget build(BuildContext context) {
    customContext = context;
    return Scaffold(
      backgroundColor: myBlack,
      body: UpgradeAlert(
        showIgnore: false,
        showLater: false,
        showReleaseNotes: true,
        canDismissDialog: false,
        shouldPopScope: () => false,
        dialogStyle: Platform.isAndroid
            ? UpgradeDialogStyle.material
            : UpgradeDialogStyle.cupertino,
        child: bodyPage(pageDecider),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: indexPage,
        onTap: (value) {
          if (value == 0) {
            pageDecider = "home";
          } else if (value == 1) {
            pageDecider = "cart";
          } else if (value == 2) {
            pageDecider = "profile";
          } else {
            pageDecider = "home";
          }
          setState(() {
            indexPage = value;
          });
        },
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900),
        unselectedItemColor: myWhite,
        unselectedIconTheme: const IconThemeData(color: myWhite),
        selectedItemColor: myYellow,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.brown.shade400,
            icon: const Icon(LineIcons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.brown.shade400,
            icon: const Icon(LineIcons.shoppingCart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.brown.shade400,
            icon: const Icon(LineIcons.user),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  bodyPage(String page) {
    switch (page) {
      case "home":
        return const MenuPage(
            saleId: "1", tableNo: "1", tableName: "tableName");
      case "cart":
        return const Cart();
      case "profile":
        return const Profile();

      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            text(context, "error", .06, myBrown),
          ],
        );
    }
  }
}
