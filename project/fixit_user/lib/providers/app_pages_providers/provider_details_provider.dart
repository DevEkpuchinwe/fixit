import 'dart:developer';

import 'package:fixit_user/config.dart';

class ProviderDetailsProvider with ChangeNotifier {
  int selectIndex = 0;
  int selectProviderIndex = 0;
  double widget1Opacity = 0.0;
  List<CategoryModel> categoryList = [];
  List<Services> serviceList = [];
  bool visible = true;
  int val = 1;
  double loginWidth = 100.0;
  int providerId = 0;
  ProviderModel? provider;

  /*  onSelectService(context, index) {
    selectIndex = index;
    notifyListeners();

    getServiceByCategoryId(context, categoryList[index].id);
  } */

  List<CategoryService> cachedServiceList = [];
  List dataLocalList = [];
  onSelectService(context, index, id) async {
    selectIndex = index;
    notifyListeners();
    log("cachedServiceList :${cachedServiceList.length}");

    // Store last 3 selected list data
    int val = cachedServiceList
        .indexWhere((element) => element.id.toString() == id.toString());
    log("index :$val");
    if (val >= 0) {
      serviceList = cachedServiceList[val].serviceList!;
    } else {
      getServiceByCategoryId(context, id);
    }
    // await getServiceByCategoryId(context, id);
    // hideLoading(context);
    // notifyListeners();

    log("categoryList[value.selectedIndex]::: ${dataLocalList}");

    log("Stored Last 3 Lists: ${dataLocalList.length}");
  }

  onChooseService(index) {
    selectProviderIndex = index;
    notifyListeners();
  }

  onAddService() {
    if (!visible) {
      visible = !visible;
      loginWidth = 100.0;
    } else {
      val = ++val;
    }
    notifyListeners();
  }

  onBack(context, isBack) {
    // provider = null;
    // widget1Opacity = 0.0;
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
  }

  onReady(context, {id}) async {
    notifyListeners();
    dynamic data;
    if (id != null) {
      data = id;
    } else {
      data = ModalRoute.of(context)!.settings.arguments;
      notifyListeners();
      if (data['providerId'] != null) {
        data = data['providerId'];
      } else {
        provider = data['provider'];
        data = provider!.id;
      }
    }
    notifyListeners();

    await getProviderById(context, data);
    await getCategory(context, data);
    // widget1Opacity = 1;
    notifyListeners();
  }

  onRemoveService(context, index) async {
    if ((serviceList[index].selectedRequiredServiceMan!) == 1) {
      route.pop(context);
      isAlert = false;
      notifyListeners();
    } else {
      if ((serviceList[index].requiredServicemen!) ==
          (serviceList[index].selectedRequiredServiceMan!)) {
        isAlert = true;
        notifyListeners();
        await Future.delayed(DurationClass.s3);
        isAlert = false;
        notifyListeners();
      } else {
        isAlert = false;
        notifyListeners();
        serviceList[index].selectedRequiredServiceMan =
            ((serviceList[index].selectedRequiredServiceMan!) - 1);
      }
    }
    notifyListeners();
  }

  onAdd(index) {
    isAlert = false;
    notifyListeners();
    int count = (serviceList[index].selectedRequiredServiceMan!);
    count++;
    serviceList[index].selectedRequiredServiceMan = count;
    log("CCCC");
    notifyListeners();
  }

  getProviderById(context, id) async {
    try {
      await apiServices
          .getApi("${api.provider}/$id", [], isData: true)
          .then((value) {
        if (value.isSuccess!) {
          provider = ProviderModel.fromJson(value.data);
          notifyListeners();
        }
      });
    } catch (e) {
      log("ERRROEEE getProviderById orovider: $e");
      notifyListeners();
    }
  }

  getCategory(context, id) async {
    // notifyListeners();
    try {
      String apiURL = "${api.category}?providerId=$id";
      if (zoneIds.isNotEmpty) {
        apiURL = "${api.category}?providerId=$id&zone_ids=$zoneIds";
      } else {
        apiURL = "${api.category}?providerId=$id";
      }

      await apiServices.getApi(apiURL, []).then((value) {
        if (value.isSuccess!) {
          List category = value.data;
          categoryList = [];
          for (var data in category.reversed.toList()) {
            if (!categoryList.contains(CategoryModel.fromJson(data))) {
              categoryList.add(CategoryModel.fromJson(data));
              notifyListeners();
            }
            notifyListeners();
          }
          getServiceByCategoryId(context, categoryList[0].id);
        }
      });
    } catch (e) {
      notifyListeners();
    }
  }

  onRefresh(context) async {
    showLoading(context);
    notifyListeners();
    await getServiceByCategoryId(context, categoryList[selectIndex].id);
    hideLoading(context);
  }

  bool isCategoriesLoadeer = false;
  getServiceByCategoryId(context, id) async {
    isCategoriesLoadeer = true;
    showLoading(context);
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    notifyListeners();

    try {
      showLoading(context);
      String apiUrl = "${api.service}?categoryIds=$id&zone_ids=$zoneIds";
      log("URRR L: $apiUrl");
      await apiServices.getApi(apiUrl, []).then((value) {
        if (value.isSuccess!) {
          isCategoriesLoadeer = false;
          serviceList = [];
          for (var data in value.data) {
            Services services = Services.fromJson(data);
            if (!serviceList.contains(services)) {
              serviceList.add(services);
            }

            notifyListeners();
          }

          CategoryService categoryService =
              CategoryService(id: id, serviceList: serviceList);
          log("categoryService : $categoryService");
          log("categoryService : ${cachedServiceList.isEmpty}");
          if (cachedServiceList.isNotEmpty) {
            log("AAAA1111AAAA");
            if (cachedServiceList.length > 3) {
              cachedServiceList.removeAt(0);
              cachedServiceList.add(categoryService);
            } else {
              int index = cachedServiceList.indexWhere(
                  (element) => element.id.toString() == id.toString());
              if (index >= 0) {
                log("ssss");
              } else {
                cachedServiceList.add(categoryService);
                log("A00");
              }
            }
          } else {
            log("AAAAAAAA");
            cachedServiceList.add(categoryService);
          }
        }
        hideLoading(context);
        notifyListeners();
      });
    } catch (e) {
      isCategoriesLoadeer = false;
      log("ERRROEEE getServiceByCategoryId $e");
      hideLoading(context);
      notifyListeners();
    }
  }
}
