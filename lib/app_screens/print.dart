import 'dart:convert';

import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/widgets/buttons.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_functions/functions.dart';
import '../utils/dynamic_sizes.dart';

class Print extends StatefulWidget {
  final dynamic data, paymentMethod, total, cost, customer, phone;

  const Print(this.data, this.paymentMethod,
      {Key? key,
      this.total,
      this.cost,
      required this.customer,
      required this.phone})
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

  PermissionStatus check = PermissionStatus.denied;

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
    if (check.isGranted) {
      getDevices();

      return devices.isEmpty
          ? Center(
              child: text(
                  context,
                  "Turn on Bluetooth Or check Your paired devices",
                  0.04,
                  myBlack),
            )
          : ListView.builder(
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
                        widget.phone,
                        widget.customer);
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

printContent(
  BluetoothDevice selectedDevice,
  context,
  printer,
  data,
  total,
  cost,
  paymentMethod,
  response, {
  checkAlreadyDevice = false,
  customState = "",
}) {
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
    printer.printCustom("${data[i]['discount_person']}", 1, 0);
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

printSalesContent(BluetoothDevice selectedDevice, context, printer, data) {
  printer.printCustom("Baked", 2, 1);
  printer.printCustom("Lahore,Pakistan", 1, 1);

  printer.printNewLine();

  printer.printCustom("...............................", 1, 1);

  for (var i = 0; i < data.length; i++) {
    printer.printLeftRight("${data[i]['name']}", "${data[i]['qty']}", 1);
    printer.printCustom("-------------", 1, 1);
  }
  printer.printNewLine();

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
    cost, paymentMethod, phone, customer,
    {checkAlreadyDevice = false, changeState = ""}) async {
  CoolAlert.show(
    context: context,
    type: CoolAlertType.loading,
    barrierDismissible: false,
    text: "Punching Order",
  );
  var response = await punchOrder(total, cost, paymentMethod,
      customerPhone: phone, customerName: customer);
  if (response == false) {
    Navigator.of(context, rootNavigator: true).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: myRed,
        duration: const Duration(seconds: 2),
        content: text(
          context,
          "Check your Internet",
          0.04,
          myWhite,
        ),
      ),
    );
  } else {
    Navigator.of(context, rootNavigator: true).pop();

    CoolAlert.show(
      context: context,
      type: CoolAlertType.loading,
      barrierDismissible: false,
      text: "Printing",
    );
    try {
      if (await printer.isConnected) {
        conditionalStatements(selectedDevice, context, printer, data, total,
            cost, paymentMethod, response, checkAlreadyDevice, changeState);
      } else {
        await printer.connect(selectedDevice).then((value) async {
          if ((await printer.isConnected)!) {
            conditionalStatements(selectedDevice, context, printer, data, total,
                cost, paymentMethod, response, checkAlreadyDevice, changeState);
          } else {
            Navigator.of(context, rootNavigator: true).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: myRed,
                duration: const Duration(seconds: 2),
                content: text(
                  context,
                  "Check your Printer and try again",
                  0.04,
                  myWhite,
                ),
              ),
            );
          }
        });
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: myRed,
          duration: const Duration(seconds: 2),
          content: text(
              context, "Check your Printer and try again", 0.04, myWhite)));
    }
  }
}

printSales(BluetoothDevice selectedDevice, context, printer, data) async {
  CoolAlert.show(
    context: context,
    type: CoolAlertType.loading,
    barrierDismissible: false,
    text: "Printing",
  );
  try {
    await printer.connect(selectedDevice).then((value) async {
      if ((await printer.isConnected)!) {
        Navigator.of(context, rootNavigator: true).pop();
        await printSalesContent(selectedDevice, context, printer, data);
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: myRed,
            duration: const Duration(seconds: 2),
            content: text(
              context,
              "Check your Printer and try again",
              0.04,
              myWhite,
            ),
          ),
        );
      }
    });
  } catch (e) {
    Navigator.of(context, rootNavigator: true).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: myRed,
        duration: const Duration(seconds: 2),
        content:
            text(context, "Check your Printer and try again", 0.04, myWhite)));
  }
}

conditionalStatements(selectedDevice, context, printer, data, total, cost,
    paymentMethod, response, checkAlreadyDevice, refresh) async {
  await printContent(selectedDevice, context, printer, data, total, cost,
      paymentMethod, response);
  Navigator.of(context, rootNavigator: true).pop();

  await CoolAlert.show(
    context: context,
    title: "Want another print",
    type: CoolAlertType.confirm,
    confirmBtnColor: myBrown,
    confirmBtnText: "Yes",
    cancelBtnText: "No",
    barrierDismissible: false,
    onConfirmBtnTap: () {
      printContent(selectedDevice, context, printer, data, total, cost,
          paymentMethod, response);
      cartItems.clear();
      Navigator.of(context, rootNavigator: true).pop();
      if (checkAlreadyDevice == false) {
        Navigator.pop(context);
      } else {
        refresh();
      }
    },
    onCancelBtnTap: () {
      cartItems.clear();
      Navigator.of(context, rootNavigator: true).pop();
      if (checkAlreadyDevice == false) {
        Navigator.pop(context);
      } else {
        refresh();
      }
    },
  );
}
