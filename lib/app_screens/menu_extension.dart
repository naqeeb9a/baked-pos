import 'package:baked_pos/app_functions/functions.dart';
import 'package:baked_pos/utils/app_routes.dart';
import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/buttons.dart';
import 'package:baked_pos/widgets/custom_search2.dart';
import 'package:baked_pos/widgets/essential_widgets.dart';
import 'package:baked_pos/widgets/menu_cards.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class MenuExtension extends StatefulWidget {
  final dynamic customSnapshot, check, setstate1;

  const MenuExtension(
      {Key? key,
      required this.customSnapshot,
      this.check = false,
      this.setstate1})
      : super(key: key);

  @override
  State<MenuExtension> createState() => _MenuExtensionState();
}

class _MenuExtensionState extends State<MenuExtension> {
  bool loading = false;
  dynamic data;

  @override
  void initState() {
    widget.check == true ? getMenuGridNow() : null;
    super.initState();
  }

  getMenuGridNow() async {
    setState(() {
      loading = true;
    });
    data = await getMenu();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List choiceChipValues = [];
    var customIndex = 0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: widget.check == true
          ? allMenu(data)
          : StatefulBuilder(
              builder: (context, changeState) {
                return Column(
                  children: [
                    SizedBox(
                      height: dynamicHeight(context, 0.1),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.customSnapshot.length,
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
                                      widget.customSnapshot[index]
                                          ["category_name"],
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
                              delegate: CustomSearchDelegateMenu(
                                  widget.customSnapshot[customIndex]["item"],
                                  () {
                                changeState(() {});
                              }),
                            ).then((value) => changeState(() {}));
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
                    heightBox(context, 0.02),
                    Expanded(
                      child: widget
                                  .customSnapshot[customIndex]["item"].length ==
                              0
                          ? Center(
                              child: text(context, "No items", 0.04, myBlack))
                          : Scrollbar(
                              interactive: true,
                              showTrackOnHover: true,
                              trackVisibility: true,
                              isAlwaysShown: true,
                              thickness: dynamicWidth(context, 0.01),
                              radius:
                                  Radius.circular(dynamicWidth(context, 0.1)),
                              child: GridView.builder(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: dynamicWidth(context, 0.03)),
                                  itemCount: widget
                                      .customSnapshot[customIndex]["item"]
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
                                          widget.customSnapshot[customIndex]
                                              ["item"],
                                          index, () {
                                        changeState(() {});
                                      })),
                            ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  allMenu(snapshot) {
    return (loading == true)
        ? loader(context)
        : (snapshot == false)
            ? retry(context)
            : menuView(snapshot);
  }

  menuView(snapshot) {
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
                    delegate: CustomSearchDelegateMenu(snapshot, () {
                      changeState(() {});
                    }),
                  ).then((value) => changeState(() {}));
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
          heightBox(context, 0.02),
          Expanded(
            child: snapshot.length == 0
                ? Center(child: text(context, "No items", 0.04, myBlack))
                : Scrollbar(
                    interactive: true,
                    showTrackOnHover: true,
                    trackVisibility: true,
                    isAlwaysShown: true,
                    thickness: dynamicWidth(context, 0.01),
                    radius: Radius.circular(dynamicWidth(context, 0.1)),
                    child: GridView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: dynamicWidth(context, 0.03)),
                        itemCount: snapshot.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: dynamicWidth(context, 0.4) /
                                dynamicWidth(context, 0.5),
                            mainAxisSpacing: dynamicWidth(context, 0.02),
                            crossAxisSpacing: dynamicWidth(context, 0.02)),
                        itemBuilder: (context, index) =>
                            menuCards(context, snapshot, index, () {
                              changeState(() {});
                            })),
                  ),
          ),
        ],
      );
    });
  }
}
