import 'dart:convert';

import 'package:baked_pos/utils/app_routes.dart';
import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/buttons.dart';
import 'package:baked_pos/widgets/form_fields.dart';
import 'package:baked_pos/widgets/text_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../widgets/essential_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhite,
      body: (loading == true)
          ? Center(
              child: loader(context),
            )
          : Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: dynamicWidth(context, 0.05)),
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        color: myBlack,
                        width: dynamicWidth(context, 0.3),
                      ),
                      text(
                        context,
                        "TEAM LOGIN",
                        .08,
                        myYellow,
                        bold: true,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text(context, "Email", .05, myBrown),
                          heightBox(context, .01),
                          inputTextField(
                            context,
                            "Email",
                            email,
                          ),
                          heightBox(context, .02),
                          text(context, "Password", .05, myBrown),
                          heightBox(context, .01),
                          inputTextField(
                            context,
                            "Password",
                            password,
                            password: true,
                            function2: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                          ),
                        ],
                      ),
                      coloredButton(context, "SIGN IN", myYellow, function: () {
                        signInLogic();
                      }),
                      heightBox(context, .04),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  signInLogic() async {
    if (!EmailValidator.validate(email.text)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: myRed,
          duration: const Duration(seconds: 2),
          content: text(context, "Enter a valid Email", 0.04, myWhite)));
    } else if (password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: myRed,
          duration: const Duration(seconds: 2),
          content: text(context, "Enter a Valid password", 0.04, myWhite)));
    } else {
      var response = await loginFunction();

      if (response == "Error") {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: myRed,
            duration: const Duration(seconds: 2),
            content: text(context, "Invalid credientials", 0.04, myWhite)));
      } else if (response == false) {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: myRed,
            duration: const Duration(seconds: 2),
            content: text(context, "Check Your Internet", 0.04, myWhite)));
      } else {
        SharedPreferences loginUser = await SharedPreferences.getInstance();
        loginUser.setString(
          "userResponse",
          json.encode(response),
        );
        setState(() {
          pageDecider = "home";
        });
        pushAndRemoveUntil(
          context,
          const MyApp(),
        );
      }
    }
  }

  loginFunction() async {
    try {
      setState(() {
        loading = true;
      });
      var response = await http.post(
          Uri.parse(callBackUrl + "/api/signin-waiter"),
          body: {"email": email.text, "password": password.text});
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        return jsonData["data"];
      } else {
        return "Error";
      }
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
