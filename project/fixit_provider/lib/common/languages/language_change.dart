import 'dart:developer';

import 'package:fixit_provider/common/languages/ar.dart';
import 'package:fixit_provider/common/languages/language_helper.dart';
import 'package:fixit_provider/model/translation_model.dart';

import '../../config.dart';
import '../../model/system_language_model.dart';

class LanguageProvider with ChangeNotifier {
  LanguageProvider(this.sharedPreferences) {
    getLanguageTranslate();
    var selectedLocale = sharedPreferences.getString("selectedLocale");

    if (selectedLocale != null) {
      locale = Locale(selectedLocale);
    } else {
      // selectedLocale = "english";
      // locale = const Locale("en");
    }

    setVal(selectedLocale);
    getLanguage();
  }

  String currentLanguage = appFonts.english;
  Locale? locale;
  int selectedIndex = 0;
  List<SystemLanguage> languageList = [];
  final SharedPreferences sharedPreferences;
  String? apiLanguage;
  int addSelectedIndex = 0; // Store selected index
  var selectedLocaleService = "en";

  void setSelectedIndex(int index, String locale) async {
    addSelectedIndex = index;
    selectedLocaleService = locale;
    log("Selected Language Updated: $selectedLocaleService");

    await sharedPreferences.setString("selectedLocaleService", locale);

    notifyListeners();
  }

  bool isLoading = false;
  getLanguage() async {
    try {
      isLoading = true; // Start loading
      notifyListeners(); // Notify UI to show loader

      log("api.systemLanguage: ${api.systemLanguage}");
      translations = Translation.defaultTranslations();

      await apiServices
          .getApi(api.systemLanguage, [], isToken: false)
          .then((value) {
        if (value.isSuccess!) {
          // log("VALue :%${value.data}");
          for (var item in value.data) {
            SystemLanguage systemLanguage = SystemLanguage.fromJson(item);
            if (!languageList.contains(systemLanguage)) {
              languageList.add(systemLanguage);
            }
          }
        }
      });
    } catch (e) {
      debugPrint("EEEE NOTI getBookingDetailById $e");
    } finally {
      isLoading = false; // Stop loading
      notifyListeners(); // Notify UI to hide loader
    }
  }

  // LanguageHelper languageHelper = LanguageHelper();

  changeLocale(SystemLanguage newLocale) {
    log("sharedPreferences a1: $newLocale");
    Locale convertedLocale;

    currentLanguage = newLocale.name!;
    convertedLocale = Locale(
        newLocale.appLocale!.split("_")[0], newLocale.appLocale!.split("_")[1]);

    locale = convertedLocale;
    sharedPreferences.setString(
        'selectedLocale', locale!.languageCode.toString());

    getLanguageTranslate();

    notifyListeners();
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
        log("Loaded translations: ${response.data}");

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
    notifyListeners();
  }
}
