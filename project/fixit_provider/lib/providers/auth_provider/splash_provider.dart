import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:fixit_provider/firebase/firebase_api.dart';
import 'package:fixit_provider/providers/common_providers/notification_provider.dart';
import '../../config.dart';

class SplashProvider extends ChangeNotifier {
  double size = 10;
  double roundSize = 10;
  double roundSizeWidth = 10;
  AnimationController? controller;
  Animation<double>? animation;

  AnimationController? controller2;
  Animation<double>? animation2;

  AnimationController? controller3;
  Animation<double>? animation3;

  AnimationController? controllerSlide;
  Animation<Offset>? offsetAnimation;

  AnimationController? popUpAnimationController;

  onReady(TickerProvider sync, context) async {
    bool isAvailable = await isNetworkConnection();

    if (isAvailable) {
      onChangeSize();
      getAppSettingList(context);
      CustomNotificationController().initNotification(context);
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
      final commonApi = Provider.of<CommonApiProvider>(context, listen: false);
      userApi.getBookingHistory(context);
      commonApi.getDashBoardApi(context);
      // userApi.homeStatisticApi();
      // userApi.statisticDetailChart();

      var freelancer = prefs.getBool(session.isFreelancer) ?? false;
      var login = prefs.getBool(session.isLogin) ?? false;
      bool notification = prefs.getBool(session.isNotification) ?? true;
      log("FREEELANCEERRR $freelancer");
      prefs.setBool(session.isNotification, notification);
      isLogin = login;
      isFreelancer = freelancer;
      log("LOGGIINN $login");

      notifyListeners();
      dynamic userData = prefs.getString(session.user);

      notifyListeners();

      final appSet = Provider.of<AppSettingProvider>(context, listen: false);
      bool isAuthenticate = false;
      if (userData != null) {
        // commonApi.checkForAuthenticate();
        isAuthenticate = prefs.getBool(session.token) ?? false;
      }

      await Future.wait([
        Future(
          () {
            appSet.onNotification(notification, context);
            commonApi.getDocument();
            commonApi.getKnownLanguage();
            commonApi.getTax();
          }
        )
      ]);
      commonApi.getSubscriptionPlanList(context);

      if (isAuthenticate) {
        commonApi.getCountryState();
        commonApi.getZoneList();
        // commonApi.getCurrency();
        // commonApi.getBlog();
      }
      if (prefs.getBool(session.isServiceman) == true) {
        commonApi.getBlog();
      }

      if (!isAuthenticate) {
        commonApi.getCountryState();
        // commonApi.getDocument();
        commonApi.getZoneList();
        commonApi.getKnownLanguage();
      }

      // commonApi.getCountryState();
      // commonApi.getZoneList();
      // commonApi.getCurrency();

      // commonApi.getAllCategory();

      // commonApi.getBookingStatus();
      // commonApi.getPaymentMethodList();

      isLogin = login;

      controller =
          AnimationController(vsync: sync, duration: const Duration(seconds: 1))
            ..addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                controller!.stop();
                notifyListeners();
              }
              if (status == AnimationStatus.dismissed) {
                controller!.forward();
                notifyListeners();
              }
            });

      animation = CurvedAnimation(parent: controller!, curve: Curves.easeIn);
      controller!.forward();

      controller2 = AnimationController(
          vsync: sync, duration: const Duration(seconds: 1));
      animation2 = CurvedAnimation(parent: controller2!, curve: Curves.easeIn);

      if (controller2!.status == AnimationStatus.forward ||
          controller2!.status == AnimationStatus.completed) {
        controller2!.reverse();
        notifyListeners();
      } else if (controller2!.status == AnimationStatus.dismissed) {
        Timer(const Duration(seconds: 1), () {
          controller2!.forward();
          notifyListeners();
        });
      }

      controllerSlide = AnimationController(
          vsync: sync, duration: const Duration(seconds: 1));

      offsetAnimation =
          Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
              .animate(controllerSlide!);

      controller3 =
          AnimationController(duration: const Duration(seconds: 1), vsync: sync)
            ..repeat();
      animation3 = CurvedAnimation(parent: controller3!, curve: Curves.easeIn);

      popUpAnimationController = AnimationController(
          vsync: sync, duration: const Duration(seconds: 1));

      Timer(const Duration(seconds: 1), () {
        popUpAnimationController!.forward();
        notifyListeners();
      });

      if (userData != null) {
        final commonApi =
            Provider.of<CommonApiProvider>(context, listen: false);
        await commonApi.selfApi(context);
        commonApi.getDashBoardApi(context);
        final locationCtrl =
            Provider.of<LocationProvider>(context, listen: false);

        locationCtrl.getUserCurrentLocation(context);
        final userApi =
            Provider.of<UserDataApiProvider>(context, listen: false);
        // final bookingAPi = Provider.of<BookingProvider>(context, listen: false);
        if (prefs.getBool(session.isServiceman) == true) {
          // userApi.homeStatisticApi();
          commonApi.getDashBoardApi(context);
        }
        // commonApi.getDashBoardApi(context);
        await Future.wait([
          Future(
            () {
              // userApi.getCategory();
              userApi.commissionHistory(false, context);
              userApi.getPopularServiceList();
              userApi.getAllServiceList();
              // userApi.getJobRequest();
              // userApi.getBookingHistory(context);
              userApi.getBankDetails();
              userApi.getTotalEarningByCategory();
              // userApi.getDocumentDetails();
              commonApi.getDocument();
              // userApi.getDocumentDetails();

              // userApi.getNotificationList();
            },
          )
        ]);

        if (!isFreelancer) {
          userApi.getServicemenByProviderId();
        }

        if (isFreelancer || !isServiceman) {
          userApi.getServicePackageList();
        }
        final chat = Provider.of<ChatHistoryProvider>(context, listen: false);
        chat.onReady(context);

        FirebaseApi().onlineActiveStatusChange(false);
      } else {
        final locationCtrl =
            Provider.of<LocationProvider>(context, listen: false);
        locationCtrl.getUserCurrentLocation(context);
      }
      Timer(const Duration(seconds: 2), () async {
        onDispose();
        Provider.of<SplashProvider>(context, listen: false).dispose();
        if (appSettingModel != null &&
            appSettingModel!.activation!.maintenanceMode == "1") {
          route.pushReplacementNamed(context, routeName.maintenanceMode);
        } else {
          if (userData != null) {
            UserModel user = UserModel.fromJson(jsonDecode(userData));
            if (isAuthenticate) {
              if (user.role!.name == "provider") {
                route.pushReplacementNamed(context, routeName.dashboard);
                /* if (!isSubscription) {
                  route.pushReplacementNamed(
                      context, routeName.subscriptionPlan);
                } else {

                }*/
              } else {
                route.pushReplacementNamed(context, routeName.dashboard);
              }
            } else {
              final dash =
                  Provider.of<DashboardProvider>(context, listen: false);
              final userApi =
                  Provider.of<UserDataApiProvider>(context, listen: false);
              dash.selectIndex = 0;
              dash.notifyListeners();
              commonApi.getDashBoardApi(context);
              // userApi.homeStatisticApi();
              prefs.remove(session.user);
              prefs.remove(session.accessToken);
              prefs.remove(session.token);
              prefs.remove(session.isLogin);
              prefs.remove(session.isFreelancer);
              prefs.remove(session.isServiceman);
              prefs.remove(session.isLogin);
              userModel = null;
              userPrimaryAddress = null;
              provider = null;
              position = null;
              statisticModel = null;
              bankDetailModel = null;
              popularServiceList = [];
              servicePackageList = [];
              providerDocumentList = [];
              notificationList = [];
              notUpdateDocumentList = [];
              addressList = [];

              route.pushReplacementNamed(context, routeName.intro);
            }
          } else {
            route.pushReplacementNamed(context, routeName.intro);
          }
        }
      });
    } else {
      onDispose();
      log("isAvailableisAvailableisAvailable:::$isAvailable");
      /* Provider.of<SplashProvider>(context, listen: false).dispose();*/
      route.pushReplacementNamed(context, routeName.noInternet);
    }
  }

  onDispose() async {
    bool isAvailable = await isNetworkConnection();
    if (isAvailable) {
      controller2!.dispose();
      controller3!.dispose();
      controller!.dispose();
      controllerSlide!.dispose();
      popUpAnimationController!.dispose();
    }
  }

  onChangeSize() {
    size = size == 10 ? 115 : 115;
    notifyListeners();
  }

  //setting list
  getAppSettingList(BuildContext context) async {
    try {
      var value = await apiServices.getApi(api.settings, [], isData: true);

      if (value.isSuccess!) {
        appSettingModel = AppSettingModel.fromJson(value.data['values']);

        /* if (context.mounted) { */
        final currencyData = Provider.of<CurrencyProvider>(context, listen: false);
        onUpdate(currencyData, appSettingModel!.general!.defaultCurrency!);
        // onUpdate(context, appSettingModel!.general!.defaultCurrency!);
        onUpdateLanguage(context, appSettingModel!.general!.defaultLanguage!);

        notifyListeners();
        /* } */
      }
    } catch (e) {
      log("EEEE :getAppSettingList $e");
      if (context.mounted) {
        notifyListeners();
      }
    }
  }

  void onUpdate(CurrencyProvider currencyData, CurrencyModel data) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    double? currencyVal = pref.getDouble(session.currencyVal);
    if (currencyVal != null) {
      final prefCurrency = pref.getString(session.currency);

      currencyData.currencyVal = currencyVal;
      currencyData.currency = CurrencyModel.fromJson(jsonDecode(prefCurrency!));
      currencyData.priceSymbol = pref.getString(session.priceSymbol)!;
    } else {
      currencyData.priceSymbol = data.symbol.toString();
      currencyData.currency = data;
      currencyData.currencyVal = data.exchangeRate!;
    }

    await pref.setString(session.priceSymbol, currencyData.priceSymbol);
    Map<String, dynamic> cc = await currencyData.currency!.toJson();
    await pref.setString(session.currency, jsonEncode(cc));
    await pref.setDouble(session.currencyVal, currencyData.currencyVal);

    currencyData.notifyListeners();
  }


  Locale? locale;

  onUpdateLanguage(context, DefaultLanguage data) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // final languageProvider =
    //     Provider.of<LanguageProvider>(context, listen: false);
    if (pref.getString("selectedLocale") == null) {
      // languageProvider.currentLanguage = data.locale!;
      await pref.setString('selectedLocale', data.locale!);
      // languageProvider.changeLocale(data.locale as SystemLanguage);

      // locale = const Locale("en");
    } else {
      log("messagedatadatadavdsfsdta::${data.locale}");
    }

    // languageProvider.notifyListeners();
  }
}
