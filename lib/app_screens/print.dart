import 'dart:io' show File;

import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

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

  @override
  void initState() {
    getDevices();
    super.initState();
  }

  initSaveToPath() async {
    const filename = 'logo200.png';
    var bytes = await rootBundle.load("assets/logo200.png");
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes, '$dir/$filename');
    setState(() {
      pathImage = '$dir/$filename';
    });
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );
  }

  getDevices() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
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
                    onTap: () {
                      startPrintFunc(devices[i]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  startPrintFunc(BluetoothDevice selectedDevice) async {
    await printer.connect(selectedDevice);
    if ((await printer.isConnected)!) {
      printer.printImage(pathImage);
      printer.printCustom("Lahore,Pakistan", 0, 1);
      printer.printNewLine();
      printer.printCustom("PNTN #1234", 0, 1);
      printer.printNewLine();
      printer.printCustom("Cashier: Abc", 0, 0);
      printer.printCustom("POS: Abc", 0, 0);
      printer.printNewLine();

      for (var i = 0; i < widget.data.length; i++) {
        total += int.parse(widget.data[i]['productprice']);

        printer.printLeftRight(
          "${widget.data[i]['productname']}\n${widget.data[i]['productqty']} x ${widget.data[i]['productprice']}",
          "${int.parse(widget.data[i]['productprice'].toString()) * int.parse(widget.data[i]['productqty'].toString())}",
          0,
        );
        printer.printNewLine();
      }

      printer.printNewLine();

      printer.printLeftRight("Subtotal", "$total", 0);
      printer.printLeftRight(
        widget.paymentMethod == "Card" ? "Sales tax 16%" : "Sales tax 5%",
        widget.paymentMethod == "Cash"
            ? (total * 0.16).toStringAsFixed(2)
            : (total * 0.05).toStringAsFixed(2),
        0,
      );
      printer.printNewLine();
      printer.printLeftRight(
        "Total",
        widget.paymentMethod == "Cash"
            ? ((total * 0.16) + total).toStringAsFixed(2)
            : ((total * 0.05) + total).toStringAsFixed(2),
        1,
      );
      printer.printLeftRight(
        widget.paymentMethod,
        widget.paymentMethod == "Cash"
            ? ((total * 0.16) + total).toStringAsFixed(2)
            : ((total * 0.05) + total).toStringAsFixed(2),
        0,
      );
      printer.printNewLine();
      printer.printCustom("Shop # 6 PAF Market Lahore.", 0, 1);
      printer.printLeftRight(
          DateFormat.yMEd().add_jms().format(DateTime.now()), "#1234", 0);
    }
  }

  @override
  void dispose() {
    printer.disconnect();
    super.dispose();
  }
}
