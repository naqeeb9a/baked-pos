import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/widgets/buttons.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:permission_handler/permission_handler.dart';

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
  String pathImage = "";
  int total = 0;
  bool loading = true;

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
    print("\n\nobject ${widget.data}");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Token/Bill'),
      ),
      body: loading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : getPrintersList(),
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
              CoolAlert.show(
                  context: context,
                  type: CoolAlertType.loading,
                  barrierDismissible: false,
                  text: "Punching Order");
              var response = await punchOrder(widget.total, widget.cost);
              if (response == false) {
                Navigator.of(context, rootNavigator: true).pop();
                MotionToast.error(
                  description:
                      const Text("Check your internet or try again later"),
                ).show(context);
              } else {
                Navigator.of(context, rootNavigator: true).pop();
                startPrintFunc(devices[i], response.toString());
              }
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
            coloredButton(context, "Give Bluetooth Permission", myBrown,
                width: dynamicWidth(context, 0.8), function: () async {
              if (await Permission.bluetoothConnect.status.isDenied) {
                await Permission.bluetoothConnect.request().then(
                      (value) => getStatus(),
                    );
              }
            })
          ],
        ),
      );
    }
  }

  startPrintFunc(BluetoothDevice selectedDevice, saleNo) async {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.loading,
        barrierDismissible: false,
        text: "Printing");
    await printer.connect(selectedDevice).then((value) async {
      if ((await printer.isConnected)!) {
        printer.printCustom("Baked", 2, 1);
        printer.printCustom("Lahore,Pakistan", 1, 1);
        printer.printCustom("PNTN #6270509-2", 1, 1);
        printer.printCustom("#$saleNo", 1, 1);
        printer.printNewLine();
        printer.printCustom(
            "Cashier: " + userResponse["full_name"].toString(), 1, 0);

        printer.printCustom("...............................", 1, 1);

        for (var i = 0; i < widget.data.length; i++) {
          total += int.parse(widget.data[i]['productprice']);

          printer.printCustom("${widget.data[i]['productname']}", 1, 0);

          widget.data[i]['item_discount'] == "0%"
              ? printer.printLeftRight(
                  "${widget.data[i]['productqty']} x ${widget.data[i]['productprice']}",
                  "${int.parse(widget.data[i]['productprice'].toString()) * int.parse(widget.data[i]['productqty'].toString())}",
                  1,
                )
              : printer.printLeftRight(
                  "${widget.data[i]['productqty']} x ${widget.data[i]['productprice']} - ${widget.data[i]['item_discount']}",
                  "${int.parse(widget.data[i]['productprice'].toString()) * int.parse(widget.data[i]['productqty'].toString())}",
                  1,
                );
          printer.printCustom("-------------", 1, 1);
        }

        printer.printCustom("...............................", 1, 1);

        printer.printLeftRight("Subtotal", "$total", 1);
        printer.printLeftRight(
          widget.paymentMethod == "Card" ? "Sales tax 5%" : "Sales tax 16%",
          widget.paymentMethod == "Cash"
              ? (total * 0.16).toStringAsFixed(0)
              : (total * 0.05).toStringAsFixed(0),
          1,
        );

        printer.printCustom("...............................", 1, 1);

        printer.printLeftRight(
          "Total",
          widget.paymentMethod == "Cash"
              ? ((total * 0.16) + total).toStringAsFixed(0)
              : ((total * 0.05) + total).toStringAsFixed(0),
          1,
        );
        printer.printLeftRight(
          widget.paymentMethod,
          widget.paymentMethod == "Cash"
              ? ((total * 0.16) + total).toStringAsFixed(0)
              : ((total * 0.05) + total).toStringAsFixed(0),
          1,
        );

        printer.printCustom("...............................", 1, 1);

        printer.printCustom("Shop # 6 PAF Market Lahore.", 1, 1);
        printer.printCustom("+92 304 5222533", 1, 1);
        printer.printCustom(
            DateFormat.yMEd().add_jm().format(DateTime.now()), 1, 1);

        printer.printNewLine();
        printer.printNewLine();
        printer.printCustom(" ", 1, 1);

        printer.paperCut();
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
    cartItems.clear();
    Navigator.pop(context);
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
