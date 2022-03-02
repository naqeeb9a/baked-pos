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

punchOrder(total, cost, paymentType,
    {customerName = "", customerPhone = ""}) async {
  var filteredItems = [];

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
        "productimg": item["photo"],
      });
    }
    return filteredItems;
  }

  discountFunction() {
    dynamic discount = 0;

    for (var item in cartItems) {
      var temp = 0;
      temp = int.parse(item['sale_price'].toString()) -
          int.parse(item['discounted_price'].toString());

      var temp2 = 0;

      temp2 = temp * int.parse(item['qty'].toString());

      discount += temp2;
    }
    return discount;
  }

  totalPriceFunction() {
    int total = 0;
    for (var item in cartItems) {
      total += (int.parse(item['sale_price'].toString()) *
          int.parse(item['qty'].toString()));
    }
    return total;
  }

  dynamic bodyJson = {
    "outlet_id": "${userResponse["outlet_id"]}",
    "total_items": "${cartItems.length}",
    "sub_total": "${totalPriceFunction()}",
    "total_payable": paymentType == "Cash"
        ? "${(int.parse(totalPriceFunction().toString()) - int.parse(discountFunction().toString())) + ((int.parse(total.toString())) * .16)}"
        : "${(int.parse(totalPriceFunction().toString()) - int.parse(discountFunction().toString())) + ((int.parse(total.toString())) * .05)}",
    "payment_method_id": paymentType == "Cash" ? "7" : "4",
    "total_cost": "$cost",
    "tax_amount": paymentType == "Cash"
        ? "${((int.parse(total.toString())) * .16)}"
        : "${((int.parse(total.toString())) * .05)}",
    "total_discount": "${discountFunction()}",
    "cart": filterFunction(),
    "table_no": "",
    "saleid": "",
    "billing_name": "$customerName",
    "billing_phone": "$customerPhone"
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
      return jsonData["data"]["sale_no"];
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

registerHandling(type, {balance}) async {
  dynamic openingBody = {
    "user_id": "${userResponse["id"]}",
    "opening_balance": "$balance",
    "type": "$type",
  };

  dynamic closingBody = {
    "user_id": "${userResponse["id"]}",
    "type": "$type",
  };

  try {
    var response = await http.post(
      Uri.parse(callBackUrl + "/api/register"),
      body:
          type == "close" ? json.encode(closingBody) : json.encode(openingBody),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 10), onTimeout: () {
      return http.Response('Error', 408);
    });
    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return jsonData["data"]["message"];
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
