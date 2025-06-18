import 'dart:developer';

import '../config.dart';
import 'package:shared_preferences/shared_preferences.dart';

// URLs
String apiUrl = "YOUR API URL";
String paymentUrl = "YOUR PAYMENT URL";

String playstoreUrl = "YOUR PLAYSTORE URL";

late SharedPreferences sharedPreferences;
String local = appSettingModel!.general!.defaultLanguage!.locale!;

// Initialize SharedPreferences and Locale
Future<void> initializeAppSettings() async {
  sharedPreferences = await SharedPreferences.getInstance();
  local = sharedPreferences.getString('selectedLocale') ?? "en";
  log("set language:: $local");
}

// Headers Token Function
Map<String, String>? headersToken(String? token) => {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Accept-Lang": local,
      "Authorization": "Bearer $token",
    };

// Default Headers
Map<String, String>? get headers => {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Accept-Lang": local,
    };
