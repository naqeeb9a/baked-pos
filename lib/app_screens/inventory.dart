import 'dart:convert';

import 'package:baked_pos/app_functions/functions.dart';
import 'package:baked_pos/app_screens/print.dart';
import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/buttons.dart';
import '../widgets/input_field_home.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  List controllers = [];

  String ids = "", statuses = "";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SizedBox(
          width: dynamicWidth(context, 1),
          height: dynamicHeight(context, 1),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: dynamicWidth(context, 1),
                  height: dynamicHeight(context, .1),
                  child: AppBar(
                    title: text(
                      context,
                      "Day End",
                      .06,
                      myBrown,
                      bold: true,
                    ),
                    centerTitle: true,
                    backgroundColor: myWhite,
                    elevation: 0.0,
                    iconTheme: const IconThemeData(
                      color: myBrown,
                    ),
                    bottom: TabBar(
                      unselectedLabelColor: myGrey,
                      labelColor: myYellow,
                      unselectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: dynamicWidth(context, .034),
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: dynamicWidth(context, .046),
                      ),
                      tabs: const [
                        Tab(
                          text: "Today Sales",
                        ),
                        Tab(
                          text: "Inventory Update",
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: dynamicWidth(context, 1),
                  height: dynamicHeight(context, .76),
                  child: TabBarView(
                    children: [
                      FutureBuilder(
                        future: salesItem(),
                        builder: ((context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData &&
                              snapshot.data.length != 0) {
                            return SizedBox(
                              width: dynamicWidth(context, 1),
                              height: dynamicHeight(context, .76),
                              child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, i) {
                                  return GestureDetector(
                                    onTap: () async {
                                      final SharedPreferences prefs =
                                          await SharedPreferences.getInstance();

                                      BluetoothDevice? getDevice() {
                                        String? device =
                                            prefs.getString("selectedPrinter");
                                        if (device != null &&
                                            device.isNotEmpty) {
                                          var map = jsonDecode(device);
                                          BluetoothDevice bluetoothDevice =
                                              BluetoothDevice.fromMap(map);
                                          return bluetoothDevice;
                                        } else {
                                          return null;
                                        }
                                      }

                                      BlueThermalPrinter printer =
                                          BlueThermalPrinter.instance;
                                      var selectedDevice = getDevice();
                                      if (selectedDevice != null) {
                                        printSales(selectedDevice, context,
                                            printer, snapshot.data);
                                      }
                                    },
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.inventory,
                                        color: myBrown,
                                      ),
                                      title: text(
                                        context,
                                        snapshot.data[i]['name'].toString(),
                                        .05,
                                        myBrown,
                                        bold: true,
                                      ),
                                      subtitle: text(
                                        context,
                                        "Qty: ${snapshot.data[i]['qty'].toString()}",
                                        .04,
                                        myBrown,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return Center(
                              child: text(
                                context,
                                "No Data to show!!",
                                .05,
                                myBrown,
                                bold: true,
                              ),
                            );
                          }
                        }),
                      ),
                      FutureBuilder(
                        future: inventoryList(),
                        builder: ((context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData &&
                              snapshot.data.length != 0) {
                            controllers.clear();
                            ids = "";
                            statuses = "";
                            return SizedBox(
                              width: dynamicWidth(context, 1),
                              height: dynamicHeight(context, 1),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: dynamicWidth(context, .8),
                                      height: dynamicHeight(context, 1.76),
                                      child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, i) {
                                          final controller =
                                              TextEditingController();
                                          controllers.add(controller);
                                          ids == ""
                                              ? ids = ids +
                                                  snapshot.data[i]['id']
                                                      .toString()
                                              : ids = ids +
                                                  "," +
                                                  snapshot.data[i]['id']
                                                      .toString();
                                          statuses == ""
                                              ? statuses = statuses + "MINUS"
                                              : statuses =
                                                  statuses + "," + "MINUS";

                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical:
                                                  dynamicHeight(context, .01),
                                            ),
                                            child: inputFieldsHome(
                                              snapshot.data[i]['name']
                                                  .toString(),
                                              snapshot.data[i]['name']
                                                  .toString(),
                                              context,
                                              keyBoardType:
                                                  TextInputType.number,
                                              controller: controllers[i],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: dynamicHeight(context, .02),
                                        bottom: dynamicHeight(context, .4),
                                      ),
                                      child: coloredButton(
                                          context, "Update", myYellow,
                                          width: dynamicWidth(context, .6),
                                          function: () {
                                        String contollerText = "";
                                        for (var element in controllers) {
                                          contollerText == ""
                                              ? contollerText = contollerText +
                                                  element.text.toString()
                                              : contollerText = contollerText +
                                                  "," +
                                                  element.text.toString();
                                          print("foreach $statuses");
                                          print("foreach1 $ids");
                                          print(
                                              "foreach2 $contollerText === ${controllers.length}");
                                        }

                                        var temp = inventoryUpdate(
                                          ids,
                                          contollerText,
                                          statuses,
                                        );


                                        print("temp ===== $temp");
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: text(
                                context,
                                "No Data to show!!",
                                .05,
                                myBrown,
                                bold: true,
                              ),
                            );
                          }
                        }),
                      ),
                    ],
                  ),
                ),
                heightBox(context, .02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
