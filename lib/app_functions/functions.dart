import 'dart:convert';


import 'package:baked_pos/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

getReservationData(query) async {
  var url = "$callBackUrl/api/$query/${userResponse['outlet_id']}";
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
      return jsonData["data"]["result"];
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

getDineInOrders(query, alertCheck) async {
  var url = "";
  if (alertCheck == true) {
    url = "$callBackUrl/api/$query/${userResponse['outlet_id']}/0";
  } else if (userResponse["designation"].toString().toLowerCase() ==
      "Floor Manager".toLowerCase()) {
    url = "$callBackUrl/api/$query/${userResponse['outlet_id']}/0";
  } else if (userResponse["designation"].toString().toLowerCase() ==
      "Waiter".toLowerCase()) {
    url =
        "$callBackUrl/api/$query/${userResponse['outlet_id']}/${userResponse["id"]}";
  } else {
    url = "$callBackUrl/api/$query/${userResponse['outlet_id']}";
  }
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
      return jsonData["data"]["result"];
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

searchReservation(date, reservationNumber) async {
  try {
    var response =
        await http.post(Uri.parse(callBackUrl + "/api/get-reservation"),
            body: json.encode({
              "reservation": "$reservationNumber",
              "filter_date": "$date",
              "outlet_id": userResponse["outlet_id"],
            }),
            headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        }).timeout(const Duration(seconds: 10), onTimeout: () {
      return http.Response('Error', 408);
    });
    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return jsonData["data"]["result"];
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

getOrderSummary(id) async {
  try {
    var response = await http
        .get(Uri.parse(callBackUrl + "/api/order-summary/$id"))
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

getTables(saleID) async {
  try {
    var response = await http
        .get(Uri.parse(callBackUrl + "/api/booking-details/$saleID"))
        .timeout(const Duration(seconds: 10), onTimeout: () {
      return http.Response('Error', 408);
    });
    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return jsonData["data"][0]["tables"];
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

getWaiters(saleID) async {
  try {
    var response = await http
        .get(Uri.parse(callBackUrl + "/api/booking-details/$saleID"))
        .timeout(const Duration(seconds: 10), onTimeout: () {
      return http.Response('Error', 408);
    });
    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return jsonData["data"][0]["waiters"];
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

arrivedGuests(id) async {
  try {
    var response = await http
        .get(Uri.parse(callBackUrl + "/api/guest-arrived/$id"))
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

reserveTable(name, phone, email, seats, date, dropDownTime) async {
  try {
    var response = await http.post(Uri.parse(callBackUrl + "/api/reserve"),
        body: json.encode({
          "name": "$name",
          "phone": "$phone",
          "email": "$email",
          "seats": "$seats",
          "date": "$date",
          "timedropdown": "$dropDownTime",
          "outlet_id": userResponse["outlet_id"],
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        }).timeout(const Duration(seconds: 10), onTimeout: () {
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

getTimeSlots(date) async {
  try {
    SharedPreferences loginUser = await SharedPreferences.getInstance();
    dynamic temp = loginUser.getString("userResponse");
    userResponse = temp == null ? "" : await json.decode(temp);
    var response = await http.post(Uri.parse(callBackUrl + "/api/get-timeslot"),
        body: json.encode(
            {"outlet_id": userResponse["outlet_id"], "filter_date": date}),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        }).timeout(const Duration(seconds: 10), onTimeout: () {
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

assignTableOnline(saleId, tableId) async {
  try {
    var response = await http.post(Uri.parse(callBackUrl + "/api/assign-table"),
        body: json.encode({"sale_id": saleId, "table_id": tableId}),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        }).timeout(const Duration(seconds: 10), onTimeout: () {
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

assignWaiterOnline(saleId, waiterId) async {
  try {
    var response = await http.post(
        Uri.parse(callBackUrl + "/api/assign-waiter"),
        body: json.encode({"saleid": saleId, "waiters": waiterId}),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        }).timeout(const Duration(seconds: 10), onTimeout: () {
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

punchOrder(total, cost) async {
  var filteredItems = [];
  filterFunction() {
    for (var item in cartItems) {
      filteredItems.add({
        "productid": item["id"],
        "productname": item["name"],
        "productcode": item["code"],
        "productprice": item["sale_price"],
        "itemUnitCost": item["cost"] ?? "0",
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
    "table_no": "$tableNoGlobal",
    "saleid": "$saleIdGlobal"
  };
  try {
    var response = await http.post(
      Uri.parse(callBackUrl + "/api/booking-punch-order"),
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

checkAvailability(date, timeDropdown, seats) async {
  try {
    var response = await http.post(Uri.parse(callBackUrl + "/api/get-avail"),
        body: json.encode({
          "outlet_id": "${userResponse["outlet_id"]}",
          "filter_date": "$date",
          "timedropdown": "$timeDropdown",
          "seats": "$seats"
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        }).timeout(const Duration(seconds: 10), onTimeout: () {
      return http.Response('Error', 408);
    });
    var jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return jsonData["data"];
    } else {
      return "internet";
    }
  } catch (e) {
    return "server";
  }
}
