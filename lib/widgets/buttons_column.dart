import 'package:baked_pos/app_screens/menu.dart';
import 'package:baked_pos/utils/app_routes.dart';
import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/guest_arrived_function.dart';
import 'package:baked_pos/widgets/show_alert.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

import 'green_buttons.dart';

buttonsColumn(context, buttonText1, buttonText2, snapshotTable, indexTable,
    assignTable, function, visibleButton, searchDelegate) {
  return SizedBox(
    height: dynamicWidth(
        context,
        (buttonText1 == "View details" || buttonText2 == "View details") &&
                visibleButton == true
            ? 0.37
            : 0.26),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: (buttonText1 == "View details" ||
                      buttonText2 == "View details") &&
                  visibleButton == true
              ? true
              : false,
          child: greenButtons(context, "Take Order", snapshotTable, indexTable,
              function: () {
            push(
                context,
                MenuPage(
                  saleId: snapshotTable[indexTable]["sale_id"].toString(),
                  tableNo: snapshotTable[indexTable]["table_id"].toString(),
                  tableName: snapshotTable[indexTable]["table_name"],
                ));
          }),
        ),
        greenButtons(context, buttonText1, snapshotTable, indexTable,
            function: () async {
          if (buttonText1 == "View details") {
            // push(
            //     context,
            //     OrderSummaryPage(
            //       saleId: snapshotTable[indexTable]["sale_id"].toString(),
            //       tableName: snapshotTable[indexTable]["table_name"] ?? "",
            //     )
            // );
          } else if (buttonText1 == "Assign Table") {
            dialogueCustom(context, snapshotTable, indexTable, assignTable,
                function, searchDelegate);
          } else if (buttonText1 == "Assign Waiter") {
            dialogueCustomWaiter(context, snapshotTable, indexTable,
                assignTable, function, searchDelegate);
          } else if (buttonText1 == "Guest Arrived") {
            CoolAlert.show(
                context: context,
                type: CoolAlertType.confirm,
                showCancelBtn: true,
                confirmBtnText: "Yes",
                backgroundColor: myYellow,
                barrierDismissible: false,
                confirmBtnColor: myYellow,
                confirmBtnTextStyle: TextStyle(
                    fontSize: dynamicWidth(context, 0.04), color: myWhite),
                onConfirmBtnTap: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  guestArrivedNow(
                      context, snapshotTable, indexTable, searchDelegate);
                });
          } else {
            MotionToast.info(
              description: const Text("Something Went wrong"),
              dismissable: true,
            ).show(context);
          }
        }),
        Visibility(
          visible: visibleButton,
          child: greenButtons(
            context,
            buttonText2,
            snapshotTable,
            indexTable,
            function: () {
              if (buttonText2 == "Assign Waiter") {
                dialogueCustomWaiter(context, snapshotTable, indexTable,
                    assignTable, function, searchDelegate);
              } else if (buttonText2 == "Assign Table" ||
                  buttonText2 == "Change Table") {
                dialogueCustom(context, snapshotTable, indexTable, assignTable,
                    function, searchDelegate);
              } else if (buttonText2 == "Take Order") {
                push(
                    context,
                    MenuPage(
                      saleId: snapshotTable[indexTable]["sale_id"].toString(),
                      tableNo: snapshotTable[indexTable]["table_id"].toString(),
                      tableName: snapshotTable[indexTable]["table_name"],
                    ));
              } else if (buttonText2 == "View details") {
                // push(
                //   context,
                //   OrderSummaryPage(
                //       saleId: snapshotTable[indexTable]["sale_id"].toString(),
                //       tableName: snapshotTable[indexTable]["table_name"]),
                // );
              } else {
                MotionToast.error(
                  description: const Text("Something went Wrong"),
                  width: dynamicWidth(context, 0.8),
                ).show(context);
              }
            },
          ),
        ),
      ],
    ),
  );
}
