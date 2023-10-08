import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/provider/shipping_info.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final ShippingInfo shippingInfo;
  final String paymentMethod;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.shippingInfo,
    required this.paymentMethod,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String token = '';
  String userId = '';

  Orders(this.token, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total,
      ShippingInfo shippingInfo, String paymentMethod) async {
    var url = Uri.parse(
        'https://flutter-shop-app-2ab59-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');
    var timeStamp = DateTime.now();
    try {
      var response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'shippingInfo': {
              'id': shippingInfo.id,
              'fullName': shippingInfo.fullName,
              'address': shippingInfo.address,
              'city': shippingInfo.city,
              'mobileNumber': shippingInfo.mobileNumber,
            },
            'paymentMethod': paymentMethod,
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList(),
          }));
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          shippingInfo: shippingInfo,
          products: cartProducts,
          paymentMethod: paymentMethod,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAndSetOrders() async {
    var url = Uri.parse(
        'https://flutter-shop-app-2ab59-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      if (extractedData.isEmpty) {
        return;
      }
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          shippingInfo: ShippingInfo(
            id: orderData['shippingInfo']['id'],
            fullName: orderData['shippingInfo']['fullName'],
            address: orderData['shippingInfo']['address'],
            city: orderData['shippingInfo']['city'],
            mobileNumber: orderData['shippingInfo']['mobileNumber'],
          ),
          paymentMethod: orderData['paymentMethod'],
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'] as String,
                    title: item['title'] as String,
                    quantity: item['quantity'] as int,
                    price: item['price'] as double,
                  ))
              .toList(),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteOrder(String id) {
    var url = Uri.parse(
        'https://flutter-shop-app-2ab59-default-rtdb.firebaseio.com/orders/$userId/$id.json?auth=$token');
    var existingOrderIndex = _orders.indexWhere((order) => order.id == id);
    var existingOrder = _orders[existingOrderIndex];
    _orders.removeAt(existingOrderIndex);
    notifyListeners();
    return http.delete(url).then((response) {
      if (response.statusCode >= 400) {
        throw Exception('Could not delete product.');
      }
      existingOrder = OrderItem(
        id: '',
        amount: existingOrder.amount,
        shippingInfo: existingOrder.shippingInfo,
        products: existingOrder.products,
        paymentMethod: existingOrder.paymentMethod,
        dateTime: existingOrder.dateTime,
      );
    }).catchError((_) {
      _orders.insert(existingOrderIndex, existingOrder);
      notifyListeners();
    });
  }
}
