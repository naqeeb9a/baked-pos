import 'package:baked_pos/app_functions/functions.dart';
import 'package:baked_pos/app_screens/inventory.dart';
import 'package:baked_pos/utils/app_routes.dart';
import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final registerBalance = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhite,
      body: OKToast(
        child: Column(
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
            userResponse['designation'].toString().toLowerCase() == "coffee"
                ? heightBox(context, .02)
                : heightBox(context, .1),
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
                    userResponse['designation'].toString().toLowerCase() ==
                            "coffee"
                        ? profileRow(
                            context,
                            Icons.mobile_friendly_rounded,
                            "Start Shift",
                            function: () async {
                              showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return AlertDialog(
                                    title: const Text("Enter Opening Balance"),
                                    content: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .2,
                                      width: MediaQuery.of(context).size.width *
                                          .7,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextFormField(
                                            controller: registerBalance,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              hintText: "Example : 2000",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                              var apiResult =
                                                  await startRegister(
                                                registerBalance.text,
                                                "open",
                                              );

                                              if (apiResult.toString() ==
                                                  "true") {
                                                showToast(
                                                  'Shift started Successfully',
                                                  position:
                                                      ToastPosition.center,
                                                  backgroundColor: myBrown,
                                                  radius: dynamicWidth(
                                                      context, .01),
                                                  textStyle: TextStyle(
                                                    color: myWhite,
                                                    fontSize: dynamicWidth(
                                                        context, .05),
                                                  ),
                                                );
                                                // ScaffoldMessenger.of(
                                                //         dialogContext)
                                                //     .showSnackBar(
                                                //   SnackBar(
                                                //     backgroundColor: myRed,
                                                //     duration: const Duration(
                                                //         seconds: 2),
                                                //     content: text(
                                                //       context,
                                                //       "Shift started Successfully",
                                                //       0.04,
                                                //       myWhite,
                                                //     ),
                                                //   ),
                                                // );
                                              } else {
                                                ScaffoldMessenger.of(
                                                        dialogContext)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor: myRed,
                                                    duration: const Duration(
                                                        seconds: 2),
                                                    content: text(
                                                      context,
                                                      "Something went wrong!!",
                                                      0.04,
                                                      myWhite,
                                                    ),
                                                  ),
                                                );
                                              }
                                              registerBalance.clear();
                                            },
                                            child: text(
                                              context,
                                              "Start",
                                              .04,
                                              myWhite,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : Container(),
                    userResponse['designation'].toString().toLowerCase() ==
                            "coffee"
                        ? profileRow(
                            context,
                            Icons.send_to_mobile,
                            "Change Shift",
                            function: () async {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Enter Opening Balance"),
                                    content: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .2,
                                      width: MediaQuery.of(context).size.width *
                                          .7,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextFormField(
                                            controller: registerBalance,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              hintText: "Example : 2000",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              var apiResult =
                                                  await startRegister(
                                                registerBalance.text,
                                                "close",
                                              );

                                              if (apiResult.toString() ==
                                                  "true") {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor: myRed,
                                                    duration: const Duration(
                                                        seconds: 2),
                                                    content: text(
                                                      context,
                                                      "Shift started Successfully",
                                                      0.04,
                                                      myWhite,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor: myRed,
                                                    duration: const Duration(
                                                        seconds: 2),
                                                    content: text(
                                                      context,
                                                      "Something went wrong!!",
                                                      0.04,
                                                      myWhite,
                                                    ),
                                                  ),
                                                );
                                              }
                                              registerBalance.clear();
                                            },
                                            child: text(
                                              context,
                                              "End",
                                              .04,
                                              myWhite,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : Container(),
                    userResponse['designation'].toString().toLowerCase() ==
                            "coffee"
                        ? profileRow(
                            context,
                            Icons.inventory_2_rounded,
                            "Day End",
                            function: () {
                              push(
                                context,
                                const Inventory(),
                              );
                              //   showDialog(
                              //     context: context,
                              //     barrierDismissible: true,
                              //     builder: (BuildContext dialogContext) {
                              //       return AlertDialog(
                              //         title:
                              //             const Text("Update Inventory"),
                              //         content: SizedBox(
                              //           height:
                              //               MediaQuery.of(context).size.width * 0.9,
                              //           width:
                              //               MediaQuery.of(context).size.width * 0.7,
                              //           child: Column(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.spaceEvenly,
                              //             children: [
                              //               LottieBuilder.asset(
                              //                 "assets/inventory.json",
                              //                 width: dynamicWidth(context, 0.3),
                              //               ),
                              //               TextFormField(
                              //                 controller: TextEditingController(),
                              //                 decoration: InputDecoration(
                              //                   hintText: "Example : Joe",
                              //                   border: OutlineInputBorder(
                              //                     borderRadius:
                              //                         BorderRadius.circular(5.0),
                              //                   ),
                              //                 ),
                              //               ),
                              //               TextFormField(
                              //                 controller: TextEditingController(),
                              //                 decoration: InputDecoration(
                              //                   hintText: "Example : 0300xxxxxxx",
                              //                   border: OutlineInputBorder(
                              //                     borderRadius:
                              //                         BorderRadius.circular(5.0),
                              //                   ),
                              //                 ),
                              //               ),
                              //               ElevatedButton(
                              //                 onPressed: () {
                              //                   Navigator.of(context,
                              //                           rootNavigator: true)
                              //                       .pop();
                              //                 },
                              //                 child: const Text("Done"),
                              //               )
                              //             ],
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //   );
                            },
                          )
                        : Container(),
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
      ),
    );
  }
}

Widget profileRow(context, icon, title, {function = ""}) {
  return InkWell(
    onTap: function == "" ? () {} : function,
    child: Padding(
      padding: EdgeInsets.symmetric(
        vertical: dynamicWidth(context, 0.02),
      ),
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
    ),
  );
}
