import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/menu_cards.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:flutter/material.dart';

import 'Search.dart';

customExpansionTile(context, subCategory, snapshot, setState) {
  return ExpansionTile(
    title: Text(
      subCategory['category_name'],
      style: TextStyle(
        color: myBrown,
        fontSize: dynamicWidth(context, .046),
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
            delegate: CustomSearchDelegate(snapshot.data),
          ).then(
            (value) => setState(() {}),
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
              border: const UnderlineInputBorder(borderSide: BorderSide.none),
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
      heightBox(context, 0.02),
      SizedBox(
          height: dynamicHeight(context, .5),
          child: (subCategory['item'] == null)
              ? text(context, "no items", 0.04, myBlack)
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio:
                        dynamicWidth(context, 0.5) / dynamicWidth(context, 0.6),
                  ),
                  itemCount: subCategory['item'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return menuCards(
                      context,
                      subCategory['item'],
                      index,
                    );
                  },
                )),
    ],
  );
}
