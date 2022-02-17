import 'package:baked_pos/app_functions/functions.dart';
import 'package:baked_pos/utils/app_routes.dart';
import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/form_fields.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'buttons.dart';

Widget drawerItems(context, function, changeState) {
  List drawerItemList = [
    {
      "icon": Icons.calendar_today,
      "text": "New Reservations",
      "function": () {
        pageDecider = "New Reservations";
        popUntil(customContext);
        Navigator.pop(context, function());
      },
    },
    {
      "icon": Icons.calendar_today,
      "text": "All Reservations",
      "function": () {
        pageDecider = "All Reservations";
        popUntil(customContext);
        Navigator.pop(context, function());
      },
    },
    {
      "icon": Icons.share_arrival_time_rounded,
      "text": "Waiting For Arrival",
      "function": () {
        pageDecider = "Waiting For Arrival";
        popUntil(customContext);
        Navigator.pop(context, function());
      },
    },
    {
      "icon": Icons.supervised_user_circle_rounded,
      "text": "Arrived Guests",
      "function": () {
        pageDecider = "Arrived Guests";
        popUntil(customContext);
        Navigator.pop(context, function());
      },
    },
    {
      "icon": Icons.notes_rounded,
      "text": "Dine In Orders",
      "function": () {
        pageDecider = "Dine In Orders";
        popUntil(customContext);
        Navigator.pop(context, function());
      },
    },
    {
      "icon": Icons.open_in_browser,
      "text": "Callback Url",
      "function": () {
        pageDecider = "Callback Url";
        popUntil(customContext);
        Navigator.pop(context, function());
      },
    },
    {
      "icon": Icons.logout,
      "text": "LogOut",
      "function": () async {
        changeState();
        SharedPreferences loginUser = await SharedPreferences.getInstance();
        loginUser.clear();
        userResponse = "";
        checkLoginStatus(context);
      },
    },
  ];
  return SafeArea(
    child: ColoredBox(
      color: myBrown.withOpacity(.9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: dynamicHeight(context, .02),
              horizontal: dynamicWidth(context, .02),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "assets/menu.png",
                  scale: 30,
                ),
                FittedBox(
                    child: text(context, "MENU", .04, myWhite, bold: true)),
                InkWell(
                  onTap: () {
                    pop(context);
                  },
                  child: Icon(
                    Icons.close_rounded,
                    color: myWhite,
                    size: dynamicWidth(context, .08),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 0,
            color: myWhite,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: dynamicHeight(context, .04),
                horizontal: dynamicWidth(context, 0.02)),
            child: FittedBox(
              child: text(
                  context,
                  userResponse == ""
                      ? ""
                      : "Hi ${userResponse["full_name"] ?? ""}"
                          "\n(${userResponse["designation"] ?? ""})"
                          "\n\n${userResponse["outlet_name"] ?? ""}",
                  .05,
                  myWhite,
                  bold: true,
                  maxLines: 4),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(
                top: dynamicHeight(context, .036),
                left: dynamicWidth(context, .02),
              ),
              child: ListView.builder(
                itemCount: drawerItemList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: drawerItemList[index]["function"],
                    leading: Icon(
                      drawerItemList[index]["icon"],
                      color: myWhite,
                    ),
                    title: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        drawerItemList[index]["text"].toString().toUpperCase(),
                        style: TextStyle(
                          color: myWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: dynamicWidth(context, .04),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // const BottomBannerAd(),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: dynamicHeight(context, .02),
            ),
            child: text(
              context,
              "Version: $version"
              "\nPowered by CMC M-Tech",
              .034,
              myWhite,
              maxLines: 4,
              alignText: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget drawerItems2(context) {
  return StatefulBuilder(builder: (context, changeState) {
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

    return ColoredBox(
      color: myBrown.withOpacity(.9),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: dynamicWidth(context, 0.04),
        ),
        child: Column(
          children: [
            dividerRowWidgets(context, "YOUR CART", ""),
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
                  child: CartCards(
                      context: context,
                      index: index,
                      function: () {
                        changeState(() {});
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
                              animType: CoolAlertAnimType.slideInRight);
                        }
                      });
                }
              },
            ),
            heightBox(context, 0.02),
            coloredButton(
              context,
              "CONTINUE ORDERING",
              noColor,
              fontSize: 0.035,
              function: () {
                pop(context);
              },
            ),
            heightBox(context, 0.02),
          ],
        ),
      ),
    );
  });
}

class CartCards extends StatefulWidget {
  final dynamic context, index, function;
  const CartCards(
      {Key? key,
      required this.context,
      required this.function,
      required this.index})
      : super(key: key);

  @override
  State<CartCards> createState() => _CartCardsState();
}

class _CartCardsState extends State<CartCards> {
  final _text = TextEditingController();
  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                getRow(text1, text2) {
                  return InkWell(
                    onTap: () {
                      dynamic actualPrice = int.parse(
                          cartItems[widget.index]["sale_price"].toString());
                      cartItems[widget.index]["discounted_price"] =
                          (actualPrice -
                                  (actualPrice * (int.parse(text2) / 100)))
                              .toStringAsFixed(0);
                      cartItems[widget.index]["item_discount"] = text2 + "%";
                      Navigator.of(context, rootNavigator: true).pop();

                      widget.function();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        text(context, text1, 0.04, myBlack),
                        text(context, text2 + "%", 0.04, myBlack),
                      ],
                    ),
                  );
                }

                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: myWhite,
                        title: text(context, "Discount", 0.04, myBrown,
                            alignText: TextAlign.center, bold: true),
                        content: Container(
                          color: myWhite,
                          height: dynamicHeight(context, 0.4),
                          width: dynamicWidth(context, 0.7),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              getRow("Hassan", "10"),
                              const Divider(),
                              getRow("Gujjar", "20"),
                              const Divider(),
                              getRow("Saleem", "30"),
                              const Divider(),
                              getRow("Oppo", "40"),
                              const Divider(),
                              text(context, "Custom Discount: ", 0.04, myBrown),
                              inputTextField(context, "Custom Discount", _text,
                                  keyboard: TextInputType.number),
                              const Divider(),
                              coloredButton(context, "Submit", myYellow,
                                  width: dynamicWidth(context, 0.5),
                                  function: () {
                                if (int.parse(_text.text) <= 100) {
                                  dynamic actualPrice = int.parse(
                                      cartItems[widget.index]["sale_price"]
                                          .toString());
                                  cartItems[widget.index]
                                      ["discounted_price"] = (actualPrice -
                                          (actualPrice *
                                              (int.parse(_text.text) / 100)))
                                      .toStringAsFixed(0);
                                  cartItems[widget.index]["item_discount"] =
                                      _text.text + "%";
                                  pop(context);
                                  widget.function();
                                } else {
                                  MotionToast.info(
                                    description: const Text(
                                        "Discount can't be greater than 100"),
                                    dismissable: true,
                                  ).show(context);
                                }
                              })
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(dynamicWidth(context, 0.02)),
                child: Image.network(
                  cartItems[widget.index]["photo"] ??
                      "https://images.unsplash.com/photo-1578985545062-69928b1d9587?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHx8&w=1000&q=80",
                  height: dynamicWidth(context, 0.3),
                  width: dynamicWidth(context, 0.3),
                  fit: BoxFit.cover,
                  errorBuilder: (context, yrl, error) {
                    return const Icon(
                      Icons.error,
                      color: myBlack,
                    );
                  },
                ),
              ),
            ),
            widthBox(context, 0.05),
            FittedBox(
              child: SizedBox(
                width: dynamicWidth(context, 0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    text(
                      context,
                      cartItems[widget.index]["name"].toString(),
                      0.04,
                      myBlack,
                    ),
                    heightBox(context, 0.01),
                    Container(
                        width: dynamicWidth(context, 0.25),
                        decoration: BoxDecoration(
                            color: myGrey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(
                                dynamicWidth(context, 0.02)),
                            border: Border.all(color: myWhite, width: 1)),
                        child: StatefulBuilder(builder: (context, changeState) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                splashColor: noColor,
                                onTap: () {
                                  if (int.parse(cartItems[widget.index]["qty"]
                                          .toString()) >
                                      1) {
                                    var value = int.parse(
                                        cartItems[widget.index]["qty"]
                                            .toString());
                                    value--;
                                    cartItems[widget.index]["qty"] = value;
                                    widget.function();
                                  }
                                },
                                child: SizedBox(
                                    width: dynamicWidth(context, .1),
                                    height: dynamicWidth(context, .07),
                                    child: Center(
                                      child: text(context, "-", 0.04, myBlack,
                                          bold: true,
                                          alignText: TextAlign.center),
                                    )),
                              ),
                              Text(
                                cartItems[widget.index]["qty"].toString(),
                                style: TextStyle(
                                  color: myBlack,
                                  fontWeight: FontWeight.bold,
                                  fontSize: dynamicWidth(context, .03),
                                ),
                              ),
                              InkWell(
                                splashColor: noColor,
                                onTap: () {
                                  if (int.parse(cartItems[widget.index]["qty"]
                                          .toString()) <
                                      30) {
                                    var value = int.parse(
                                        cartItems[widget.index]["qty"]
                                            .toString());
                                    value++;
                                    cartItems[widget.index]["qty"] = value;
                                    widget.function();
                                  }
                                },
                                child: SizedBox(
                                    width: dynamicWidth(context, .1),
                                    height: dynamicWidth(context, .07),
                                    child: Center(
                                      child: text(context, "+", 0.04, myBlack,
                                          bold: true,
                                          alignText: TextAlign.center),
                                    )),
                              ),
                            ],
                          );
                        })),
                  ],
                ),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            cartItems.remove(cartItems[widget.index]);
            widget.function();
          },
          child: const Icon(
            Icons.close,
            color: myBlack,
          ),
        )
      ],
    );
  }
}

Widget dividerRowWidgets(context, text1, text2, {check = false}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: dynamicHeight(context, 0.01)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: dynamicWidth(context, 0.36),
          child: FittedBox(
            child: text(context, text1, 0.04, myBlack),
          ),
        ),
        check == true
            ? SizedBox(
                width: dynamicWidth(context, 0.2),
                child: FittedBox(
                  child: text(
                    context,
                    "$text2",
                    0.04,
                    myBlack,
                  ),
                ),
              )
            : InkWell(
                onTap: () {
                  pop(context);
                },
                child: Icon(
                  Icons.close_rounded,
                  color: myBlack,
                  size: dynamicWidth(context, .08),
                ),
              ),
      ],
    ),
  );
}
