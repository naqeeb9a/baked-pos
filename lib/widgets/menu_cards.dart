import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:flutter/material.dart';

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
                  snapshot["discounted_price"] = snapshot["sale_price"];
                  snapshot["item_discount"] = "0";
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
