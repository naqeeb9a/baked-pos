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
    var response = await http.post(Uri.parse(callBackUrl + "/api/searchmenu"),
        body:
            json.encode({"outletid": userResponse["outlet_id"], "term": "all"}),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        }).timeout(const Duration(seconds: 10), onTimeout: () {
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
  filterFunction() {
    for (var item in cartItems) {
      filteredItems.add({
        "productid": item["id"],
        "productname": item["name"],
        "productcode": item["code"],
        "productprice": item["sale_price"],
        "itemUnitCost": item["cost"] == "" ? "0" : item["cost"],
        "productqty": item["qty"],
        "productimg": item["photo"]
      });
    }
    return filteredItems;
  }

  dynamic bodyJson = {
    "outlet_id": "${userResponse["outlet_id"]}",
    "total_items": "${cartItems.length}",
    "sub_total": "$total",
    "total_payable": "$total",
    "total_cost": "$cost",
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
      return jsonData["data"];
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
