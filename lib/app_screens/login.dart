import 'dart:convert';
import 'dart:ui';

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
      body: SafeArea(
        child: Container(
          height: dynamicHeight(context, 1),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: const AssetImage("assets/login_background.png"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      myBlack.withOpacity(0.2), BlendMode.darken))),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: dynamicWidth(context, 0.05)),
              child: Form(
                key: _formKey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        heightBox(context, .04),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: myWhite.withOpacity(0.2),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            border: Border.all(
                              width: 1.5,
                              color: myWhite.withOpacity(0.2),
                            ),
                          ),
                          child: Image.asset(
                            "assets/logo.png",
                            color: myBlack,
                            width: dynamicWidth(context, 0.3),
                          ),
                        ),
                        heightBox(context, .04),
                        text(
                          context,
                          "TEAM LOGIN",
                          .08,
                          myYellow,
                          bold: true,
                        ),
                        heightBox(context, .04),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: myWhite.withOpacity(0.2),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              border: Border.all(
                                  width: 1.5, color: myWhite.withOpacity(0.2))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(context, "Email", .05, myWhite),
                              heightBox(context, .01),
                              inputTextField(context, email, enabled: loading),
                              heightBox(context, .02),
                              text(context, "Password", .05, myWhite),
                              heightBox(context, .01),
                              inputTextField(
                                context,
                                password,
                                password: true,
                                enabled: loading,
                                function2: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        heightBox(context, .1),
                        (loading == true)
                            ? loginLoader(context)
                            : coloredButton(context, "Sign in", myYellow,
                                width: dynamicWidth(context, 0.3),
                                function: () {
                                signInLogic();
                              }),
                        heightBox(context, .04),
                      ],
                    ),
                  ),
                ),
              ),
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
