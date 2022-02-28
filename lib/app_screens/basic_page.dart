import 'dart:io' show Platform;

import 'package:badges/badges.dart';
import 'package:baked_pos/app_screens/cart.dart';
import 'package:baked_pos/app_screens/menu.dart';
import 'package:baked_pos/app_screens/profile.dart';
import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:line_icons/line_icons.dart';
import 'package:upgrader/upgrader.dart';

import '../utils/dynamic_sizes.dart';

class BasicPage extends StatefulWidget {
  const BasicPage({Key? key}) : super(key: key);

  @override
  _BasicPageState createState() => _BasicPageState();
}

class _BasicPageState extends State<BasicPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  double iconSize = 0.05;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

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
  Widget build(BuildContext context) {
    customContext = context;
    return Scaffold(
      backgroundColor: myBrown,
      body: UpgradeAlert(
        showIgnore: false,
        showLater: false,
        showReleaseNotes: true,
        canDismissDialog: false,
        shouldPopScope: () => false,
        dialogStyle: Platform.isAndroid
            ? UpgradeDialogStyle.material
            : UpgradeDialogStyle.cupertino,
        child: DefaultTabController(
          length: 3,
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              MaterialApp(debugShowCheckedModeBanner: false, home: MenuPage()),
              Cart(),
              Profile(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: dynamicHeight(context, 0.07),
        child: TabBar(
          labelStyle: const TextStyle(color: myGrey),
          unselectedLabelColor: myWhite,
          unselectedLabelStyle: const TextStyle(color: myWhite),
          controller: _tabController,
          labelColor: Colors.amber,
          indicatorColor: Colors.amber,
          tabs: [
            const Tab(
                text: "Home",
                icon: Icon(
                  Icons.home_outlined,
                  color: myWhite,
                )),
            Tab(
              text: "Cart",
              icon: Obx(() {
                return Badge(
                  badgeColor: myBlack,
                  badgeContent: Text(
                    cartItems.length.toString(),
                    style: TextStyle(
                      color: myWhite,
                      fontSize: dynamicWidth(context, 0.024),
                    ),
                  ),
                  showBadge: cartItems.isEmpty ? false : true,
                  child: const Icon(
                    LineIcons.shoppingCart,
                    color: myWhite,
                  ),
                );
              }),
            ),
            const Tab(
                text: "Profile",
                icon: Icon(
                  Icons.person_outline,
                  color: myWhite,
                )),
          ],
        ),
      ),
    );
  }

  bodyPage(String page) {
    switch (page) {
      case "home":
        return const MenuPage();
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
