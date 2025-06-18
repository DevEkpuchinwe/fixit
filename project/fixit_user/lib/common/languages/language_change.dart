import 'dart:convert';
import 'dart:developer';
import 'package:fixit_user/common/languages/language_helper.dart';
import 'package:fixit_user/config.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../models/system_language_model.dart';
import '../../models/translation_model.dart';

class LanguageProvider with ChangeNotifier {
  String currentLanguage = '';
  Locale? locale;
  int selectedIndex = 0;
  List<SystemLanguage> languageList = [];
  final SharedPreferences sharedPreferences;
  LanguageProvider(this.sharedPreferences) {
    var selectedLocale = sharedPreferences.getString("selectedLocale");

    if (selectedLocale != null) {
      locale = Locale(selectedLocale);
    } else {
      selectedLocale = "english";
      locale = const Locale("en");
    }

    setVal(selectedLocale);
    getLanguage();
    getLanguageTranslate();
  }
  getLanguage() async {
    try {
      translations = Translation.defaultTranslations();
      await apiServices
          .getApi(api.systemLanguage, [], isToken: false)
          .then((value) {
        if (value.isSuccess!) {
          log("VALue :%${value.data}");
          for (var item in value.data) {
            SystemLanguage systemLanguage = SystemLanguage.fromJson(item);
            if (!languageList.contains(systemLanguage)) {
              languageList.add(systemLanguage);
            }
          }
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint("EEEE NOTI getBookingDetailById $e");
    }
  }

  LanguageHelper languageHelper = LanguageHelper();

  void changeLocale(SystemLanguage newLocale) {
    // log("sharedPreferences a1: ${newLocale}");
    Locale convertedLocale;

    currentLanguage = newLocale.name!;
    convertedLocale = Locale(
        newLocale.appLocale!.split("_")[0], newLocale.appLocale!.split("_")[1]);

    locale = convertedLocale;
    sharedPreferences.setString(
        'selectedLocale', locale!.languageCode.toString());
    getLanguageTranslate();

    notifyListeners();
    // loadTranslations(locale!.languageCode);
  }

  getLocal() {
    var selectedLocale = sharedPreferences.getString("selectedLocale");
    return selectedLocale;
  }

  //translateText api
  getLanguageTranslate() async {
    try {
      translations = Translation.defaultTranslations();
      final response = await apiServices.getApi(
          "${api.translate}/${locale!.languageCode}", [],
          isToken: false, isData: true);

      if (response.isSuccess!) {
        translations =
            Translation.fromJson(response.data); // Directly pass the map
        log("Loaded translations: ${translations!.skip}");
        notifyListeners();
      } else {
        log('Failed to load translations, using defaults');
        translations = Translation.defaultTranslations();
      }
    } catch (e) {
      log('Error Translation: $e');
      translations = Translation.defaultTranslations();
    } finally {
      notifyListeners();
    }
  }

  defineCurrentLanguage(context) {
    String? definedCurrentLanguage;
    if (currentLanguage.isNotEmpty) {
      log("definedCurrentLanguage:::$definedCurrentLanguage");
      definedCurrentLanguage = currentLanguage;
    } else {
      log("locale from currentData: ${Localizations.localeOf(context).toString()}");
      definedCurrentLanguage = languageHelper
          .convertLocaleToLangName(Localizations.localeOf(context).toString());
    }

    return definedCurrentLanguage;
  }

  setVal(value) {
    notifyListeners();
    int index = languageList.indexWhere((element) => element.locale == value);
    if (index >= 0) {
      SystemLanguage systemLanguage = languageList[index];
      changeLocale(systemLanguage);
    }
  }

  setIndex(index) {
    selectedIndex = index;
    sharedPreferences.setInt("index", selectedIndex);
    log("selectedIndex::${selectedIndex}");
    notifyListeners();
  }
}
