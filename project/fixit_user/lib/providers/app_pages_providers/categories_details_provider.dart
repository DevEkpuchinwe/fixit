import 'dart:developer';
import 'package:fixit_user/common_tap.dart';
import 'package:fixit_user/config.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import '../../screens/app_pages_screens/category_detail_screen/layouts/categories_filter.dart';

class CategoriesDetailsProvider with ChangeNotifier {
  TextEditingController searchCtrl = TextEditingController();
  TextEditingController filterSearchCtrl = TextEditingController();
  int selectedIndex = 0;
  double widget1Opacity = 0.0;
  Future<ui.Image>? loadingImage;
  final FocusNode searchFocus = FocusNode();
  final FocusNode filterSearchFocus = FocusNode();
  int? exValue = appArray.experienceList[0]["id"];
  String selectedExp = appArray.experienceList[0]["title"];
  List selectedRates = [];
  List<Services> serviceList = [];
  CategoryModel? categoryModel;
  bool val = true;
  double maxPrice = 100.0, minPrice = 0.0, lowerVal = 00.0, upperVal = 100.0;
  Services? services;
  List<ProviderModel> providerList = [];
  List selectedProvider = [];
  List<CategoryModel> hasCategoryList = [];
  int? subCategoryId;

  onSwitch(value) {
    val = value;
    notifyListeners();
  }

  onExperience(val) {
    exValue = val;
    selectedExp = appArray.experienceList[val]['title'];
    notifyListeners();
    fetchProviderByFilter();
  }

  String totalCountFilter() {
    log("maxPrice :: $maxPrice");
    int count = 0;

    if (selectedProvider.isNotEmpty) {
      count++;
    }
    if (lowerVal != 00.0 || upperVal < maxPrice) {
      count++;
    }
    if (selectedRates.isNotEmpty) {
      count++;
    }
    if (slider != 0.0) {
      count++;
    }

    if (isSelect != null) {
      count++;
    }

    return count.toString();
  }

  fetchProviderByFilter() async {
    try {
      String val = selectedExp.toString().contains(
              "Highest Experience") /* ||
              selectedExp.toString().contains("Lowest Experience") */
          ? "high"
          : "low";

      String val1 = selectedExp.toString().contains(
              "Highest Served") /* ||
              selectedExp.toString().contains("Lowest Experience") */
          ? "high"
          : "low";
      String apiUrl = "";
      log("apiUrl:${selectedExp.toString()}");
      if (filterSearchCtrl.text.isEmpty) {
        if (selectedExp.toString().contains("Highest Experience") ||
            selectedExp.toString().contains("Lowest Experience")) {
          apiUrl =
              "${api.provider}?experience=$val&search=${filterSearchCtrl.text}";
        } else {
          apiUrl =
              "${api.provider}?served=$val1&search=${filterSearchCtrl.text}";
        }
      } else {
        apiUrl = "${api.provider}?search=${filterSearchCtrl.text}";
      }
      log("apiUrl:$apiUrl");
      log("message=====================>$providerList");
      await apiServices.getApi(apiUrl, []).then((value) {
        if (value.isSuccess!) {
          List provider = value.data;
          providerList = [];
          log("message=====================>$providerList");
          notifyListeners();
          for (var data in provider) {
            if (!providerList.contains(ProviderModel.fromJson(data))) {
              providerList.add(ProviderModel.fromJson(data));
            }
            notifyListeners();
          }
          log("message=====================>$providerList");

          notifyListeners();
          log("providerList ::${providerList.length}");
        }
      });
    } catch (e, s) {
      log("message=====================>$e==> $s");
      notifyListeners();
    }
  }

  getProvider() async {
    try {
      await apiServices.getApi(api.provider, []).then((value) {
        if (value.isSuccess!) {
          List provider = value.data;
          providerList = [];
          for (var data in provider.reversed.toList()) {
            providerList.add(ProviderModel.fromJson(data));
            notifyListeners();
          }

          notifyListeners();
          debugPrint("providerList ::${providerList.length}");
        }
      });
    } catch (e) {
      log("ERRROEEE getProvider : $e");
      notifyListeners();
    }
  }

  onCategoryChange(index) {
    if (!selectedProvider.contains(index)) {
      selectedProvider.add(index);
    } else {
      selectedProvider.remove(index);
    }
    notifyListeners();
  }

/*   onSubCategories(context, index, id) async {
    // showLoading(context);
    notifyListeners();
    selectedIndex = index;
    notifyListeners();
    log("idid:$id");
    await getServiceByCategoryId(context, id);
    hideLoading(context);
    notifyListeners();
  } */
  List<CategoryService> cachedServiceList = [];
  List dataLocalList = [];
  onSubCategories(context, index, id) async {
    selectedIndex = index;
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

  int selectIndex = 0;

  onFilter(index) {
    selectIndex = index;
    notifyListeners();
  }

  double slider = 0;
  bool? isSelect;
  int ratingIndex = 0;

  onSliderChange(handlerIndex, lowerValue, upperValue) {
    lowerVal = lowerValue;
    upperVal = upperValue;
    notifyListeners();
  }

  onTapRating(id) {
    if (!selectedRates.contains(id)) {
      selectedRates.add(id);
    } else {
      selectedRates.remove(id);
    }

    notifyListeners();
  }

  onChange() {
    isSelect = false;
    notifyListeners();
  }

  onChange1() {
    isSelect = true;
    notifyListeners();
  }

  double sliderValue = 0.0;

  onChangeSlider(sVal) {
    notifyListeners();
    sliderValue = sVal;
    notifyListeners();
  }

  Future<ui.FrameInfo> loadImage(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: 30, targetWidth: 30);
    ui.FrameInfo fi = await codec.getNextFrame();
    notifyListeners();
    return fi;
  }

  ui.Image? customImage;

  slidingValue(newValue) {
    slider = newValue;
    notifyListeners();
  }

  onBottomSheet(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return const CategoriesFilterLayout();
      },
    );
  }

  onRefresh(context) async {
    showLoading(context);
    notifyListeners();
    if (categoryModel!.hasSubCategories != null &&
        categoryModel!.hasSubCategories!.isNotEmpty) {
      await getServiceByCategoryId(
          context, categoryModel!.hasSubCategories![0].id);
    } else {
      await getServiceByCategoryId(context, categoryModel!.id);
    }
    hideLoading(context);
    notifyListeners();
  }

  onReady(context) async {
    widget1Opacity = 1;
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    categoryModel = data;
    // hasCategoryList = [];
    notifyListeners();
    if (categoryModel!.hasSubCategories != null &&
        categoryModel!.hasSubCategories!.isNotEmpty) {
      hasCategoryList = categoryModel!.hasSubCategories!;

      for (var d in categoryModel!.hasSubCategories!) {
        if (d.hasSubCategories != null && d.hasSubCategories!.isNotEmpty) {
          for (var a in d.hasSubCategories!) {
            if (!hasCategoryList.contains(a)) {
              hasCategoryList.add(a);
            }
          }
          log("sdfsdf:${hasCategoryList.length}");
        }
        notifyListeners();
      }
      notifyListeners();

      await getServiceByCategoryId(context, hasCategoryList[0].id);
    } else {
      await getServiceByCategoryId(context, categoryModel!.id);
    }
    final dash = Provider.of<DashboardProvider>(context, listen: false);

    providerList = dash.providerList;
    notifyListeners();
    /* Future.delayed(const Duration(milliseconds: 500), () {
      widget1Opacity = 1;
      notifyListeners();
    }); */
    hideLoading(context);
    notifyListeners();
    // log("providerList : ${categoryModel!.hasSubCategories!.isNotEmpty}");
  }

  onBack(context, isBack, id) {
    selectedIndex = 0;
    selectIndex = 0;
    selectedProvider = [];
    selectedRates = [];
    lowerVal = 00.0;
    upperVal = maxPrice;
    slider = 0;
    // serviceList = [];
    // hasCategoryList = [];
    searchCtrl.text = "";
    widget1Opacity = 0.0;

    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
  }

  bool isLoader = false;

  getServiceByCategoryId(context, id) async {
    notifyListeners();
    isLoader = true;
    try {
      String apiUrl = "";
      log("isSelect :$isSelect // $lowerVal // $upperVal // $zoneIds");
      if (isSelect == null &&
          lowerVal == 0.0 &&
          selectedProvider.isEmpty &&
          selectedRates.isEmpty &&
          upperVal == 100.0) {
        log("LOG 1");
        apiUrl = "${api.service}?categoryIds=$id&zone_ids=$zoneIds";
      } else if (selectedRates.isNotEmpty) {
        log("LOG 2");
        apiUrl =
            "${api.service}?categoryIds=$id&zone_ids=$zoneIds&rating=$selectedRates&search=${searchCtrl.text}";
      } else if (selectedProvider.isNotEmpty) {
        log("LOG 3");
        apiUrl =
            "${api.service}?categoryIds=$id&zone_ids=$zoneIds&providerIds=$selectedProvider&search=${searchCtrl.text}";
      } else if (selectedProvider.isNotEmpty && selectedRates.isNotEmpty) {
        log("LOG 4");
        apiUrl =
            "${api.service}?categoryIds=$id&zone_ids=$zoneIds&providerIds=$selectedProvider&rating=$selectedRates&search=${searchCtrl.text}";
      } else if (lowerVal != 0 || upperVal != 100) {
        log("LOG 5");
        apiUrl =
            "${api.service}?categoryIds=$id&min=${lowerVal.round()}&max${upperVal.round()}&zone_ids=$zoneIds"; /* &zone_ids=$zoneIds */
      } else if (isSelect != null && !isSelect!) {
        log("LOG 6");
        apiUrl =
            "${api.service}?categoryIds=$id&zone_ids=$zoneIds&distance=$slider&search=${searchCtrl.text}";
      } else if (lowerVal != 0 &&
          upperVal != 100 &&
          selectedProvider.isNotEmpty) {
        log("LOG 7");
        apiUrl =
            "${api.service}?categoryIds=$id&min=$lowerVal&max$upperVal&zone_ids=$zoneIds&providerIds=$selectedProvider&search=${searchCtrl.text}";
      } else if (lowerVal != 0 && upperVal != 100 && selectedRates.isNotEmpty) {
        log("LOG 8");
        apiUrl =
            "${api.service}?categoryIds=$id&min=$lowerVal&max$upperVal&zone_ids=$zoneIds&rating=$selectedRates&search=${searchCtrl.text}";
      } else if (lowerVal != 0 &&
          upperVal != 100 &&
          selectedRates.isNotEmpty &&
          selectedProvider.isNotEmpty) {
        log("LOG 9");
        apiUrl =
            "${api.service}?categoryIds=$id&min=$lowerVal&max$upperVal&zone_ids=$zoneIds&rating=$selectedRates&providerIds=$selectedProvider&search=${searchCtrl.text}";
      } else if (lowerVal != 0 &&
          upperVal != 100 &&
          isSelect != null &&
          isSelect!) {
        log("LOG 10");
        apiUrl =
            "${api.service}?categoryIds=$id&min=$lowerVal&max$upperVal&zone_ids=$zoneIds&distance=$slider&search=${searchCtrl.text}";
      } else if (lowerVal != 0 &&
          upperVal != 100 &&
          isSelect != null &&
          isSelect! &&
          selectedRates.isNotEmpty) {
        log("LOG 11");
        apiUrl =
            "${api.service}?categoryIds=$id&min=$lowerVal&max$upperVal&zone_ids=$zoneIds&distance=$slider&rating=$selectedRates&search=${searchCtrl.text}";
      } else if (lowerVal != 0 &&
          upperVal != 100 &&
          isSelect != null &&
          isSelect! &&
          selectedProvider.isNotEmpty) {
        log("LOG 12");
        apiUrl =
            "${api.service}?categoryIds=$id&min=$lowerVal&max$upperVal&zone_ids=$zoneIds&distance=$slider&providerIds=$selectedProvider&search=${searchCtrl.text}";
      } else if (lowerVal != 0 &&
          upperVal != 100 &&
          isSelect != null &&
          isSelect! &&
          selectedProvider.isNotEmpty &&
          selectedRates.isNotEmpty) {
        log("LOG 13");
        apiUrl =
            "${api.service}?categoryIds=$id&min=$lowerVal&max$upperVal&zone_ids=$zoneIds&distance=$slider&providerIds=$selectedProvider&rating=$selectedRates&search=${searchCtrl.text}";
      } else {
        log("LOG 14");
        apiUrl =
            "${api.service}?categoryIds=$id&zone_ids=$zoneIds&search=${searchCtrl.text}";
      }
      log("URRR L: $apiUrl");
      await apiServices.getApi(apiUrl, []).then((value) {
        if (value.isSuccess!) {
          isLoader = false;
          List dataList = value.data;
          serviceList = [];
          notifyListeners();
          log("serviceListserviceList;${serviceList.length}");
          if (dataList.isNotEmpty) {
            for (var data in value.data) {
              Services services = Services.fromJson(data);
              if (!serviceList.contains(services)) {
                serviceList.add(services);
              }
              log("message======> $serviceList");
              if (services.price! > maxPrice) {
                maxPrice = services.price!;
                log(" a :::::::$maxPrice");
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

            upperVal = maxPrice;
            notifyListeners();
          } else {
            isLoader = false;
            maxPrice = 100.0;
            upperVal = 100.0;

            notifyListeners();
          }
          notifyListeners();
        } else {
          maxPrice = 100.0;
          upperVal = 100.0;

          notifyListeners();
        }

        notifyListeners();
      });
    } catch (e, s) {
      isLoader = false;
      maxPrice = 100.0;
      upperVal = 100.0;
      log("ERRROEEE getServiceByCategoryId $e ==> $s");
      notifyListeners();
    }
  }

  bool isAlert = false;
  getServiceById(context, serviceId) async {
    isAlert = true;
    notifyListeners();
    try {
      await apiServices
          .getApi("${api.service}?serviceId=$serviceId", []).then((value) {
        if (value.isSuccess!) {
          isAlert = false;
          services = Services.fromJson(value.data[0]);
          notifyListeners();
        }
        route.pushNamed(context, routeName.servicesDetailsScreen,
            arg: {'services': services!});
      });
    } catch (e) {
      isAlert = false;
      log("ERRROEEE CATEGORY getServiceById : $e");
      notifyListeners();
    }
  }

  getProviderById(context, id, index, Services service) async {
    final cartCtrl = Provider.of<CartProvider>(context, listen: false);
    if (cartCtrl.cartList
        .where((element) =>
            element.serviceList != null &&
            element.serviceList!.id == service.id)
        .isNotEmpty) {
      cartCtrl.checkout(context);
      route.pushNamed(context, routeName.cartScreen);
    } else {
      try {
        await apiServices
            .getApi("${api.provider}/$id", [], isData: true)
            .then((value) {
          if (value.isSuccess!) {
            ProviderModel providerModel = ProviderModel.fromJson(value.data);
            final providerDetail =
                Provider.of<ProviderDetailsProvider>(context, listen: false);
            providerDetail.selectProviderIndex = 0;
            providerDetail.notifyListeners();
            onBook(context, service,
                provider: providerModel,
                addTap: () => onAdd(index),
                minusTap: () => onRemoveService(context, index)).then((e) {
              serviceList[index].selectedRequiredServiceMan =
                  serviceList[index].requiredServicemen;
              notifyListeners();
            });
            notifyListeners();
          }
        });
      } catch (e) {
        log("ERRROEEE getProviderById gategory detail: $e");
        notifyListeners();
      }
    }
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

    notifyListeners();
  }

  //clear filter
  clearFilter(context, id) {
    selectedProvider = [];
    selectedRates = [];
    lowerVal = 00.0;
    upperVal = maxPrice;
    slider = 0;
    route.pop(context);
    getServiceByCategoryId(context, id);
    notifyListeners();
  }
}
