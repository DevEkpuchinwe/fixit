import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixit_user/models/app_setting_model.dart';
import 'package:fixit_user/models/translation_model.dart';
import 'package:fixit_user/services/environment.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
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
    SharedPreferences preferences = await SharedPreferences.getInstance();

    isGuest = preferences.getBool(session.isContinueAsGuest) ?? false;
    final commonApi = Provider.of<CommonApiProvider>(context, listen: false);
    log(" ==========>>> Full Response: Calling Dashboard Home");
    commonApi.getDashboardHome(context);
    if (isAvailable) {
      getAppSettingList(context);
      getPaymentMethodList(context);
      final appDetails =
          Provider.of<AppDetailsProvider>(context, listen: false);
      appDetails.getAppPages();
      // final languageCtrl =
      //     Provider.of<LanguageProvider>(context, listen: false);
      // languageCtrl.getLanguageTranslate();
      getAllCategory();
      SharedPreferences pref = await SharedPreferences.getInstance();
      dynamic userData = pref.getString(session.user);
      final commonApi = Provider.of<CommonApiProvider>(context, listen: false);
      bool isAuthenticate = false;
      if (userData != null) {
        isAuthenticate = await commonApi.checkForAuthenticate();
      }

      log("isAuthenticate :$isAuthenticate");
      controller = controller =
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

      log("ANIMATION CON ${popUpAnimationController!.status}");

      final dashCtrl = Provider.of<DashboardProvider>(context, listen: false);
      final locationCtrl =
          Provider.of<LocationProvider>(context, listen: false);
      await Future.wait([
        Future(
          () {
            dashCtrl.getCurrency();
            dashCtrl.getBanner();
            dashCtrl.getOffer();
            dashCtrl.getCoupons();
            dashCtrl.getBookingStatus();
            dashCtrl.getProvider();
            dashCtrl.getFeaturedPackage(1);
            dashCtrl.getHighestRate();
            dashCtrl.getBlog();
            locationCtrl.getCountryState();
            locationCtrl.getUserCurrentLocation(context);
          },
        )
      ]);

      // dashCtrl.getCurrency();
      // dashCtrl.getBanner();
      // // dashCtrl.getOffer();
      // // dashCtrl.getCoupons();
      // dashCtrl.getBookingStatus();
      // dashCtrl.getProvider();

      // dashCtrl.getFeaturedPackage(1);
      // dashCtrl.getHighestRate();
      // dashCtrl.getBlog();

      // locationCtrl.getCountryState();
      // await locationCtrl.getUserCurrentLocation(context);
      final search = Provider.of<SearchProvider>(context, listen: false);
      search.loadImage1();
      if (userData != null) {
        log("userData::;");
        pref.remove(session.isContinueAsGuest);
        final commonApi =
            Provider.of<CommonApiProvider>(context, listen: false);
        Future.delayed(const Duration(milliseconds: 150)).then(
          (value) async {
            log('messagehsydughsyfgdsyug');
            final favCtrl =
                Provider.of<FavouriteListProvider>(context, listen: false);
            final cartCtrl = Provider.of<CartProvider>(context, listen: false);
            final notifyCtrl =
                Provider.of<NotificationProvider>(context, listen: false);
            final wallet = Provider.of<WalletProvider>(context, listen: false);
            final review =
                Provider.of<MyReviewProvider>(context, listen: false);
            await Future.wait([
              Future(() {
                commonApi.selfApi(context);
                // log(" ==========>>> Full Response: Calling Dashboard Home");

                locationCtrl.getLocationList(context);
                favCtrl.getFavourite();
                dashCtrl.getBookingHistory(context);
                dashCtrl.getServicePackage();
                cartCtrl.onReady(context);
                notifyCtrl.getNotificationList(context);
                wallet.getWalletList(context);
                review.getMyReview(context);
              })
            ]);

            // await commonApi.selfApi(context);
            // await locationCtrl.getLocationList(context);

            // favCtrl.getFavourite();
            // dashCtrl.getBookingHistory(context);
            // dashCtrl.getServicePackage();

            // cartCtrl.onReady(context);

            // notifyCtrl.getNotificationList(context);

            // wallet.getWalletList(context);

            // review.getMyReview(context);
          },
        );
      }

      Timer(const Duration(seconds: 4), () async {
        await Future.delayed(Duration(milliseconds: 150)).then(
          (value) {
            locationCtrl.getZoneId();
          },
        );
        bool? isIntro = pref.getBool(session.isIntro) ?? false;

        log("userData :: $userData");

        Provider.of<SplashProvider>(context, listen: false).dispose();
        onDispose();
        await Future.delayed(Duration(milliseconds: 150)).then(
          (value) {
            dashCtrl.getCategory();
            dashCtrl.getServicePackage();
            dashCtrl.getJobRequest();
          },
        );
        /*       if (appSettingModel != null &&
            appSettingModel!.activation!.maintenanceMode == "1") {
          route.pushReplacementNamed(context, routeName.maintenanceMode);
        } else {*/
        log("isIntro::$isIntro");
        if (isIntro) {
          if (userData != null) {
            if (isAuthenticate) {
              route.pushReplacementNamed(context, routeName.dashboard);
            } else {
              userModel = null;
              setPrimaryAddress = null;
              userPrimaryAddress = null;
              final dash =
                  Provider.of<DashboardProvider>(context, listen: false);
              dash.selectIndex = 0;
              dash.notifyListeners();
              pref.remove(session.user);
              pref.remove(session.accessToken);
              pref.remove(session.isContinueAsGuest);
              pref.remove(session.isLogin);
              pref.remove(session.cart);
              pref.remove(session.recentSearch);

              final auth = FirebaseAuth.instance.currentUser;
              if (auth != null) {
                FirebaseAuth.instance.signOut();
                GoogleSignIn().disconnect();
              }
              final login = Provider.of<LoginProvider>(context, listen: false);
              login.continueAsGuestTap(context);

              // pref.setBool(session.isContinueAsGuest, true);
              // route.pushReplacementNamed(context, routeName.dashboard);
              // route.pushReplacementNamed(context, routeName.login);
            }
          } else {
            final login = Provider.of<LoginProvider>(context, listen: false);
            login.continueAsGuestTap(context);
            // pref.setBool(session.isContinueAsGuest, true);
            // route.pushReplacementNamed(context, routeName.dashboard);
            // route.pushReplacementNamed(context, routeName.login);
          }
        } else {
          route.pushReplacementNamed(context, routeName.onBoarding);
        }
        // }
      });
    } else {
      onDispose();
      Provider.of<SplashProvider>(context, listen: false).dispose();
      route.pushReplacementNamed(context, routeName.noInternet);
    }
  }

//setting list
  getAppSettingList(context) async {
    try {
      await apiServices.getApi(api.settings, [], isData: true).then((value) {
        if (value.isSuccess!) {
          appSettingModel = AppSettingModel.fromJson(value.data['values']);
          log("success:");
          notifyListeners();
        }
        onUpdate(context, appSettingModel!.general!.defaultCurrency!);
        onUpdateLanguage(context, appSettingModel!.general!.defaultLanguage!);
        log("appSettingModel!.general!.defaultLanguage::${appSettingModel!.general!.defaultLanguage!.locale}");
        notifyListeners();
      });
    } catch (e) {
      log("EEEE getAppSettingList $e");
      apiServices.dioException(e);
      if (context.mounted) {
        notifyListeners();
      }
    }
  }

  //all category list
  getAllCategory({search}) async {
    safeNotifyListeners();
    try {
      final response = await apiServices.getApi(api.categoryList, []);

      if (response.isSuccess! && response.data != null) {
        allCategoryList = []; // Clear the existing list
        List category = response.data;

        log("Category Count: ${category.length}");
        for (var data in category.reversed) {
          try {
            final categoryItem = CategoryModel.fromJson(data);
            if (!allCategoryList.contains(categoryItem)) {
              allCategoryList.add(categoryItem);
            }
          } catch (e) {
            log("Error parsing category data: $e");
          }
        }
        // Notify listeners once after updating the list
        safeNotifyListeners();
      } else {
        log("API response data is null or unsuccessful.");
      }
    } catch (e) {
      log("Error in getAllCategory: $e");
      safeNotifyListeners();
    }
  }

  bool _isDisposed = false;

  void safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  //setting list
  getPaymentMethodList(context) async {
    try {
      await apiServices.getApi(api.paymentMethod, []).then((value) {
        log("VALUE :${value.data}");
        if (value.isSuccess!) {
          for (var d in value.data) {
            paymentMethods.add(PaymentMethods.fromJson(d));
          }
          notifyListeners();
        }

        notifyListeners();
      });
    } catch (e) {
      log("EEEE getPaymentMethodList:$e");
      notifyListeners();
    }
  }

  onUpdate(context, CurrencyModel data) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final currencyData = Provider.of<CurrencyProvider>(context, listen: false);
    double? currencyVal = pref.getDouble(session.currencyVal);
    if (currencyVal != null) {
      final prefCurrency = pref.getString(session.currency);
      log("currencyVal:::$currencyVal");
      currencyData.currencyVal = currencyVal;
      currencyData.currency = CurrencyModel.fromJson(jsonDecode(prefCurrency!));
      currencyData.priceSymbol = pref.getString(session.priceSymbol)!;
      currencyData.notifyListeners();
    } else {
      currency(context).priceSymbol = data.symbol.toString();

      currencyData.currency = data;
      currencyData.currencyVal = data.exchangeRate!;
      currencyData.notifyListeners();
    }

    await pref.setString(session.priceSymbol, currency(context).priceSymbol);
    Map<String, dynamic> cc = await currencyData.currency!.toJson();
    await pref.setString(session.currency, jsonEncode(cc));
    await pref.setDouble(session.currencyVal, currencyData.currencyVal);
    notifyListeners();
    log("currency(context).priceSymbol : ${currency(context).priceSymbol}");
  }

  onDispose() async {
    bool isAvailable = await isNetworkConnection();
    if (!isAvailable) {
      controller2!.dispose();
      controller3!.dispose();
      animation3!.isDismissed;
      controller!.dispose();
      controllerSlide!.dispose();
      popUpAnimationController!.dispose();
    }
  }

  onChangeSize() {
    size = size == 10 ? 115 : 115;
    notifyListeners();
  }

  onUpdateLanguage(context, DefaultLanguage data) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.getString("selectedLocale") == null) {
      await pref.setString('selectedLocale', data.locale!);
      log("messagedatadatadata::${data.locale}");
    } else {
      log("messagedatadatadavdsfsdta::${data.locale}");
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;

    // TODO: implement dispose
    onDispose();
    controller2!.dispose();
    controller3!.dispose();
    animation3!.isDismissed;
    controller!.dispose();
    controllerSlide!.dispose();
    popUpAnimationController!.dispose();
    super.dispose();
  }
}
