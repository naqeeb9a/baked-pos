import 'package:baked_pos/app_functions/functions.dart';
import 'package:baked_pos/utils/app_routes.dart';
import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/buttons.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/essential_widgets.dart';

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

class _MenuPageState extends State<MenuPage>
    with AutomaticKeepAliveClientMixin<MenuPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: myWhite,
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
                  text(context, "Menu", 0.07, myBrown, bold: true),
                ],
              ),
              const Divider(
                thickness: 1,
                color: myBlack,
              ),
              Expanded(
                child: FutureBuilder(
                  future: getMenuCategories(),
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
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, i) {
                              var category = snapshot.data[i];
                              return ExpansionTile(
                                title: Text(
                                  category['category_name'],
                                  style: TextStyle(
                                    color: myBrown,
                                    fontSize: dynamicWidth(context, .05),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                iconColor: myYellow,
                                collapsedIconColor: myBrown,
                                tilePadding: EdgeInsets.zero,
                                childrenPadding: EdgeInsets.symmetric(
                                  horizontal: dynamicWidth(context, .02),
                                ),
                                children: [
                                  SizedBox(
                                    height: dynamicHeight(context, 1),
                                    child: ListView.builder(
                                      itemCount: category['child'].length,
                                      itemBuilder: (context, j) {
                                        var subCategory = category['child'][j];
                                        return ExpansionTile(
                                          title: Text(
                                            subCategory['category_name'],
                                            style: TextStyle(
                                              color: myBrown,
                                              fontSize:
                                                  dynamicWidth(context, .046),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          iconColor: myYellow,
                                          collapsedIconColor: myBrown,
                                          tilePadding: EdgeInsets.zero,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showSearch(
                                                  context: context,
                                                  delegate:
                                                      CustomSearchDelegate(
                                                          snapshot.data),
                                                ).then(
                                                  (value) => setState(() {}),
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color:
                                                        Colors.brown.shade400,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            dynamicWidth(
                                                                context, 0.1))),
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                      border:
                                                          const UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                      hintStyle:
                                                          const TextStyle(
                                                              color: myWhite),
                                                      hintText: "Search",
                                                      enabled: false,
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  dynamicWidth(
                                                                      context,
                                                                      0.05))),
                                                ),
                                              ),
                                            ),
                                            heightBox(context, 0.02),
                                            SizedBox(
                                              height:
                                                  dynamicHeight(context, .5),
                                              child: GridView.builder(
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10,
                                                  childAspectRatio:
                                                      dynamicWidth(
                                                              context, 0.5) /
                                                          dynamicWidth(
                                                              context, 0.6),
                                                ),
                                                itemCount:
                                                    subCategory['item'].length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return menuCards(
                                                    context,
                                                    subCategory['item'],
                                                    index,
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                        }
                      }
                    } else {
                      return loader(context);
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
        color: myWhite,
        borderRadius: BorderRadius.circular(
          dynamicWidth(context, 0.02),
        ),
        boxShadow: [
          BoxShadow(
              color: myBrown.withOpacity(0.1),
              offset: const Offset(1, 1),
              spreadRadius: 2,
              blurRadius: 2)
        ]),
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
                  "https://images.unsplash.com/photo-1578985545062-69928b1d9587?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHx8&w=1000&q=80",
              height: dynamicWidth(context, 0.3),
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
            child: text(context, snapshot[index]["name"], 0.03, myBrown,
                bold: true),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: dynamicWidth(context, 0.02)),
          child: text(
              context, "Rs ." + snapshot[index]["sale_price"], 0.04, myYellow,
              bold: true),
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
    var customText = "Add to Cart";
    var customColor = myWhite;
    var customColor1 = myBrown;
    for (var item in cartItems) {
      if (item["id"] == snapshot["id"]) {
        customColor = myBrown;
        customColor1 = myYellow;
        customText = "Added";
      }
    }
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
              onTap: () {
                if (customColor == myWhite) {
                  snapshot["qty"] = quantity;
                  snapshot['setState'] = () {
                    changeState(() {});
                  };

                  changeState(() {
                    cartItems.add(snapshot);
                  });
                } else {
                  int count = 0;
                  int removeIndex = 0;
                  changeState(() {
                    for (var item in cartItems) {
                      if (item["id"] == snapshot["id"]) {
                        removeIndex = count;
                      }
                      count++;
                    }
                    cartItems.removeAt(removeIndex);
                  });
                }
              },
              child: Container(
                height: dynamicWidth(context, 0.08),
                child: Center(
                  child: text(
                    context,
                    customText,
                    0.04,
                    customColor,
                    alignText: TextAlign.center,
                    bold: true,
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(dynamicWidth(context, 0.02)),
                  color: customColor1,
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
          hintStyle: TextStyle(color: myWhite),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: noColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: noColor),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: noColor),
          ),
        ),
        textTheme: const TextTheme(
          headline6: TextStyle(
            color: myWhite,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: AppBarTheme(
          color: Colors.brown.shade400,
        ),
        scaffoldBackgroundColor: myWhite);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
          color: myBlack,
        ),
        onPressed: () {
          query = "";
        },
      ) // IconButton
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: myBlack,
      ),
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
                return SizedBox();

                // return menuCards(context, matchQuery, index);
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
                return SizedBox();
                // return menuCards(context, matchQuery, index);
              },
            ),
          ); // ListTile
  }
}
