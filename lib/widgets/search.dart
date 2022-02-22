import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:flutter/material.dart';

import 'menu_cards.dart';

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
        : Scrollbar(
            interactive: true,
            showTrackOnHover: true,
            trackVisibility: true,
            isAlwaysShown: true,
            thickness: dynamicWidth(context, 0.01),
            radius: Radius.circular(dynamicWidth(context, 0.1)),
            child: Padding(
              padding: EdgeInsets.all(dynamicWidth(context, 0.05)),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio:
                      dynamicWidth(context, 0.5) / dynamicWidth(context, 0.6),
                ),
                itemCount: matchQuery.length,
                itemBuilder: (BuildContext context, int index) {
                  return menuCards(context, matchQuery, index);
                },
              ),
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
        : Scrollbar(
            interactive: true,
            showTrackOnHover: true,
            trackVisibility: true,
            isAlwaysShown: true,
            thickness: dynamicWidth(context, 0.01),
            radius: Radius.circular(dynamicWidth(context, 0.1)),
            child: Padding(
              padding: EdgeInsets.all(dynamicWidth(context, 0.05)),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio:
                      dynamicWidth(context, 0.5) / dynamicWidth(context, 0.6),
                ),
                itemCount: matchQuery.length,
                itemBuilder: (BuildContext context, int index) {
                  return menuCards(context, matchQuery, index);
                },
              ),
            ),
          ); // ListTile
  }
}
