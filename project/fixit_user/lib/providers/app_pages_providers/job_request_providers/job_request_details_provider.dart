import 'dart:developer';

import 'package:fixit_user/common_tap.dart';
import 'package:fixit_user/config.dart';
import 'package:fixit_user/screens/app_pages_screens/custom_job_request/add_job_request/layouts/accept_provider_confirmation.dart';

class JobRequestDetailsProvider with ChangeNotifier {
  int selectedIndex = 0, selected = -1;
  bool isBottom = true;
  int? serviceId;
  ScrollController scrollController = ScrollController();
  double widget1Opacity = 0.0;
  JobRequestModel? service;

  onImageChange(index) {
    selectedIndex = index;
    notifyListeners();
  }

  onReady(context) async {
    scrollController.addListener(listen);

    notifyListeners();
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    log("service :${data['serviceId'] }");
    if (data['serviceId'] != null) {
      getServiceById(context, data['serviceId']);
    } else {
      service = data['services'];
      notifyListeners();
      getServiceById(context, service!.id);
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      widget1Opacity = 1;
      notifyListeners();
    });
    notifyListeners();
  }

  onRefresh(context) async {
    showLoading(context);
    notifyListeners();
    await getServiceById(context, service!.id);

    hideLoading(context);
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
    selectedIndex = 0;

    serviceId = 0;
    widget1Opacity = 0.0;
    notifyListeners();
    log("djhfkf :$service");
    if (isBack) {
      route.pop(context);
    }
  }

  getServiceById(context, serviceId) async {
    try {
      await apiServices
          .getApi("${api.serviceRequest}/$serviceId", [], isToken: true,isData: true)
          .then((value) {
            log("VV l :${value.isSuccess} || ${value.data}");
        if (value.isSuccess!) {
          service = JobRequestModel.fromJson(value.data);

          log("service!.status :${service!.service}");
          notifyListeners();
        } else {
          notifyListeners();
        }
      });
    } catch (e) {
      log("ERRROEEE JOB getServiceById : $e");
      notifyListeners();
    }
  }

  acceptProvider(context, ProviderModel provider, bid) {
    // log("message::::$bid");
    showDialog(
        context: context,
        builder: (BuildContext context1) {
          return AcceptProviderConfirmation(
              provider: provider,
              accept: () {
                acceptRejectBid(context, bid);
                log("message::::$bid");
              });
        });
  }

//update status
  acceptRejectBid(context, bid, {isCancel = false}) async {
    try {
      showLoading(context);
      notifyListeners();
      dynamic data;
      if (!isCancel) {
        route.pop(context);
      }
      log("value:${service!.id}");
      data = {"status": isCancel ? "rejected" : "accepted"};
      await apiServices
          .putApi("${api.bid}/$bid", data, isToken: true, isData: true)
          .then((value) {
        log("value :${value.isSuccess}");
        hideLoading(context);
        notifyListeners();
        if (value.isSuccess!) {
          debugPrint("BID DATA : ${value.data['service']}");
          getServiceById(context, service!.id);
          notifyListeners();
        }
      });
      hideLoading(context);
      notifyListeners();
    } catch (e) {
      log("SSS :${e.toString()}");
      hideLoading(context);
      notifyListeners();
    }
  }

  bookService(context) {
    onBook(context, service!.service!,
            addTap: () => onAdd(context, service!.serviceId!),
            minusTap: () => onRemoveService(context, service!.serviceId!))!
        .then((e) {
      service!.service!.selectedRequiredServiceMan =
          service!.service!.requiredServicemen;
      notifyListeners();
    });
  }

  onAdd(context, index) {
    isAlert = false;
    notifyListeners();
    int count = (service!.service!.selectedRequiredServiceMan!);
    count++;
    service!.service!.selectedRequiredServiceMan = count;

    notifyListeners();
  }

  onRemoveService(context, index, {isSearch = false}) async {
    if ((service!.service!.requiredServicemen!) ==
        (service!.service!.selectedRequiredServiceMan!)) {
      isAlert = true;
      notifyListeners();
      await Future.delayed(DurationClass.s3);
      isAlert = false;
      notifyListeners();
    } else {
      isAlert = false;
      notifyListeners();
      service!.service!.selectedRequiredServiceMan =
          ((service!.service!.selectedRequiredServiceMan!) - 1);
    }

    notifyListeners();
  }
}
