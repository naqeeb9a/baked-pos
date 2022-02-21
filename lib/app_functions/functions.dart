import 'dart:convert';

import 'package:baked_pos/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

getMenuCategories() async {
  var url = "$callBackUrl/api/parentCategories";
  try {
    var response = await http
        .get(
      Uri.parse(url),
    )
        .timeout(const Duration(seconds: 10), onTimeout: () {
      return http.Response('Error', 408);
    });
    var jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return jsonData["data"];
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

getMenu() async {
  try {
    SharedPreferences loginUser = await SharedPreferences.getInstance();
    dynamic temp = loginUser.getString("userResponse");
    userResponse = temp == null ? "" : await json.decode(temp);
    var response = await http
        .get(
      Uri.parse(callBackUrl + "/api/menu/all"),
    )
        .timeout(const Duration(seconds: 10), onTimeout: () {
      return http.Response('Error', 408);
    });
    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      return jsonData["data"];
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

punchOrder(total, cost) async {
  var filteredItems = [];
  dynamic discount = 0;

  filterFunction() {
    for (var item in cartItems) {
      filteredItems.add({
        "productid": item["id"],
        "productname": item["name"],
        "productcode": item["code"],
        "productprice": item["sale_price"],
        "item_discount": (int.parse(item["item_discount"].toString()) / 100) *
            int.parse(item["sale_price"].toString()),
        "itemUnitCost": item["cost"] == "" ? "0" : item["cost"],
        "productqty": item["qty"],
        "productimg": item["photo"]
      });
    }
    return filteredItems;
  }

  discountFunction() {
    for (var item in cartItems) {
      discount += (int.parse(item['sale_price'].toString()) -
          int.parse(item['discounted_price'].toString()));
    }
    return discount;
  }

  dynamic bodyJson = {
    "outlet_id": "${userResponse["outlet_id"]}",
    "total_items": "${cartItems.length}",
    "sub_total": "$total",
    "total_payable": "$total",
    "total_cost": "$cost",
    "total_discount": "${discountFunction()}",
    "cart": filterFunction(),
    "table_no": "",
    "saleid": ""
  };

  try {
    var response = await http.post(
      Uri.parse(callBackUrl + "/api/punch-order"),
      body: json.encode(bodyJson),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 10), onTimeout: () {
      return http.Response('Error', 408);
    });
    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // print("\n\n\n obj12 $discount \n\n");
      //
      // print("\n\n\n obj $bodyJson \n\n");
      //
      // print("\n\n\n obj $cartItems \n\n");

      return jsonData["data"]["sale_no"];
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
