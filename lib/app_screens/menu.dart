import 'package:baked_pos/app_functions/functions.dart';
import 'package:baked_pos/app_screens/menu_extension.dart';
import 'package:baked_pos/utils/app_routes.dart';
import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/buttons.dart';
import 'package:baked_pos/widgets/essential_widgets.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:flutter/material.dart';

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
      resizeToAvoidBottomInset: false,
      backgroundColor: myWhite,
      body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: dynamicWidth(context, 0.05)),
          child: FutureBuilder<List>(
            future: Future.wait([getMenu(), getMenuCategories()]),
            builder: ((context, AsyncSnapshot<List> snapshot) =>
                errorHandlingWidget(snapshot)),
          )),
    );
  }

  errorHandlingWidget(AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.data == false) {
        return retry(context);
      } else if (snapshot.data.length == 0) {
        return text(context, "No items in List", 0.03, myBlack);
      } else {
        return selectionCards(snapshot.data);
      }
    } else {
      return loader(context);
    }
  }

  selectionCards(snapshot) {
    snapshot[1].insert(0, {"category_name": "All Items"});
    return Center(
      child: Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: dynamicWidth(context, 0.02),
          runSpacing: dynamicWidth(context, 0.02),
          children: snapshot[1]
              .map<Widget>(
                (item) => GestureDetector(
                  onTap: () {
                    if (item["category_name"] == "All Items") {
                      push(
                          context,
                          MenuExtension(
                            customSnapshot: snapshot[0],
                            check: true,
                          ));
                    } else {
                      push(context,
                          MenuExtension(customSnapshot: item["child"]));
                    }
                  },
                  child: CircleAvatar(
                    radius: dynamicWidth(context, 0.16),
                    backgroundColor: myYellow,
                    child: CircleAvatar(
                      backgroundColor: myBrown,
                      radius: dynamicWidth(context, 0.15),
                      child:
                          text(context, item["category_name"], 0.04, myWhite),
                    ),
                  ),
                ),
              )
              .toList()),
    );
  }
}

Widget choiceTag(context, title) {
  return Expanded(
    child: Container(
      height: dynamicHeight(context, .06),
      decoration: BoxDecoration(
        color: myYellow,
        borderRadius: BorderRadius.circular(100),
      ),
      padding: EdgeInsets.all(
        dynamicWidth(context, .016),
      ),
      child: Center(
        child: text(context, title, .04, myWhite),
      ),
    ),
  );
}
