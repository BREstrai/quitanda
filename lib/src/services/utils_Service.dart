import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class UtilsServices {
  final storage = const FlutterSecureStorage();

  Future<void> saveLocalData(
      {required String key, required String data}) async {
    await storage.write(key: key, value: data);
  }

  Future<String?> getLocalData({required String key}) async {
    return await storage.read(key: key);
  }

  Future<void> removeLocalData({required String key}) async {
    await storage.delete(key: key);
  }

  priceToCurrency(double price) {
    NumberFormat numberFormat = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return numberFormat.format(price);
  }

  String formatDateTime(DateTime dateTime) {
    initializeDateFormatting();

    DateFormat dateFormat = DateFormat.yMd('pt_BR').add_Hm();
    return dateFormat.format(dateTime);
  }

  void showToasts({
    required String descricao,
    bool isError = false,
  }) {
    Fluttertoast.showToast(
      msg: descricao,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: isError ? Colors.red : Colors.white,
      textColor: isError ? Colors.white : Colors.black,
      fontSize: 16.0,
    );
  }

  Uint8List decodeQrCodeImage(String value) {
    String base64String = value.split(',').last;

    return base64.decode(base64String);
  }
}
