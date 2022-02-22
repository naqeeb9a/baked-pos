import 'dart:convert';

import 'package:baked_pos/app_screens/print.dart';
import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/buttons.dart';
import 'package:baked_pos/widgets/drawer.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    getTotal() {
      num total = 0;
      for (var item in cartItems) {
        total += num.parse(item["discounted_price"].toString()) * item["qty"];
      }
      return total;
    }

    getCost() {
      num cost = 0;
      for (var item in cartItems) {
        cost += num.parse(item["cost"] == "" || item["cost"] == null
                ? "0"
                : item["cost"]) *
            item["qty"];
      }
      return cost;
    }

    return Scaffold(
      backgroundColor: myWhite,
      body: Column(
        children: [
          heightBox(context, 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              text(context, "Your Cart", 0.05, myBrown),
            ],
          ),
          Divider(
            thickness: 1,
            color: myBlack.withOpacity(0.5),
          ),
          Expanded(
              child: Scrollbar(
            interactive: true,
            showTrackOnHover: true,
            trackVisibility: true,
            isAlwaysShown: true,
            thickness: dynamicWidth(context, 0.01),
            radius: Radius.circular(dynamicWidth(context, 0.1)),
            child: ListView.builder(
              padding:
                  EdgeInsets.symmetric(horizontal: dynamicWidth(context, 0.02)),
              itemCount: cartItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: dynamicHeight(context, 0.01),
                  ),
                  child: CartCards(
                      context: context,
                      index: index,
                      function: () {
                        setState(() {});
                      }),
                );
              },
            ),
          )),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: dynamicWidth(context, 0.02)),
            decoration: BoxDecoration(
                color: myGrey.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(dynamicWidth(context, 0.04)),
                    topRight: Radius.circular(dynamicWidth(context, 0.04)))),
            child: Column(
              children: [
                dividerRowWidgets(
                    context,
                    "TOTAL 5% GST: (Card)",
                    "PKR " +
                        ((getTotal() * 0.05) + getTotal()).toStringAsFixed(0),
                    check: true),
                dividerRowWidgets(
                    context,
                    "TOTAL 16% GST: (Cash)",
                    "PKR " +
                        ((getTotal() * 0.16) + getTotal()).toStringAsFixed(0),
                    check: true),
                heightBox(context, 0.02),
                coloredButton(
                  context,
                  "Place Order",
                  myYellow,
                  fontSize: 0.035,
                  function: () async {
                    if (cartItems.isEmpty) {
                      MotionToast.info(
                        description: const Text("Cart is empty"),
                        dismissable: true,
                      ).show(context);
                    } else {
                      var filteredItems = [];

                      filterFunction() {
                        for (var item in cartItems) {
                          filteredItems.add({
                            "productid": item["id"],
                            "productname": item["name"],
                            "productcode": item["code"],
                            "productprice": item["sale_price"],
                            "discounted_price": item["discounted_price"],
                            "item_discount": item["item_discount"],
                            "itemUnitCost":
                                item["cost"] == "" ? "0" : item["cost"],
                            "productqty": item["qty"],
                            "productimg": item["photo"]
                          });
                        }
                        return filteredItems;
                      }

                      filterFunction();

                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.confirm,
                        confirmBtnColor: myBrown,
                        confirmBtnText: "Via Card",
                        cancelBtnText: "Via Cash",
                        onConfirmBtnTap: () async {
                          Navigator.of(context, rootNavigator: true).pop();

                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          BluetoothDevice? getDevice() {
                            String? device = prefs.getString("selectedPrinter");
                            if (device != null && device.isNotEmpty) {
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
                            startPrintFunc(
                              selectedDevice,
                              context,
                              printer,
                              filteredItems,
                              getTotal(),
                              getCost(),
                              "Card",
                              checkAlreadyDevice: true,
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Print(
                                  filteredItems,
                                  "Card",
                                  total: getTotal().toString(),
                                  cost: getCost().toString(),
                                ),
                              ),
                            ).then((value) {
                              setState(() {});
                            });
                          }
                        },
                        onCancelBtnTap: () async {
                          Navigator.of(context, rootNavigator: true).pop();

                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          BluetoothDevice? getDevice() {
                            String? device = prefs.getString("selectedPrinter");
                            if (device != null && device.isNotEmpty) {
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
                            startPrintFunc(
                              selectedDevice,
                              context,
                              printer,
                              filteredItems,
                              getTotal(),
                              getCost(),
                              "Cash",
                              checkAlreadyDevice: true,
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Print(
                                  filteredItems,
                                  "Cash",
                                  total: getTotal().toString(),
                                  cost: getCost().toString(),
                                ),
                              ),
                            ).then((value) {
                              setState(() {});
                            });
                          }
                        },
                        backgroundColor: myYellow,
                      );
                    }
                  },
                ),
                heightBox(context, 0.02),
              ],
            ),
          )
        ],
      ),
    );
  }
}
