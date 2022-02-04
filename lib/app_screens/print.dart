import 'dart:io' show Platform;
import 'dart:typed_data';

import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:image/image.dart';

class Print extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const Print(this.data, {Key? key}) : super(key: key);

  @override
  _PrintState createState() => _PrintState();
}

class _PrintState extends State<Print> {
  final PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  String? _devicesMsg;
  BluetoothManager bluetoothManager = BluetoothManager.instance;

  @override
  void initState() {
    if (Platform.isAndroid) {
      bluetoothManager.state.listen((val) {
        if (!mounted) return;
        if (val == 12) {
          initPrinter();
        } else if (val == 10) {
          setState(() => _devicesMsg = 'Bluetooth Disconnect!');
        }
      });
    } else {
      initPrinter();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print'),
      ),
      body: _devices.isEmpty
          ? Center(child: Text(_devicesMsg ?? ''))
          : ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (c, i) {
                return ListTile(
                  leading: const Icon(Icons.print),
                  title: text(
                    context,
                    _devices[i].name.toString(),
                    .04,
                    myBrown,
                  ),
                  subtitle: text(
                    context,
                    _devices[i].address.toString(),
                    .04,
                    myBrown,
                  ),
                  onTap: () {
                    _startPrint(_devices[i]);
                  },
                );
              },
            ),
    );
  }

  void initPrinter() {
    _printerManager.startScan(const Duration(seconds: 2));
    _printerManager.scanResults.listen((val) {
      if (!mounted) return;
      setState(() => _devices = val);
      if (_devices.isEmpty) setState(() => _devicesMsg = 'No Devices');
    });
  }

  Future<void> _startPrint(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);
    final result =
        await _printerManager.printTicket(await _ticket(PaperSize.mm80));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(result.msg),
      ),
    );
  }

  Future<Ticket> _ticket(PaperSize paper) async {
    final ticket = Ticket(paper);
    int total = 0;

    // Image assets
    final ByteData data = await rootBundle.load('assets/store.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final Image? image = decodeImage(bytes);
    ticket.image(image);

    ticket.feed(1);

    ticket.text(
      'Lahore, Pakistan.',
      styles: const PosStyles(align: PosAlign.center, bold: false),
    );

    ticket.feed(1);

    ticket.text(
      'Token Number : 001',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    ticket.feed(1);

    ticket.hr(
      '-',
      32,
    );

    for (var i = 0; i < widget.data.length; i++) {
      total += int.parse(widget.data[i]['total_price']);

      ticket.row([
        PosColumn(
          text:
              "${widget.data[i]['title']}\n${widget.data[i]['qty']} x ${widget.data[i]['price']}",
          width: 8,
        ),
        PosColumn(text: '${widget.data[i]['total_price']}', width: 4),
      ]);
      ticket.feed(1);
    }

    ticket.feed(1);

    ticket.hr(
      '-',
      32,
    );

    ticket.row([
      PosColumn(
        text: 'Subtotal',
        width: 6,
        styles: const PosStyles(bold: true),
      ),
      PosColumn(
        text: '$total',
        width: 6,
        styles: const PosStyles(bold: true),
      ),
    ]);

    ticket.row([
      PosColumn(
        text: 'Sales tax, 16%',
        width: 6,
        styles: const PosStyles(bold: false),
      ),
      PosColumn(
        text: '$total',
        width: 6,
        styles: const PosStyles(bold: false),
      ),
    ]);

    ticket.hr(
      '-',
      32,
    );
    ticket.row([
      PosColumn(
        text: 'Total',
        width: 6,
        styles: const PosStyles(
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      ),
      PosColumn(
        text: '$total',
        width: 6,
        styles: const PosStyles(
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      ),
    ]);
    ticket.row([
      PosColumn(
        text: 'Card',
        width: 6,
        styles: const PosStyles(bold: false),
      ),
      PosColumn(
        text: '$total',
        width: 6,
        styles: const PosStyles(bold: false),
      ),
    ]);
    ticket.hr(
      '-',
      32,
    );
    ticket.feed(1);
    ticket.text(
      'Shop # 4, Paf Market, Lahore.',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    ticket.feed(1);
    ticket.text(
      'Thank You',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    ticket.cut();

    return ticket;
  }

  @override
  void dispose() {
    _printerManager.stopScan();
    super.dispose();
  }
}
