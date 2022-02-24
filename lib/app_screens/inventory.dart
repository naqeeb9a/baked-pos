import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/buttons.dart';
import 'package:baked_pos/widgets/input_field_home.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            title: text(
              context,
              "Inventory Update",
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
          ),
          Expanded(
            child: Container(
              width: dynamicWidth(context, .9),
              decoration: BoxDecoration(
                color: myBrown.withOpacity(0.8),
                borderRadius: BorderRadius.circular(
                  dynamicHeight(context, .02),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: dynamicWidth(context, .05),
                vertical: dynamicHeight(context, .02),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    inputFieldsHome(
                      "Milk",
                      "Milk",
                      context,
                      controller: TextEditingController(),
                    ),
                    heightBox(context, .02),
                    inputFieldsHome(
                      "Sugar",
                      "Sugar",
                      context,
                      controller: TextEditingController(),
                    ),
                    heightBox(context, .02),
                    inputFieldsHome(
                      "Napkin",
                      "Napkin",
                      context,
                      controller: TextEditingController(),
                    ),
                    heightBox(context, .02),
                    inputFieldsHome(
                      "Voyager (Blend)",
                      "Voyager (Blend)",
                      context,
                      controller: TextEditingController(),
                    ),
                    heightBox(context, .02),
                    inputFieldsHome(
                      "EL Salvador",
                      "EL Salvador",
                      context,
                      controller: TextEditingController(),
                    ),
                    heightBox(context, .02),
                    inputFieldsHome(
                      "Rwanda",
                      "Rwanda",
                      context,
                      controller: TextEditingController(),
                    ),
                    heightBox(context, .02),
                    inputFieldsHome(
                      "Costa Rica",
                      "Costa Rica",
                      context,
                      controller: TextEditingController(),
                    ),
                    heightBox(context, .02),
                    inputFieldsHome(
                      "Chocolate Sauce",
                      "Chocolate Sauce",
                      context,
                      controller: TextEditingController(),
                    ),
                    heightBox(context, .02),
                    inputFieldsHome(
                      "Golden Mixer",
                      "Golden Mixer",
                      context,
                      controller: TextEditingController(),
                    ),
                    heightBox(context, .02),
                    inputFieldsHome(
                      "Stirrer",
                      "Stirrer",
                      context,
                      controller: TextEditingController(),
                    ),
                    heightBox(context, .02),
                    inputFieldsHome(
                      "Paper Cup",
                      "Paper Cup",
                      context,
                      controller: TextEditingController(),
                    ),
                    heightBox(context, .06),
                    coloredButton(
                      context,
                      "Update",
                      myYellow,
                      width: dynamicWidth(context, .6),
                    ),
                    heightBox(context, .01),
                  ],
                ),
              ),
            ),
          ),
          heightBox(context, .02),
        ],
      ),
    );
  }
}
