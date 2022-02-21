import 'package:baked_pos/app_functions/functions.dart';
import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/buttons.dart';
import 'package:baked_pos/widgets/essential_widgets.dart';
import 'package:baked_pos/widgets/menu_cards.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class MenuExtension extends StatelessWidget {
  final dynamic snapshot;
  const MenuExtension({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: dynamicWidth(context, 0.02)),
      child: snapshot == "menu"
          ? FutureBuilder(
              future: getMenu(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == false) {
                    return retry(context);
                  } else if (snapshot.data.length == 0) {
                    return text(context, "No items in List", 0.03, myBlack);
                  } else {
                    return GridView.builder(
                        itemCount: snapshot.data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: dynamicWidth(context, 0.4) /
                                dynamicWidth(context, 0.5),
                            mainAxisSpacing: dynamicWidth(context, 0.02),
                            crossAxisSpacing: dynamicWidth(context, 0.02)),
                        itemBuilder: (context, index) =>
                            menuCards(context, snapshot.data, index));
                  }
                } else {
                  return loader(context);
                }
              })
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.length,
              itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: dynamicWidth(context, 0.02)),
                    child: ChoiceChip(
                        selectedColor: myYellow,
                        label: text(context, snapshot[index]["category_name"],
                            0.04, myBlack),
                        selected: true),
                  )),
    ));
  }
}
