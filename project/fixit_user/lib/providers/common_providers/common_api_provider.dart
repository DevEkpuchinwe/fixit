import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fixit_user/config.dart';
import 'package:fixit_user/models/dashboard_user_model.dart';

import '../../models/app_setting_model.dart';

class CommonApiProvider extends ChangeNotifier {
  //self api
  selfApi(context) async {
    var body = {};
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      await apiServices.getApi(api.self, [], isToken: true).then((value) {
        if (value.isSuccess!) {
          log("DDD");
          // log("value.data: ${value.data}");
          userModel = UserModel.fromJson(value.data);
          pref.setString(
              session.user, json.encode(UserModel.fromJson(value.data)));

          notifyListeners();
          log("DDD1");
        }
      });
    } catch (e, s) {
      log("SELF :$e====> $s");
      notifyListeners();
    }
  }

  Future<ProviderModel> getProviderById(id) async {
    ProviderModel? providerModel;
    try {
      await apiServices
          .getApi("${api.provider}/$id", [], isData: true)
          .then((value) {
        if (value.isSuccess!) {
          providerModel = ProviderModel.fromJson(value.data);
          notifyListeners();
          return providerModel;
        }
      });
      return providerModel!;
    } catch (e) {
      log("ERRROEEE getProviderById common: $e");
      notifyListeners();
    }
    return providerModel!;
  }

  getData(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    log("pref :$pref");
    dynamic userData = pref.getString(session.user);
    if (userData != null) {
      await selfApi(context);
      final locationCtrl =
          Provider.of<LocationProvider>(context, listen: false);

      await locationCtrl.getUserCurrentLocation(context);
      //await locationCtrl.getLocationList();
      final dashCtrl = Provider.of<DashboardProvider>(context, listen: false);
      final favCtrl =
          Provider.of<FavouriteListProvider>(context, listen: false);
      favCtrl.getFavourite();
      dashCtrl.getBookingHistory(context);

      dashCtrl.getServicePackage();
      final cartCtrl = Provider.of<CartProvider>(context, listen: false);
      cartCtrl.onReady(context);
      final notifyCtrl =
          Provider.of<NotificationProvider>(context, listen: false);
      notifyCtrl.getNotificationList(context);
      dashCtrl.getBookingStatus();
    }
  }

  Future<bool> checkForAuthenticate() async {
    bool isAuth = false;
    try {
      await apiServices.getApi(api.address, [], isToken: true).then((value) {
        log("sdhfjsdkhf :");
        if (value.isSuccess!) {
          isAuth = true;
          notifyListeners();
          return isAuth;
        } else {
          if (value.message.toLowerCase() == "unauthenticated.") {
            isAuth = false;
            notifyListeners();
            return isAuth;
          } else {
            isAuth = false;
            notifyListeners();
            return isAuth;
          }
        }
      });
    } catch (e) {
      log("EEE homeStatisticApi :$e");
      return isAuth;
    }
    log("isAuth:$isAuth");
    return isAuth;
  }

  getPaymentMethodList(context) async {
    try {
      await apiServices.getApi(api.paymentMethod, []).then((value) {
        log("VALUE :${value.data}");
        if (value.isSuccess!) {
          paymentMethods = [];
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

  bool isLoading = false;
  getCategoryById(context, id) async {
    // print("object=================");
    isLoading = true;
    notifyListeners();
    CategoryModel? categoryModel;
    try {
      await apiServices
          .getApi("${api.category}/$id", [], isData: true, isMessage: false)
          .then((value) {
        log("CCCCC :${value.data}");
        if (value.isSuccess!) {
          categoryModel = CategoryModel.fromJson(value.data[0]);

          isLoading = false;
          notifyListeners();
          route.pushNamed(context, routeName.categoriesDetailsScreen,
              arg: categoryModel);
        }
      });
    } catch (e) {
      isLoading = false;
      log("ERRROEEE getCategoryById : $e");
      notifyListeners();
    }
  }

  //all category list
  getAllCategory({search}) async {
    // notifyListeners();
    try {
      await apiServices.getApi(api.categoryList, []).then((value) {
        if (value.isSuccess!) {
          allCategoryList = [];
          List category = value.data;
          for (var data in category.reversed.toList()) {
            if (!allCategoryList.contains(CategoryModel.fromJson(data))) {
              allCategoryList.add(CategoryModel.fromJson(data));
            }
            notifyListeners();
          }
        }
      });
    } catch (e) {
      log("EEEE AllCategory:::$e");
      notifyListeners();
    }
  }

  final dioo = Dio();
  DashboardModel? dashboardModel;
  CategoryModel? categoryModel;
  bool isLoadingDashboard = false;
  // BlogModel? blogModel;
  // String local = appSettingModel!.general!.defaultLanguage!.locale!;
  Future<void> getDashboardHome(BuildContext context) async {
    isLoadingDashboard = true;
    try {
      final lang = Provider.of<LanguageProvider>(context, listen: false);

      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString(session.accessToken);

      final response = await dioo.get(
        '${api.dashboardHome}',
        options: Options(headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          "Accept-Lang": 'en',
          // "Authorization": "Bearer $token",
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic> &&
            response.data['data'] is Map<String, dynamic>) {
          dashboardModel = DashboardModel.fromJson(response.data['data']);

          print('Full Response: ==> $dashboardModel}');

          // packageCtrl.text = response.data['data']['title'] ?? "";
          // descriptionCtrl.text = response.data['data']['description'] ?? "";
          // disclaimerCtrl.text = servicePackageModel!.disclaimer ?? "";

          // log("servicePackageModel!.title::${packageCtrl.text}");
          isLoadingDashboard = false;
          notifyListeners();
        } else {
          print('Full Response: ==> $dashboardModel}');

          isLoadingDashboard = false;
          log("Unexpected data format: ${response.data}");
          dashboardModel = DashboardModel.fromJson(response.data);
          // categoryModel = CategoryModel.fromJson(response.data['categories']);

          List category = response.data['categories'];
          for (var data in category.reversed.toList()) {
            if (!homeCategoryList.contains(CategoryModel.fromJson(data))) {
              homeCategoryList.add(CategoryModel.fromJson(data));
            }
            notifyListeners();
          }
          List servicePackages = response.data['servicePackages'];
          for (var data in servicePackages.reversed.toList()) {
            if (!homeServicePackagesList
                .contains(ServicePackageModel.fromJson(data))) {
              homeServicePackagesList.add(ServicePackageModel.fromJson(data));
            }
            notifyListeners();
          }
          homeFeaturedService.clear();
          List featuredService = response.data['featuredServices'];
          for (var data in featuredService.reversed.toList()) {
            if (!homeFeaturedService.contains(Services.fromJson(data))) {
              homeFeaturedService.add(Services.fromJson(data));
            }
            notifyListeners();
          }
          log("message===========$homeFeaturedService");
          homeProvider.clear();
          List provider = response.data['highestRatedProviders'];
          for (var data in provider.reversed.toList()) {
            if (!homeProvider.contains(ProviderModel.fromJson(data))) {
              homeProvider.add(ProviderModel.fromJson(data));
            }
            notifyListeners();
          }
          log("message===========$homeProvider");

          /*  List blogModel = response.data['blogs'];
          log("message=========== model$blogModel");
          for (var data in blogModel.reversed.toList()) {
            if (!homeBlog.contains(BlogModel.fromJson(data))) {
              homeBlog.add(BlogModel.fromJson(data));
            }
            notifyListeners();
          } */
          notifyListeners();
          print('Full Response: ==> $dashboardModel}');
        }
      } else {
        isLoadingDashboard = false;
        notifyListeners();
        log("Failed to fetch service details: ${response.statusMessage}");
      }
    } catch (e, s) {
      isLoadingDashboard = false;
      notifyListeners();
      log("Error fetching dashboard home: $e ======> $s");
    }
  }
}
