import 'dart:convert';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:baked_pos/utils/config.dart';
import 'package:baked_pos/utils/dynamic_sizes.dart';
import 'package:baked_pos/widgets/essential_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_screens/basic_page.dart';
import 'app_screens/login.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await LocalNotificationsService.instance.initialize();
  // final adService = AdService(MobileAds.instance);
  //
  // GetIt.instance.registerSingleton<AdService>(adService);
  //
  // await adService.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  late AnimationController _controller;

  startAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
  }

  late Animation<double> _animation;

  checkCallBackUrl() async {
    SharedPreferences callBackUrlStored = await SharedPreferences.getInstance();
    if (callBackUrlStored.getString("SavedUrl") != null) {
      callBackUrl = callBackUrlStored.getString("SavedUrl")!;
    }
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    _controller.dispose();
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }

  bool loader = false;
  final MaterialColor primaryColor = const MaterialColor(
    0xff000000,
    <int, Color>{
      50: Color(0xff000000),
      100: Color(0xff000000),
      200: Color(0xff000000),
      300: Color(0xff000000),
      400: Color(0xff000000),
      500: Color(0xff000000),
      600: Color(0xff000000),
      700: Color(0xff000000),
      800: Color(0xff000000),
      900: Color(0xff000000),
    },
  );

  @override
  Widget build(BuildContext context) {
    globalRefresh = () {
      setState(() {});
    };
    startAnimation();
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primaryColor,
        textTheme: GoogleFonts.sourceSansProTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: MaterialApp(
        title: 'Baked POS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: primaryColor,
          textTheme: GoogleFonts.sourceSansProTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        builder: (context, child) {
          return StatefulBuilder(builder: (context, changeState) {
            drawerRefresh = () {
              changeState(() {});
            };
            checkLoginStatus(context);
            return loader == true
                ? Scaffold(
                    backgroundColor: myWhite,
                    body: Center(
                      child: Image.asset(
                        "assets/loader.gif",
                        width: dynamicWidth(context, 0.3),
                      ),
                    ),
                  )
                : Scaffold(
                    backgroundColor: myWhite,
                    drawerEnableOpenDragGesture: false,
                    endDrawerEnableOpenDragGesture: false,
                    key: _scaffoldKey,
                    appBar: bar(context, function: () {
                      _scaffoldKey.currentState!.openDrawer();
                    }, function1: () {
                      _scaffoldKey.currentState!.openEndDrawer();
                    }),
                    body: child,
                  );
          });
        },
        home: Scaffold(
          backgroundColor: myWhite,
          body: FadeTransition(
            opacity: _animation,
            child: const BasicPage(),
          ),
        ),
      ),
    );
  }
}

checkLoginStatus(context1) async {
  SharedPreferences loginUser = await SharedPreferences.getInstance();
  dynamic temp = loginUser.getString("userResponse");
  userResponse = temp == null ? "" : await json.decode(temp);

  if (temp == null) {
    Navigator.pushAndRemoveUntil(
        context1,
        MaterialPageRoute(
          builder: (context1) => const LoginScreen(),
        ),
        (route) => false);
  } else {
    drawerRefresh();
  }
}
