import 'dart:developer';

import 'package:fixit_user/common_tap.dart';
import 'package:fixit_user/config.dart';

class ServicesDetailsProvider with ChangeNotifier {
  int selectedIndex = 0, selected = -1;
  bool isBottom = true;
  int? serviceId;
  ScrollController scrollController = ScrollController();
  double widget1Opacity = 0.0;
  Services? service;
  List<ServiceFaqModel> serviceFaq = [];
  List<AdditionalServices> additionalService = [];

  onImageChange(index) {
    selectedIndex = index;
    notifyListeners();
  }

  bool isContain(id) =>
      additionalService.where((element) => element.id == id).isNotEmpty;

  addAdditionalService(AdditionalServices data) {
    int index =
        additionalService.indexWhere((element) => element.id == data.id);
    if (index >= 0) {
      additionalService.removeAt(index);
    } else {
      additionalService.add(data);
    }
    notifyListeners();
  }

  onReady(context) async {
    widget1Opacity = 1;
    scrollController.addListener(listen);

    notifyListeners();
    dynamic data = ModalRoute.of(context)!.settings.arguments;

    if (data['serviceId'] != null) {
      getServiceById(context, data['serviceId']);
    } else {
      service = data['services'];
      notifyListeners();
      getServiceById(context, service!.id);
      getServiceFaqId(context, service!.id);
    }
    notifyListeners();
    /*  Future.delayed(const Duration(milliseconds: 500), () {
      widget1Opacity = 1;
      notifyListeners();
    }); */
    notifyListeners();
  }

  onRefresh(context) async {
    showLoading(context);
    notifyListeners();
    await getServiceById(context, service!.id);
    await getServiceFaqId(context, service!.id);

    notifyListeners();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  onExpansionChange(newState, index) {
    log("dghfdkg:$newState");
    if (newState) {
      const Duration(seconds: 20000);
      selected = index;
      notifyListeners();
    } else {
      selected = -1;
      notifyListeners();
    }
  }

  void listen() {
    if (scrollController.position.pixels >= 200) {
      hide();
      notifyListeners();
    } else {
      show();
      notifyListeners();
    }
  }

  void show() {
    if (!isBottom) {
      isBottom = true;
      notifyListeners();
    }
    notifyListeners();
  }

  void hide() {
    if (isBottom) {
      isBottom = false;
      notifyListeners();
    }
    notifyListeners();
  }

  onBack(context, isBack) {
    service = null;
    serviceFaq = [];
    selectedIndex = 0;
    serviceId = 0;
    widget1Opacity = 0.0;
    notifyListeners();
    log("djhfkf :$service");
    if (isBack) {
      // route.pop(context);
      route.pop(context);
    } else {
      log("back else");
      route.pop(context);
      route.pop(context);
    }
  }

  bool isLoading = false;
  getServiceById(context, serviceId) async {
    isLoading = true;
    try {
      await apiServices
          .getApi("${api.service}?serviceId=$serviceId", []).then((value) {
        if (value.isSuccess!) {
          service = Services.fromJson(value.data[0]);
          hideLoading(context);
          isLoading = false;
          notifyListeners();
        } else {
          hideLoading(context);
          isLoading = false;
          notifyListeners();
        }
      });
    } catch (e) {
      log("ERRROEEE SERVICE getServiceById : $e");
      isLoading = false;
      hideLoading(context);
      notifyListeners();
    }
  }

  getServiceFaqId(context, serviceId) async {
    try {
      await apiServices
          .getApi("${api.serviceFaq}?service_id=$serviceId", [],
              isData: true, isMessage: false)
          .then((value) {
        if (value.isSuccess!) {
          serviceFaq.clear();
          for (var d in value.data) {
            if (!serviceFaq.contains(ServiceFaqModel.fromJson(d))) {
              serviceFaq.add(ServiceFaqModel.fromJson(d));
            }
          }
          log("serviceFaq :${serviceFaq.length}");
          hideLoading(context);
          notifyListeners();
        } else {
          hideLoading(context);
          notifyListeners();
        }
      });
    } catch (e, s) {
      log("ERRROEEE getServiceFaqId : $e===> $s");
      hideLoading(context);
      notifyListeners();
    }
  }

  onFeatured(context, Services? services, id) async {
    final providerDetail =
        Provider.of<ProviderDetailsProvider>(context, listen: false);
    providerDetail.selectProviderIndex = 0;
    providerDetail.notifyListeners();
    onBook(context, services!,
        addTap: () => onAdd(id: id),
        minusTap: () => onRemoveService(context, id: id)).then((e) {
      service!.relatedServices![id].selectedRequiredServiceMan =
          service!.relatedServices![id].requiredServicemen;
      notifyListeners();
    });
  }

  onRemoveService(context, {id}) async {
    if (id != null) {
      if ((service!.relatedServices![id].selectedRequiredServiceMan!) == 1) {
        route.pop(context);
        isAlert = false;
        notifyListeners();
      } else {
        if ((service!.relatedServices![id].requiredServicemen!) ==
            (service!.relatedServices![id].selectedRequiredServiceMan!)) {
          isAlert = true;
          notifyListeners();
          await Future.delayed(DurationClass.s3);
          isAlert = false;
          notifyListeners();
        } else {
          isAlert = false;
          notifyListeners();
          service!.relatedServices![id].selectedRequiredServiceMan =
              ((service!.relatedServices![id].selectedRequiredServiceMan!) - 1);
        }
      }
    } else {
      if ((service!.selectedRequiredServiceMan!) == 1) {
        route.pop(context);
        isAlert = false;
        notifyListeners();
      } else {
        if ((service!.requiredServicemen!) ==
            (service!.selectedRequiredServiceMan!)) {
          isAlert = true;
          notifyListeners();
          await Future.delayed(DurationClass.s3);
          isAlert = false;
          notifyListeners();
        } else {
          isAlert = false;
          notifyListeners();
          service!.selectedRequiredServiceMan =
              ((service!.selectedRequiredServiceMan!) - 1);
        }
      }
    }
    notifyListeners();
  }

  onAdd({id}) {
    isAlert = false;
    notifyListeners();
    if (id != null) {
      int count = (service!.relatedServices![id].selectedRequiredServiceMan!);
      count++;
      service!.relatedServices![id].selectedRequiredServiceMan = count;
    } else {
      int count = (service!.selectedRequiredServiceMan!);
      count++;
      service!.selectedRequiredServiceMan = count;
    }
    notifyListeners();
  }
}
