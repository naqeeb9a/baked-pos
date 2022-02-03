import 'package:baked_pos/app_functions/functions.dart';
import 'package:baked_pos/utils/app_routes.dart';
import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/buttons.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MenuPage extends StatefulWidget {
  final String saleId, tableNo, tableName;

  const MenuPage({
    Key? key,
    required this.saleId,
    required this.tableNo,
    required this.tableName,
  }) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    saleIdGlobal = widget.saleId;
    tableNoGlobal = widget.tableNo;
    tableNameGlobal = widget.tableName;
    return Scaffold(
      backgroundColor: myBlack,
      body: WillPopScope(
        onWillPop: () async {
          if (cartItems.isEmpty) {
            return true;
          } else {
            CoolAlert.show(
                context: context,
                type: CoolAlertType.warning,
                text: "if you leave this page your cart items will discard",
                cancelBtnText: "Cancel",
                confirmBtnText: "Yes",
                backgroundColor: myYellow,
                confirmBtnColor: myYellow,
                confirmBtnTextStyle: TextStyle(
                    fontSize: dynamicWidth(context, 0.04), color: myWhite),
                showCancelBtn: true,
                onCancelBtnTap: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                onConfirmBtnTap: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  cartItems.clear();
                  pop(context);
                });
          }
          return false;
        },
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: dynamicWidth(context, 0.05)),
          child: Column(
            children: [
              heightBox(context, 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text(context, "Menu", 0.05, myWhite),
                ],
              ),
              const Divider(
                thickness: 1,
                color: myWhite,
              ),
              Expanded(
                child: FutureBuilder(
                  future: getMenu(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data == false) {
                        return retry(
                          context,
                        );
                      } else {
                        if (snapshot.data.length == 0) {
                          return Center(
                            child: text(
                                context, "No Items in Menu", 0.04, myWhite),
                          );
                        } else {
                          return StatefulBuilder(
                              builder: (context, changeState) {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showSearch(
                                      context: context,
                                      delegate:
                                          CustomSearchDelegate(snapshot.data),
                                    ).then((value) => changeState(() {}));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: myWhite,
                                        borderRadius: BorderRadius.circular(
                                            dynamicWidth(context, 0.1))),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          border: const UnderlineInputBorder(
                                              borderSide: BorderSide.none),
                                          hintText: "Search",
                                          enabled: false,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal:
                                                  dynamicWidth(context, 0.05))),
                                    ),
                                  ),
                                ),
                                heightBox(context, 0.02),
                                StatefulBuilder(
                                    builder: (context, changeState) {
                                  menuRefresh = () {
                                    changeState(() {});
                                  };
                                  return Expanded(
                                    child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10,
                                              childAspectRatio: dynamicWidth(
                                                      context, 0.5) /
                                                  dynamicWidth(context, 0.5)),
                                      itemCount: snapshot.data.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return menuCards(
                                            context, snapshot.data, index);
                                      },
                                    ),
                                  );
                                }),
                              ],
                            );
                          });
                        }
                      }
                    } else {
                      return LottieBuilder.asset(
                        "assets/loader.json",
                        width: dynamicWidth(context, 0.3),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

menuCards(context, snapshot, index) {
  return Container(
    decoration: BoxDecoration(
      color: myBrown,
      borderRadius: BorderRadius.circular(
        dynamicWidth(context, 0.02),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                dynamicWidth(context, 0.02),
              ),
              topRight: Radius.circular(
                dynamicWidth(context, 0.02),
              ),
            ),
            child: Image.network(
              snapshot[index]["photo"] ??
                  "https://neurologist-ahmedabad.com/wp-content/themes/apexclinic/images/no-image/No-Image-Found-400x264.png",
              height: dynamicWidth(context, 0.2),
              width: dynamicWidth(context, 0.5),
              fit: BoxFit.cover,
              errorBuilder: (context, yrl, error) {
                return const Icon(
                  Icons.error,
                  color: myWhite,
                );
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: dynamicWidth(context, 0.02),
          ),
          child: FittedBox(
            clipBehavior: Clip.antiAlias,
            child: text(
              context,
              snapshot[index]["name"],
              0.03,
              myWhite,
            ),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: dynamicWidth(context, 0.02)),
          child: text(
            context,
            "Rs ." + snapshot[index]["sale_price"],
            0.04,
            myWhite,
          ),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: dynamicWidth(context, 0.02)),
          child: iconsRow(
            context,
            snapshot[index],
          ),
        ),
        heightBox(context, 0.005),
      ],
    ),
  );
}

iconsRow(context, snapshot) {
  var quantity = 1;
  return StatefulBuilder(builder: (context, changeState) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
              onTap: () {
                if (!cartItems.contains(snapshot)) {
                  snapshot["qty"] = quantity;
                  snapshot['setState'] = () {
                    changeState(() {});
                  };
                  cartItems.add(snapshot);

                  changeState(() {});
                } else {
                  cartItems.remove(snapshot);

                  changeState(() {});
                }
              },
              child: Container(
                height: dynamicWidth(context, 0.08),
                child: Center(
                  child: text(
                    context,
                    cartItems.contains(snapshot) ? "Added" : "Add to Cart",
                    0.04,
                    cartItems.contains(snapshot) ? myWhite : myBrown,
                    alignText: TextAlign.center,
                    bold: true,
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(dynamicWidth(context, 0.02)),
                  color: cartItems.contains(snapshot) ? myYellow : myWhite,
                ),
              )),
        ),
      ],
    );
  });
}

class CustomSearchDelegate extends SearchDelegate {
  dynamic menu;

  CustomSearchDelegate(this.menu);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        textSelectionTheme: const TextSelectionThemeData(cursorColor: myWhite),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: myBrown),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: myBrown),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: myBrown),
          ),
        ),
        textTheme: const TextTheme(
          headline6: TextStyle(
            color: myWhite,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: const AppBarTheme(color: myBrown),
        scaffoldBackgroundColor: myBrown);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ) // IconButton
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    ); // IconButton
  }

  @override
  Widget buildResults(BuildContext context) {
    dynamic matchQuery = [];
    for (var item in menu) {
      if (item["name"].toString().toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }

    return matchQuery.length == 0
        ? Center(
            child: text(context, "No Items found", 0.04, myWhite,
                alignText: TextAlign.center))
        : Padding(
            padding: EdgeInsets.all(dynamicWidth(context, 0.05)),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio:
                    dynamicWidth(context, 0.5) / dynamicWidth(context, 0.5),
              ),
              itemCount: matchQuery.length,
              itemBuilder: (BuildContext context, int index) {
                return menuCards(context, matchQuery, index);
              },
            ),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    dynamic matchQuery = [];
    for (var item in menu) {
      if (item["name"].toString().toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return matchQuery.length == 0
        ? Center(
            child: text(context, "No Items found", 0.04, myWhite,
                alignText: TextAlign.center))
        : Padding(
            padding: EdgeInsets.all(dynamicWidth(context, 0.05)),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio:
                    dynamicWidth(context, 0.5) / dynamicWidth(context, 0.5),
              ),
              itemCount: matchQuery.length,
              itemBuilder: (BuildContext context, int index) {
                return menuCards(context, matchQuery, index);
              },
            ),
          ); // ListTile
  }
}
