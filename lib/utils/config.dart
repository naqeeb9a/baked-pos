import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

const myWhite = Color(0xfff9f9f9);
const myGrey = Colors.grey;
const myBrown = Color(0xff684f40);
const myBlack = Color(0xff000000);
const myYellow = Color(0xfffdb821);
const myGreen = Color(0xFF008000);
const myRed = Color(0xFFff0000);
const noColor = Colors.transparent;

bool obscureText = true;
var pageDecider = "home";
dynamic hintText = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
dynamic customContext = "";
dynamic globalRefresh = "";
dynamic saleIdGlobal = "";
dynamic tableNoGlobal = "";
dynamic tableNameGlobal;
dynamic globalDineInContext;
dynamic globalDineInRefresh;
dynamic userResponse = "";
dynamic menuRefresh;
dynamic drawerRefresh;
var indexPage = 0;
var cartItems = [].obs;
var reservedTable = [];
var callBackUrl = "https://baked.pk";
var callBackUrl1 = "https://pos.baked.pk";
var version = "0.1.0";

dynamic registerResponse = "";
