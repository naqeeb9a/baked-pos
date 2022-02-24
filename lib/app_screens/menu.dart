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
  const MenuPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: myWhite,
      body: Container(
        height: double.maxFinite,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/menu_bg.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                heightBox(context, 0.02),
                text(context, "Choose Category", 0.07, myBlack, bold: true),
                heightBox(context, 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: dynamicWidth(context, 0.05),
                  ),
                  child: FutureBuilder(
                    future: getMenuCategories(),
                    builder: ((context, AsyncSnapshot snapshot) =>
                        errorHandlingWidget(snapshot)),
                  ),
                ),
                heightBox(context, 0.02),
              ],
            ),
          ),
        ),
      ),
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
    snapshot.insert(0, {"category_name": "All Items"});

    return Center(
      child: Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: dynamicWidth(context, 0.02),
          runSpacing: dynamicWidth(context, 0.02),
          children: snapshot
              .map<Widget>(
                (item) => GestureDetector(
                  onTap: () {
                    if (item["category_name"] == "All Items") {
                      push(
                        context,
                        const MenuExtension(
                          customSnapshot: "menu",
                          check: true,
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MenuExtension(customSnapshot: item["child"]),
                        ),
                      ).then((value) => () {
                            setState(() {});
                          });
                    }
                  },
                  child: CircleAvatar(
                    radius: dynamicWidth(context, 0.16),
                    backgroundColor: myYellow,
                    backgroundImage: AssetImage(
                      item["image"] ?? "assets/cat_image.png",
                    ),
                    child: CircleAvatar(
                      backgroundColor: myBlack.withOpacity(0.6),
                      radius: dynamicWidth(context, 0.15),
                      child: FittedBox(
                        child: SizedBox(
                          width: dynamicWidth(context, 0.3),
                          child: text(
                              context, item["category_name"], 0.05, myWhite,
                              bold: true, alignText: TextAlign.center),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList()),
    );
  }
}
