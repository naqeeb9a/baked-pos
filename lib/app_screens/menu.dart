import 'package:baked_pos/app_functions/functions.dart';
import 'package:baked_pos/utils/app_routes.dart';
import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/buttons.dart';
import 'package:baked_pos/widgets/expansion_tile.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

import '../widgets/Search.dart';
import '../widgets/essential_widgets.dart';
import '../widgets/menu_cards.dart';

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
              FutureBuilder(
                future: getMenu(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == false) {
                      return const SizedBox();
                    } else {
                      if (snapshot.data.length == 0) {
                        return Center(
                          child:
                              text(context, "No Items in Menu", 0.04, myWhite),
                        );
                      } else {
                        return StatefulBuilder(builder: (context, changeState) {
                          return ExpansionTile(
                            title: Text(
                              "Complete Menu",
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
                              InkWell(
                                onTap: () {
                                  showSearch(
                                    context: context,
                                    delegate:
                                        CustomSearchDelegate(snapshot.data),
                                  ).then(
                                    (value) => changeState(() {}),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.brown.shade400,
                                    borderRadius: BorderRadius.circular(
                                      dynamicWidth(context, 0.1),
                                    ),
                                  ),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: const UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintStyle:
                                          const TextStyle(color: myWhite),
                                      hintText: "Search",
                                      enabled: false,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: dynamicWidth(context, 0.05),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              heightBox(context, 0.02),
                              SizedBox(
                                height: dynamicHeight(context, .4),
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio:
                                        dynamicWidth(context, 0.5) /
                                            dynamicWidth(context, 0.6),
                                  ),
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return menuCards(
                                      context,
                                      snapshot.data,
                                      index,
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        });
                      }
                    }
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              heightBox(context, 0.03),
              const Divider(
                thickness: .2,
                color: myBlack,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text(context, "Categories", 0.07, myBrown, bold: true),
                ],
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
                                initiallyExpanded: true,
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

                                        return customExpansionTile(context,
                                            subCategory, snapshot, setState);
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
