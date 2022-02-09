import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/buttons.dart';
import 'package:baked_pos/widgets/custom_search.dart';
import 'package:baked_pos/widgets/essential_widgets.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:flutter/material.dart';

import 'input_field_home.dart';

Widget tableCards(context, function, buttonText1, buttonText2,
    {setState = "",
    visible = false,
    visibleButton = true,
    shrinkWrap = false,
    physics = const AlwaysScrollableScrollPhysics()}) {
  final TextEditingController _tableNo = TextEditingController();
  var assignTable = 0;
  return FutureBuilder(
    future: function,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.data == false) {
          return shrinkWrap == true
              ? Column(
                  children: [retry(context), heightBox(context, 0.02)],
                )
              : retry(
                  context,
                );
        } else if (snapshot.data.length == 0) {
          return shrinkWrap == true
              ? SizedBox(
                  height: dynamicHeight(context, 0.4),
                  child: Center(
                      child: text(context, "No orders Yet!!", 0.04, myWhite)))
              : Center(child: text(context, "No orders Yet!!", 0.04, myWhite));
        } else {
          return Column(
            children: [
              Visibility(
                  visible: visible,
                  child: Column(
                    children: [
                      heightBox(context, 0.02),
                      InkWell(
                        onTap: () {
                          showSearch(
                            context: context,
                            delegate: CustomDineInSearchDelegate(
                              snapshot.data,
                              setState,
                              assignTable,
                              buttonText1,
                              buttonText2,
                            ),
                          );
                        },
                        child: inputFieldsHome(
                          pageDecider == "Waiting For Arrival" ||
                                  pageDecider == "Arrived Guests"
                              ? "Search"
                              : "Table no:",
                          pageDecider == "Waiting For Arrival" ||
                                  pageDecider == "Arrived Guests"
                              ? "Ex: Name / phone"
                              : "Ex: table no",
                          context,
                          enable: false,
                          controller: _tableNo,
                        ),
                      ),
                      heightBox(context, 0.03),
                    ],
                  )),
              shrinkWrap == true
                  ? RefreshIndicator(
                      onRefresh: () {
                        return Future.delayed(const Duration(milliseconds: 0),
                            () {
                          setState();
                        });
                      },
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        shrinkWrap: shrinkWrap,
                        physics: physics,
                        itemBuilder: (BuildContext context, int index) {
                          return tableCardsExtension(
                            context,
                            snapshot.data,
                            index,
                            buttonText1,
                            buttonText2,
                            function: setState,
                            assignTable: assignTable,
                            visibleButton: visibleButton,
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: RefreshIndicator(
                        onRefresh: () {
                          return Future.delayed(const Duration(milliseconds: 0),
                              () {
                            setState();
                          });
                        },
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          shrinkWrap: shrinkWrap,
                          physics: physics,
                          itemBuilder: (BuildContext context, int index) {
                            return tableCardsExtension(context, snapshot.data,
                                index, buttonText1, buttonText2,
                                function: setState,
                                assignTable: assignTable,
                                visibleButton: visibleButton);
                          },
                        ),
                      ),
                    ),
            ],
          );
        }
      } else {
        return shrinkWrap == true
            ? SizedBox(
                height: dynamicHeight(context, 0.4),
                child: Center(
                  child: loader(context),
                ),
              )
            : loader(context);
      }
    },
  );
}

Widget tableCardsExtension(
  context,
  snapshotTable,
  indexTable,
  buttonText1,
  buttonText2, {
  function = "",
  assignTable,
  visibleButton = true,
  searchDelegate = "",
}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: dynamicHeight(context, 0.01)),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dynamicWidth(context, 0.015)),
        border: Border.all(width: 1, color: myWhite.withOpacity(0.5))),
    padding: EdgeInsets.all(dynamicWidth(context, 0.04)),
    child: Column(
      children: [
        snapshotTable[indexTable]["table_id"] == null
            ? text(
                context,
                snapshotTable[indexTable]["customer_name"]
                    .toString()
                    .toString(),
                0.04,
                myWhite)
            : text(
                context,
                "Table: " + snapshotTable[indexTable]["table_name"].toString(),
                0.04,
                myWhite),
        Divider(
          thickness: 1,
          color: myWhite.withOpacity(0.5),
        ),
        Visibility(
          child: text(
              context,
              snapshotTable[indexTable]["waiter_id"] != null
                  ? "Waiter : " +
                      snapshotTable[indexTable]["waiter_name"]
                          .toString()
                          .toUpperCase()
                  : "No Waiter assigned",
              0.04,
              snapshotTable[indexTable]["waiter_id"] != null ? myYellow : myRed,
              bold: true),
          visible: (pageDecider == "Arrived Guests" ||
                  pageDecider == "Dine In Orders")
              ? true
              : false,
        ),
        Visibility(
          visible: pageDecider == "Dine In Orders" ? true : false,
          child: text(
              context,
              snapshotTable[indexTable]["order_status"] == "1" ||
                      snapshotTable[indexTable]["order_status"] == "2"
                  ? "Active"
                  : "Completed",
              0.04,
              snapshotTable[indexTable]["order_status"] == "1" ||
                      snapshotTable[indexTable]["order_status"] == "2"
                  ? myGreen
                  : myYellow,
              bold: true),
        ),
        heightBox(context, 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: dynamicWidth(context, 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text(
                      context,
                      "Order: " +
                          snapshotTable[indexTable]["sale_no"].toString(),
                      0.035,
                      myWhite),
                  text(
                      context,
                      "Name: " +
                          snapshotTable[indexTable]["customer_name"].toString(),
                      0.035,
                      myWhite),
                  text(
                      context,
                      "Phone: " +
                          snapshotTable[indexTable]["customer_phone"]
                              .toString(),
                      0.035,
                      myWhite),
                  text(
                      context,
                      "Date: " +
                          snapshotTable[indexTable]["booking_date"].toString(),
                      0.035,
                      myWhite),
                  text(
                      context,
                      "Time: ",
                      // getConvertedTime(
                      //     snapshotTable[indexTable]["opening_time"]) +
                      // " - " +
                      // getConvertedTime(
                      //     snapshotTable[indexTable]["closing_time"]),
                      0.035,
                      myWhite),
                  text(
                      context,
                      "Seats: " +
                          snapshotTable[indexTable]["booked_seats"].toString(),
                      0.035,
                      myWhite),
                  text(
                    context,
                    snapshotTable[indexTable]["usage_status"].toString() ==
                            "dine_in"
                        ? "Status: Dine In"
                        : "Status: " +
                            snapshotTable[indexTable]["usage_status"]
                                .toString(),
                    0.035,
                    myWhite,
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    ),
  );
}
