import 'package:baked_pos/app_screens/print.dart';
import 'package:baked_pos/utils/app_routes.dart';
import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/buttons.dart';
import 'package:baked_pos/widgets/drawer.dart';
import 'package:baked_pos/widgets/form_fields.dart';
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
  final phone = TextEditingController();

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
        cost +=
            num.parse(item["cost"] == "" ? "0" : item["cost"]) * item["qty"];
      }
      return cost;
    }

    return Scaffold(
      backgroundColor: myWhite,
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
                text(context, "Your Cart", 0.05, myBrown),
              ],
            ),
            Divider(
              thickness: 1,
              color: myBlack.withOpacity(0.5),
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
                    setState(() {});
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
            text(context, "Phone number: ", 0.04, myBrown),
            inputTextField(context, "Phone", phone),
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
                        "itemUnitCost": item["cost"] == "" ? "0" : item["cost"],
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
                    onConfirmBtnTap: () {
                      Navigator.of(context, rootNavigator: true).pop();

                      push(context, Print(filteredItems, "Card"));
                    },
                    onCancelBtnTap: () {
                      Navigator.of(context, rootNavigator: true).pop();

                      push(
                        context,
                        Print(
                          filteredItems,
                          "Cash",
                          total: getTotal().toString(),
                          cost: getCost().toString(),
                        ),
                      );
                    },
                    backgroundColor: myYellow,
                  );
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
