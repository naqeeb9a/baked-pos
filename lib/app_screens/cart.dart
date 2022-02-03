import 'package:baked_pos/app_functions/functions.dart';
import 'package:baked_pos/utils/app_routes.dart';
import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/buttons.dart';
import 'package:baked_pos/widgets/drawer.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    getTotal() {
      num total = 0;
      for (var item in cartItems) {
        total += num.parse(item["sale_price"]) * item["qty"];
      }
      return total;
    }

    getCost() {
      num cost = 0;
      for (var item in cartItems) {
        cost += num.parse(item["cost"] ?? "0") * item["qty"];
      }
      return cost;
    }

    return Scaffold(
      backgroundColor: myBlack,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: dynamicWidth(context, 0.04),
        ),
        child: Column(
          children: [
            heightBox(context, 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                text(context, "Your Cart", 0.05, myWhite),
              ],
            ),
            Divider(
              thickness: 1,
              color: myWhite.withOpacity(0.5),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: dynamicHeight(context, 0.01),
                  ),
                  child: cartCards(context, index, () {
                    // changeState(() {});
                  }),
                );
              },
            )),
            dividerRowWidgets(context, "TOTAL 5% GST: ",
                "PKR " + ((getTotal() * 0.05) + getTotal()).toStringAsFixed(2),
                check: true),
            dividerRowWidgets(context, "TOTAL 16% GST: ",
                "PKR " + ((getTotal() * 0.16) + getTotal()).toStringAsFixed(2),
                check: true),
            heightBox(context, 0.02),
            coloredButton(
              context,
              "Place Order",
              myGreen,
              fontSize: 0.035,
              function: () async {
                if (cartItems.isEmpty) {
                  MotionToast.info(
                    description: const Text("Cart is empty"),
                    dismissable: true,
                  ).show(context);
                } else {
                  CoolAlert.show(
                      context: context,
                      type: CoolAlertType.confirm,
                      confirmBtnText: "Yes",
                      backgroundColor: myYellow,
                      confirmBtnColor: myYellow,
                      confirmBtnTextStyle: TextStyle(
                          fontSize: dynamicWidth(context, 0.04),
                          color: myWhite),
                      text: userResponse["full_name"]
                                  .toString()
                                  .toUpperCase() ==
                              "FLOORMANAGER"
                          ? "Order against Table no: $tableNameGlobal by ${userResponse["full_name"].toString().toUpperCase()}"
                          : "Order against Table no: $tableNameGlobal with assigned waiter ${userResponse["full_name"].toString().toUpperCase()}",
                      showCancelBtn: true,
                      onConfirmBtnTap: () async {
                        Navigator.of(context, rootNavigator: true).pop();
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.loading,
                            barrierDismissible: false,
                            lottieAsset: "assets/loader.json");
                        var response = await punchOrder(getTotal(), getCost());
                        if (response == false) {
                          Navigator.of(context, rootNavigator: true).pop();
                          MotionToast.error(
                            description: const Text(
                                "Server Error or check your internet"),
                            dismissable: true,
                          ).show(context);
                        } else {
                          Navigator.of(context, rootNavigator: true).pop();
                          cartItems.clear();
                          saleIdGlobal = "";
                          tableNoGlobal = "";

                          pop(context);
                          popUntil(globalDineInContext);
                          globalDineInRefresh();
                          CoolAlert.show(
                            title: "Order Placed",
                            text: "Do you wish to proceed?",
                            context: context,
                            loopAnimation: true,
                            backgroundColor: myYellow,
                            confirmBtnColor: myYellow,
                            confirmBtnText: "Continue",
                            type: CoolAlertType.success,
                            animType: CoolAlertAnimType.slideInRight,
                          );
                        }
                      });
                }
              },
            ),
            heightBox(context, 0.02),
          ],
        ),
      ),
    );
  }
}
