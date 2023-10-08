// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShippingInfo {
  final String id;
  late final String fullName;
  late final String address;
  late final String city;
  late final String mobileNumber;

  ShippingInfo({
    required this.id,
    required this.fullName,
    required this.address,
    required this.city,
    required this.mobileNumber,
  });
}

//a provider class to provide this information to the app
class ShippingInfoProvider with ChangeNotifier {
  List<ShippingInfo> _items = [];
  String token = '';
  String userId = '';

  ShippingInfoProvider(this.token, this.userId, this._items);

  List<ShippingInfo> get items {
    return [..._items];
  }

  ShippingInfo findById(String id) {
    return _items.firstWhere((shippingInfo) => shippingInfo.id == id);
  }

  int get itemCount {
    return _items.length;
  }

  Future<void> addShippingInfo(
    String fullName,
    String address,
    String city,
    String mobileNumber,
  ) async {
    var url = Uri.parse(
        'https://flutter-shop-app-2ab59-default-rtdb.firebaseio.com/shippingInfo/$userId.json?auth=$token');

    try {
      var response = await http.post(url,
          body: json.encode({
            'fullName': fullName,
            'address': address,
            'city': city,
            'mobileNumber': mobileNumber,
          }));
      _items.insert(
        0,
        ShippingInfo(
          id: json.decode(response.body)['name'],
          fullName: fullName,
          address: address,
          city: city,
          mobileNumber: mobileNumber,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAndSetShippingInfo() async {
    var url = Uri.parse(
        'https://flutter-shop-app-2ab59-default-rtdb.firebaseio.com/shippingInfo/$userId.json?auth=$token');
    try {
      var response = await http.get(url);
      var extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<ShippingInfo> loadedShippingInfo = [];
      if (extractedData.isEmpty) {
        return;
      }
      extractedData.forEach((shipId, shipData) {
        loadedShippingInfo.add(ShippingInfo(
          id: shipId,
          fullName: shipData['fullName'],
          address: shipData['address'],
          city: shipData['city'],
          mobileNumber: shipData['mobileNumber'],
        ));
      });
      _items = loadedShippingInfo.reversed.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteShippingInfo(String id) async {
    var url = Uri.parse(
        'https://flutter-shop-app-2ab59-default-rtdb.firebaseio.com/shippingInfo/$userId/$id.json?auth=$token');
    var existingShippingInfoIndex =
        _items.indexWhere((shippingInfo) => shippingInfo.id == id);
    var existingShippingInfo = _items[existingShippingInfoIndex];
    _items.removeAt(existingShippingInfoIndex);
    notifyListeners();
    var response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingShippingInfoIndex, existingShippingInfo);
      notifyListeners();
      throw
          // ignore: lines_longer_than_80_chars
          'Could not delete shipping info. Please try again later.';
    }
    existingShippingInfo = ShippingInfo(
      id: '',
      fullName: '',
      address: '',
      city: '',
      mobileNumber: '',
    );
  }

  Future<void> editShippingInfo(
    String id,
    String fullName,
    String address,
    String city,
    String mobileNumber,
  ) async {
    var url = Uri.parse(
        'https://flutter-shop-app-2ab59-default-rtdb.firebaseio.com/shippingInfo/$userId/$id.json?auth=$token');
    var existingShippingInfoIndex =
        _items.indexWhere((shippingInfo) => shippingInfo.id == id);
    if (existingShippingInfoIndex >= 0) {
      var response = await http.patch(url,
          body: json.encode({
            'fullName': fullName,
            'address': address,
            'city': city,
            'mobileNumber': mobileNumber,
          }));
      _items[existingShippingInfoIndex] = ShippingInfo(
        id: id,
        fullName: fullName,
        address: address,
        city: city,
        mobileNumber: mobileNumber,
      );
      notifyListeners();
    } else {
      print('...');
    }
  }
}
