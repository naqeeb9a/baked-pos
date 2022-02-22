import 'dart:convert';

import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/widgets/buttons.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_functions/functions.dart';
import '../utils/dynamic_sizes.dart';

class Print extends StatefulWidget {
  final dynamic data, paymentMethod, total, cost;

  const Print(this.data, this.paymentMethod, {Key? key, this.total, this.cost})
      : super(key: key);

  @override
  _PrintState createState() => _PrintState();
}

class _PrintState extends State<Print> {
  List<BluetoothDevice> devices = [];
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  BluetoothDevice? bluetoothDevice;
  String pathImage = "";
  int total = 0;
  bool loading = true;
  bool? availablePrinter;

  PermissionStatus? check;

  getDevices() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  @override
  void initState() {
    getStatus();

    super.initState();
  }

  getStatus() async {
    setState(() {
      loading = true;
    });
    check = await Permission.bluetoothConnect.status;
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Token/Bill'),
      ),
      body: getPrintersList(),
    );
  }

  getPrintersList() {
    if (check!.isGranted) {
      getDevices();

      return ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: Icon(
              Icons.print,
              color: myBrown,
              size: dynamicHeight(context, .046),
            ),
            title: text(
              context,
              devices[i].name.toString(),
              .04,
              myBrown,
              bold: true,
            ),
            subtitle: text(
              context,
              devices[i].address.toString(),
              .034,
              myBlack,
            ),
            onTap: () async {
              SharedPreferences loginUser =
                  await SharedPreferences.getInstance();

              await loginUser.setString(
                "selectedPrinter",
                jsonEncode(devices[i].toMap()),
              );

              startPrintFunc(
                devices[i],
                context,
                printer,
                widget.data,
                widget.total,
                widget.cost,
                widget.paymentMethod,
              );
            },
          );
        },
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            text(context, "Give Bluetooth permission", 0.04, Colors.black),
            coloredButton(
              context,
              "Give Bluetooth Permission",
              myBrown,
              width: dynamicWidth(context, 0.8),
              function: () async {
                if (await Permission.bluetoothConnect.status.isDenied) {
                  await Permission.bluetoothConnect.request().then(
                        (value) => getStatus(),
                      );
                }
              },
            )
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    disconnectDevice();
    super.dispose();
  }

  disconnectDevice() async {
    if ((await printer.isConnected)!) {
      printer.disconnect();
    }
  }
}

printContent(BluetoothDevice selectedDevice, context, printer, data, total,
    cost, paymentMethod, response,
    {checkAlreadyDevice = false}) {
  printer.printCustom("Baked", 2, 1);
  printer.printCustom("Lahore,Pakistan", 1, 1);
  printer.printCustom("PNTN #6270509-2", 1, 1);
  printer.printCustom("#${response.toString()}", 1, 1);
  printer.printNewLine();
  printer.printCustom("Cashier: " + userResponse["full_name"].toString(), 1, 0);

  printer.printCustom("...............................", 1, 1);

  for (var i = 0; i < data.length; i++) {
    printer.printCustom("${data[i]['productname']}", 1, 0);

    data[i]['item_discount'] == "0"
        ? printer.printLeftRight(
            "${data[i]['productqty']} x ${data[i]['productprice']}",
            "${int.parse(data[i]['productprice'].toString()) * int.parse(data[i]['productqty'].toString())}",
            1,
          )
        : printer.printLeftRight(
            "${data[i]['productqty']} x ${data[i]['productprice']} - ${data[i]['item_discount']}%",
            ((int.parse(data[i]['productqty'].toString()) *
                        int.parse(data[i]['productprice'].toString())) -
                    ((int.parse(data[i]['productqty'].toString()) *
                            int.parse(data[i]['productprice'].toString())) *
                        (int.parse(data[i]['item_discount'].toString()) / 100)))
                .toStringAsFixed(0),
            1,
          );
    printer.printCustom("-------------", 1, 1);
  }

  printer.printCustom("...............................", 1, 1);

  printer.printLeftRight("Subtotal", "$total", 1);
  printer.printLeftRight(
    paymentMethod == "Card" ? "Sales tax 5%" : "Sales tax 16%",
    paymentMethod == "Cash"
        ? (int.parse(total.toString()) * 0.16).toStringAsFixed(0)
        : (int.parse(total.toString()) * 0.05).toStringAsFixed(0),
    1,
  );

  printer.printCustom("...............................", 1, 1);

  printer.printLeftRight(
    "Total",
    paymentMethod == "Cash"
        ? ((int.parse(total.toString()) * 0.16) + int.parse(total.toString()))
            .toStringAsFixed(0)
        : ((int.parse(total.toString()) * 0.05) + int.parse(total.toString()))
            .toStringAsFixed(0),
    1,
  );
  printer.printLeftRight(
    paymentMethod,
    paymentMethod == "Cash"
        ? ((int.parse(total.toString()) * 0.16) + int.parse(total.toString()))
            .toStringAsFixed(0)
        : ((int.parse(total.toString()) * 0.05) + int.parse(total.toString()))
            .toStringAsFixed(0),
    1,
  );

  printer.printCustom("...............................", 1, 1);

  printer.printCustom("Shop # 6 PAF Market Lahore.", 1, 1);
  printer.printCustom("+92 304 5222533", 1, 1);
  printer.printCustom(DateFormat.yMEd().add_jm().format(DateTime.now()), 1, 1);

  printer.printNewLine();
  printer.printNewLine();
  printer.printCustom(" ", 1, 1);

  printer.paperCut();
}

startPrintFunc(BluetoothDevice selectedDevice, context, printer, data, total,
    cost, paymentMethod,
    {checkAlreadyDevice = false}) async {
  CoolAlert.show(
    context: context,
    type: CoolAlertType.loading,
    barrierDismissible: false,
    text: "Punching Order",
  );
  var response = await punchOrder(total, cost, paymentMethod);
  if (response == false) {
    Navigator.of(context, rootNavigator: true).pop();
    MotionToast.error(
      description: const Text("Check your internet or try again later"),
    ).show(context);
  } else {
    Navigator.of(context, rootNavigator: true).pop();

    CoolAlert.show(
      context: context,
      type: CoolAlertType.loading,
      barrierDismissible: false,
      text: "Printing",
    );
    if (await printer.isConnected) {
      printContent(selectedDevice, context, printer, data, total, cost,
          paymentMethod, response);

      // cartItems.clear();
      Navigator.of(context, rootNavigator: true).pop();
      // Navigator.of(context, rootNavigator: true).pop();
      CoolAlert.show(
        context: context,
        title: "Want another print",
        type: CoolAlertType.confirm,
        confirmBtnColor: myBrown,
        confirmBtnText: "Yes",
        cancelBtnText: "No",
        onConfirmBtnTap: () {
          printContent(selectedDevice, context, printer, data, total, cost,
              paymentMethod, response);
          cartItems.clear();
          Navigator.of(context, rootNavigator: true).pop();
          if (checkAlreadyDevice == false) {
            Navigator.pop(context);
          }
        },
        onCancelBtnTap: () {
          cartItems.clear();
          Navigator.of(context, rootNavigator: true).pop();
          if (checkAlreadyDevice == false) {
            Navigator.pop(context);
          }
        },
      );
      if (checkAlreadyDevice == false) {
        Navigator.pop(context);
      }
    } else {
      await printer.connect(selectedDevice).then((value) async {
        if ((await printer.isConnected)!) {
          printContent(selectedDevice, context, printer, data, total, cost,
              paymentMethod, response);
        } else {
          Navigator.of(context, rootNavigator: true).pop();
          MotionToast.error(
            description: const Text("Try again check if device is connected"),
            dismissable: true,
          );
          return;
        }
        cartItems.clear();
        Navigator.of(context, rootNavigator: true).pop();
      });
    }
  }

  if (checkAlreadyDevice == false) {
    Navigator.pop(context);
  }
}
