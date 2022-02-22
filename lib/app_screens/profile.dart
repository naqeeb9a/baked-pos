import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhite,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: dynamicHeight(context, .1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: dynamicWidth(context, .12),
                  backgroundColor: myGrey.withOpacity(0.3),
                  child: Center(
                    child: LineIcon(
                      LineIcons.user,
                      color: myBlack,
                      size: dynamicHeight(context, .08),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text(
                      context,
                      userResponse['full_name'].toString().toUpperCase(),
                      .06,
                      myYellow,
                      bold: true,
                    ),
                    heightBox(context, .01),
                    text(
                      context,
                      userResponse['designation'],
                      .04,
                      myBlack,
                    ),
                    heightBox(context, .01),
                    text(
                      context,
                      userResponse['phone'],
                      .04,
                      myBlack,
                    ),
                    heightBox(context, .01),
                    text(
                      context,
                      userResponse['email_address'],
                      .04,
                      myBlack,
                    ),
                  ],
                )
              ],
            ),
          ),
          const Divider(
            color: myBlack,
          ),
          heightBox(context, .1),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: dynamicWidth(context, 0.02),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                dynamicWidth(context, 0.02),
              ),
              child: Column(
                children: [
                  profileRow(
                    context,
                    Icons.logout_rounded,
                    "Log Out",
                    function: () async {
                      SharedPreferences loginUser =
                          await SharedPreferences.getInstance();
                      loginUser.clear();
                      userResponse = "";
                      indexPage = 0;
                      checkLoginStatus(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: dynamicHeight(context, .02),
            ),
            child: text(
              context,
              "Version: $version",
              .034,
              myBlack,
              alignText: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

Widget profileRow(context, icon, title, {function = ""}) {
  return InkWell(
    onTap: function == "" ? () {} : function,
    child: Container(
      width: dynamicWidth(context, .86),
      padding: EdgeInsets.symmetric(
        vertical: dynamicWidth(context, 0.02),
        horizontal: dynamicWidth(context, 0.02),
      ),
      color: myGrey.withOpacity(0.3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            LineIcon(
              icon,
              color: myBlack,
              size: dynamicHeight(context, .04),
            ),
            widthBox(context, .04),
            text(
              context,
              title,
              .044,
              myBlack,
              bold: true,
            ),
          ]),
          LineIcon(
            Icons.arrow_forward_ios,
            color: myBlack,
          )
        ],
      ),
    ),
  );
}
