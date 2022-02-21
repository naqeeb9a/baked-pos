
import 'package:baked_pos/app_functions/functions.dart';
import 'package:baked_pos/utils/app_routes.dart';
import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/buttons.dart';
import 'package:baked_pos/widgets/essential_widgets.dart';
import 'package:baked_pos/widgets/menu_cards.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/Search.dart';

class MenuExtension extends StatelessWidget {
  final dynamic customSnapshot;
  const MenuExtension({Key? key, required this.customSnapshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List choiceChipValues = [];
    var customIndex = 0;
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: dynamicWidth(context, 0.02)),
      child: customSnapshot == "menu"
          ? allMenu()
          : StatefulBuilder(builder: (context, changeState) {
              return Column(
                children: [
                  SizedBox(
                    height: dynamicHeight(context, 0.1),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: customSnapshot.length,
                        itemBuilder: (context, index) {
                          if (choiceChipValues.isEmpty) {
                            choiceChipValues.add(true);
                          } else {
                            choiceChipValues.add(false);
                          }
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: dynamicWidth(context, 0.02)),
                            child: ChoiceChip(
                                onSelected: (bool value) {
                                  if (customIndex != index) {
                                    changeState(() {
                                      for (var i = 0;
                                          i < choiceChipValues.length;
                                          i++) {
                                        choiceChipValues[i] = false;
                                      }
                                      choiceChipValues[index] = value;
                                      customIndex = index;
                                    });
                                  }
                                },
                                selectedColor: myYellow,
                                label: text(
                                    context,
                                    customSnapshot[index]["category_name"],
                                    0.04,
                                    myBlack),
                                selected: choiceChipValues[index]),
                          );
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () {
                            pop(context);
                          },
                          child: const Icon(Icons.arrow_back_ios)),
                      InkWell(
                        onTap: () {
                          showSearch(
                            context: context,
                            delegate: CustomSearchDelegate(
                                customSnapshot[customIndex]["item"]),
                          ).then(
                            (value) => changeState(() {}),
                          );
                        },
                        child: Container(
                          width: dynamicWidth(context, 0.8),
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
                              hintStyle: const TextStyle(color: myWhite),
                              hintText: "Search",
                              enabled: false,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: dynamicWidth(context, 0.05),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: customSnapshot[customIndex]["item"].length == 0
                        ? Center(
                            child: text(context, "No items", 0.04, myBlack))
                        : GridView.builder(
                            itemCount: customSnapshot[customIndex]["item"]
                                .length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio:
                                        dynamicWidth(context, 0.4) /
                                            dynamicWidth(context, 0.5),
                                    mainAxisSpacing:
                                        dynamicWidth(context, 0.02),
                                    crossAxisSpacing:
                                        dynamicWidth(context, 0.02)),
                            itemBuilder: (context, index) => menuCards(context,
                                customSnapshot[customIndex]["item"], index)),
                  ),
                ],
              );
            }),
    ));
  }

  allMenu() {
    return FutureBuilder(
        future: getMenu(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == false) {
              return retry(context);
            } else if (snapshot.data.length == 0) {
              return text(context, "No items in List", 0.03, myBlack);
            } else {
              return StatefulBuilder(builder: (context, changeState) {
                return Column(
                  children: [
                    heightBox(context, 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                            onTap: () {
                              pop(context);
                            },
                            child: const Icon(Icons.arrow_back_ios)),
                        InkWell(
                          onTap: () {
                            showSearch(
                              context: context,
                              delegate: CustomSearchDelegate(snapshot.data),
                            ).then(
                              (value) => changeState(() {}),
                            );
                          },
                          child: Container(
                            width: dynamicWidth(context, 0.8),
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
                                hintStyle: const TextStyle(color: myWhite),
                                hintText: "Search",
                                enabled: false,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: dynamicWidth(context, 0.05),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: GridView.builder(
                          itemCount: snapshot.data.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: dynamicWidth(context, 0.4) /
                                      dynamicWidth(context, 0.5),
                                  mainAxisSpacing: dynamicWidth(context, 0.02),
                                  crossAxisSpacing:
                                      dynamicWidth(context, 0.02)),
                          itemBuilder: (context, index) =>
                              menuCards(context, snapshot.data, index)),
                    ),
                  ],
                );
              });
            }
          } else {
            return loader(context);
          }
        });
  }
}
