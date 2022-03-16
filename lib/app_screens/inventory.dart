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

  String ids = "", statuses = "", controllerText = "";

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
                            controllers = List.generate(
                              snapshot.data.length,
                              (i) => TextEditingController(),
                            );
                            return SizedBox(
                              width: dynamicWidth(context, 1),
                              height: dynamicHeight(context, 1),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: dynamicWidth(context, .8),
                                      height: dynamicHeight(context, .66),
                                      child: Scrollbar(
                                        interactive: true,
                                        showTrackOnHover: true,
                                        trackVisibility: true,
                                        thickness: dynamicWidth(context, 0.01),
                                        radius: Radius.circular(
                                          dynamicWidth(context, 0.1),
                                        ),
                                        child: ListView.builder(
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (context, i) {
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
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: dynamicHeight(context, .02),
                                        bottom: dynamicHeight(context, .4),
                                      ),
                                      child: coloredButton(
                                        context,
                                        "Update",
                                        myYellow,
                                        width: dynamicWidth(context, .6),
                                        function: () async {
                                          for (int i = 0; i < 19; i++) {
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

                                            controllerText == ""
                                                ? controllerText =
                                                    controllerText +
                                                        controllers[i]
                                                            .text
                                                            .toString()
                                                : controllerText =
                                                    controllerText +
                                                        "," +
                                                        controllers[i]
                                                            .text
                                                            .toString();
                                          }

                                          print(
                                              "\n\n\n\n controllers =>$controllerText<= + =>$ids<= + =>$statuses<=");

                                          dynamic tempResponse =
                                              await inventoryUpdate(
                                            ids,
                                            controllerText,
                                            statuses,
                                          );

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: myRed,
                                              duration:
                                                  const Duration(seconds: 2),
                                              content: text(
                                                context,
                                                tempResponse.toString(),
                                                0.04,
                                                myWhite,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
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
