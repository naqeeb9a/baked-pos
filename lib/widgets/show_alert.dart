import 'package:baked_pos/app_functions/functions.dart';
import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/buttons.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';

import 'essential_widgets.dart';

dialogueCustom(
    context, snapshotTable, indexTable, assignTable, function, searchDelegate) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: text(context, "Assign Table", 0.04, myWhite, bold: true),
          backgroundColor: myBrown,
          content: Container(
            color: myBrown,
            height: dynamicHeight(context, 0.6),
            width: dynamicWidth(context, 0.8),
            child: FutureBuilder(
                future: getDineInOrders("dinein-orders", true),
                builder: (context, snapshot2) {
                  if (snapshot2.connectionState == ConnectionState.done) {
                    if (snapshot2.data == false) {
                      return Center(
                        child: text(
                            context,
                            "Check your internet or try again later",
                            0.04,
                            myWhite),
                      );
                    } else if (snapshot2.hasData) {
                      return FutureBuilder(
                        future: getTables(snapshotTable[indexTable]["sale_id"]),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return loader(context);
                          } else if (snapshot.data == false) {
                            return retry(
                              context,
                            );
                          } else if (snapshot.data.length == 0) {
                            return Center(
                              child: text(
                                context,
                                "no Tables!!",
                                0.028,
                                myWhite,
                              ),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5),
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                var customColor = myYellow;

                                for (var i = 0;
                                    i < (snapshot2.data as List).length;
                                    i++) {
                                  if ((snapshot2.data as List)[i]
                                              ["booking_date"] ==
                                          DateFormat('yyyy-MM-dd')
                                              .format(DateTime.now())
                                              .toString() &&
                                      ((snapshot2.data as List)[i]
                                                  ["order_status"] ==
                                              "1" ||
                                          (snapshot2.data as List)[i]
                                                  ["order_status"] ==
                                              "2") &&
                                      snapshot.data[index]["id"] ==
                                          (snapshot2.data as List)[i]
                                              ["table_id"]) {
                                    customColor = myGrey;
                                  }
                                }
                                return InkWell(
                                  onTap: () async {
                                    if (customColor == myGrey) {
                                      MotionToast.error(
                                        description: Text("Table Already reserved"),
                                        dismissable: true,
                                      ).show(context);
                                    } else if (snapshotTable[indexTable]
                                                ["waiter_id"] ==
                                            null &&
                                        userResponse["designation"]
                                                .toString()
                                                .toLowerCase() ==
                                            "Floor Manager".toLowerCase()) {
                                      MotionToast.error(
                                        description: Text("Assign waiter first"),
                                        dismissable: true,
                                      ).show(context);
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.loading,
                                          barrierDismissible: false,
                                          lottieAsset: "assets/loader.json");
                                      if (snapshotTable[indexTable]
                                                  ["waiter_id"] ==
                                              null &&
                                          userResponse["designation"]
                                                  .toString()
                                                  .toLowerCase() ==
                                              "Waiter".toLowerCase()) {
                                        assignTable = userResponse["id"];

                                        var response = await assignWaiterOnline(
                                            snapshotTable[indexTable]
                                                ["sale_id"],
                                            assignTable);
                                        if (response == false) {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          MotionToast.error(
                                            description:
                                                Text("Waiter not assigned Check your internet"),
                                            dismissable: true,
                                          ).show(context);
                                        } else {
                                          assignTable =
                                              snapshot.data[index]["id"];

                                          var response =
                                              await assignTableOnline(
                                                  snapshotTable[indexTable]
                                                      ["sale_id"],
                                                  assignTable);
                                          if (response == false) {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            MotionToast.error(
                                              description:
                                                  Text("Table not assigned Check your internet"),
                                              dismissable: true,
                                            ).show(context);
                                          } else {
                                            pageDecider = "Dine In Orders";
                                            Navigator.pop(
                                                context, globalRefresh());
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            if (searchDelegate != "") {
                                              searchDelegate();
                                            }
                                            MotionToast.success(
                                              description: Text(snapshotTable[
                                                                  indexTable]
                                                              ["waiter_id"] ==
                                                          null &&
                                                      userResponse[
                                                                  "designation"]
                                                              .toString()
                                                              .toLowerCase() ==
                                                          "waiter".toLowerCase()
                                                  ? "Table and Waiter both Assigned"
                                                  : snapshotTable[indexTable]
                                                              ["table_id"] ==
                                                          null
                                                      ? "Table assigned"
                                                      : "Table changed"),
                                              dismissable: true,
                                            ).show(context);
                                          }
                                        }
                                      } else {
                                        assignTable =
                                            snapshot.data[index]["id"];

                                        var response = await assignTableOnline(
                                            snapshotTable[indexTable]
                                                ["sale_id"],
                                            assignTable);
                                        if (response == false) {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          MotionToast.error(
                                            description:
                                                Text("Table not assigned Check your internet"),
                                            dismissable: true,
                                          ).show(context);
                                        } else {
                                          pageDecider = "Dine In Orders";
                                          Navigator.pop(
                                              context, globalRefresh());
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          if (searchDelegate != "") {
                                            searchDelegate();
                                          }
                                          MotionToast.success(
                                            description: Text(snapshotTable[
                                                                indexTable]
                                                            ["waiter_id"] ==
                                                        null &&
                                                    userResponse["designation"]
                                                            .toString()
                                                            .toLowerCase() ==
                                                        "waiter".toLowerCase()
                                                ? "Table and Waiter both Assigned"
                                                : snapshotTable[indexTable]
                                                            ["table_id"] ==
                                                        null
                                                    ? "Table assigned"
                                                    : "Table changed"),
                                            dismissable: true,
                                          ).show(context);
                                        }
                                      }
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: customColor,
                                    child: text(
                                      context,
                                      "Table\n" + snapshot.data[index]["name"],
                                      0.04,
                                      myWhite,
                                      alignText: TextAlign.center,
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return text(context, "not working", 0.028, myWhite);
                          }
                        },
                      );
                    } else {
                      return text(
                        context,
                        "retry",
                        0.04,
                        myWhite,
                      );
                    }
                  } else {
                    return loader(context);
                  }
                }),
          ),
        );
      });
}

dialogueCustomWaiter(
    context, snapshotTable, indexTable, assignTable, function, searchDelegate) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: text(context, "Assign Waiter", 0.04, myWhite, bold: true),
          backgroundColor: myBrown,
          content: Container(
            color: myBrown,
            height: dynamicHeight(context, 0.6),
            width: dynamicWidth(context, 0.8),
            child: FutureBuilder(
              future: getWaiters(snapshotTable[indexTable]["sale_id"]),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return loader(context);
                } else if (snapshot.data == false) {
                  return retry(
                    context,
                  );
                } else if (snapshot.data.length == 0) {
                  return Center(
                      child: text(context, "no Waiters!!", 0.028, myWhite));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () async {
                          CoolAlert.show(
                              context: context,
                              type: CoolAlertType.loading,
                              barrierDismissible: false,
                              lottieAsset: "assets/loader.json");
                          assignTable = snapshot.data[index]["id"];

                          var response = await assignWaiterOnline(
                              snapshotTable[indexTable]["sale_id"],
                              assignTable);
                          if (response == false) {
                            Navigator.of(context, rootNavigator: true).pop();
                            MotionToast.error(
                              description:
                                  Text("Waiter not assigned Check your internet"),
                              dismissable: true,
                            ).show(context);
                          } else {
                            Navigator.pop(context, function());
                            Navigator.of(context, rootNavigator: true).pop();
                            if (searchDelegate != "") {
                              searchDelegate();
                            }
                            MotionToast.success(
                              description: Text("Waiter assigned"),
                              dismissable: true,
                            ).show(context);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: myYellow,
                          child: FittedBox(
                            child: Padding(
                              padding:
                                  EdgeInsets.all(dynamicWidth(context, 0.01)),
                              child: text(
                                  context,
                                  snapshot.data[index]["full_name"],
                                  0.04,
                                  myWhite,
                                  alignText: TextAlign.center),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return text(context, "not working", 0.028, myWhite);
                }
              },
            ),
          ),
        );
      });
}
