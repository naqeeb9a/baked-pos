import 'package:baked_pos/utils/app_routes.dart';
import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/menu_cards.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/Search.dart';

class MenuExtension extends StatelessWidget {
  final dynamic customSnapshot, check;
  const MenuExtension(
      {Key? key, required this.customSnapshot, this.check = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List choiceChipValues = [];
    var customIndex = 0;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: dynamicWidth(context, 0.02)),
          child: check == true
              ? allMenu(customSnapshot)
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
                                useRootNavigator: true,
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
                                itemBuilder: (context, index) => menuCards(
                                    context,
                                    customSnapshot[customIndex]["item"],
                                    index)),
                      ),
                    ],
                  );
                }),
        ));
  }

  allMenu(snapshot) {
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
                    useRootNavigator: true,
                    context: context,
                    delegate: CustomSearchDelegate(snapshot),
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
                itemCount: snapshot.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio:
                        dynamicWidth(context, 0.4) / dynamicWidth(context, 0.5),
                    mainAxisSpacing: dynamicWidth(context, 0.02),
                    crossAxisSpacing: dynamicWidth(context, 0.02)),
                itemBuilder: (context, index) =>
                    menuCards(context, snapshot, index)),
          ),
        ],
      );
    });
  }
}
