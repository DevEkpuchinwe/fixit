import 'dart:developer';

import 'package:fixit_provider/config.dart';

class AcceptedBookingProvider with ChangeNotifier {
  BookingModel? bookingModel;
  int selectIndex = 0;
  List statusList = [];
  String amount = "0", id = '';
  bool? isAssign = false;

  TextEditingController amountCtrl = TextEditingController();

  FocusNode amountFocus = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  onReady(context) {
    selectIndex = 0;
    dynamic data = ModalRoute.of(context)!.settings.arguments ?? "";
    log("messageData:${data}");
    if (isFreelancer != true) {
      /*       if(data != ""){
          amount = data["amount"] ?? "0";
          isAssign = data["assign_me"] ?? false;
        }*/
    }

    id = data.toString();
    log("ididid:$isFreelancer");
    notifyListeners();
    getBookingDetailById(context, id);
  }

  onServicemenChange(index) {
    selectIndex = index;
    notifyListeners();
  }

  onAssignTap(context) {
    try {
      if (isFreelancer) {
        // Show dialog for freelancer case
        showDialog(
            context: context,
            builder: (context1) => AppAlertDialogCommon(
                height: Sizes.s145,
                title: translations!.assignToMe,
                firstBText: translations!.cancel,
                secondBText: translations!.yes,
                image: eImageAssets.assignMe,
                subtext: translations!.areYouSureYourself,
                secondBTap: () {
                  assignServiceman(context, [userModel!.id]);
                },
                firstBTap: () {
                  log("accepted booking cancel");
                }));
      } else {
        // Ensure valid totalServicemen count
        int totalServicemen = (bookingModel?.totalExtraServicemen ?? 0) +
            (bookingModel?.requiredServicemen ?? 1);
        log("DDDD ${totalServicemen > 1 || (bookingModel!.requiredServicemen ?? 1) == 1}");
        if (totalServicemen > 1) {
          log("DDDD $bookingModel!.requiredServicemen");
          route.pushNamed(context, routeName.bookingServicemenList, arg: {
            "servicemen": totalServicemen,
            "data": bookingModel
          }).then((e) {
            log("hgghjg:$e");
            if (e != null) {
              List<ServicemanModel> serMan = e;
              List ids = [];
              for (var d in serMan) {
                ids.add(d.id);
              }
              log("SSS :$ids");
              assignServiceman(context, ids);
            }
          });
        } else {
          log("bookingModel!.requiredServicemen::$totalServicemen");
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context1) {
                return SelectServicemenSheet(arguments: totalServicemen);
              });
        }
      }
    } catch (e) {
      log("Error in onAssignTap: $e");
    }
  }

  onTapContinue(context, arguments) {
    if (selectIndex == 0) {
      showDialog(
          context: context,
          builder: (context1) => AppAlertDialogCommon(
              height: Sizes.s145,
              title: translations!.assignToMe,
              firstBText: translations!.cancel,
              secondBText: translations!.yes,
              image: eImageAssets.assignMe,
              subtext: translations!.areYouSureYourself,
              secondBTap: () {
                assignServiceman(context, [userModel!.id]);
              },
              firstBTap: () {
                route.pop(context);
                route.pop(context);
              }));
    } else {
      log("ARGSSSSMGVHF $arguments");
      route.pushNamed(context, routeName.bookingServicemenList,
          arg: {"servicemen": arguments, "data": bookingModel!}).then((e) {
        log("ee onTapContinue:$bookingModel");
        if (e != null) {
          List<ServicemanModel> serMan = e;
          List ids = [];
          for (var d in serMan) {
            ids.add(d.id);
          }

          log("SSS :$ids");
          assignServiceman(context, ids);
        }
      });
    }
  }

  //assign serviceman

  bool isAssignServiceman = false;
  assignServiceman(context, List val, {isDirectBack = false}) async {
    // route.pop(context);
    // route.pushNamed(context, routeName.assignBooking, arg: bookingModel!.id);
    try {
      isAssignServiceman = true;
      await getBookingDetailById(context, id);
      showLoading(context);
      notifyListeners();
      var body = {"booking_id": bookingModel!.id, "servicemen_ids": val};
      log("ASSSIGN BODY : $body");
      await apiServices
          .postApi(api.assignBooking, body, isToken: true)
          .then((value) {
        hideLoading(context);

        notifyListeners();
        if (value.isSuccess!) {
          final common =
              Provider.of<UserDataApiProvider>(context, listen: false);
          common.loadBookingsFromLocal(context);
          isAssignServiceman = false;
          if (isDirectBack) {
            BookingModel book = bookingModel!;
            route.pop(context);
            hideLoading(context);
            route.pushNamed(context, routeName.assignBooking, arg: book.id);
          } else {
            isAssignServiceman = false;
            BookingModel book = bookingModel!;
            if (selectIndex == 0) {
              Future.delayed(const Duration(milliseconds: 150)).then(
                (value) {
                  route.pop(context);
                  hideLoading(context);
                  route.pushNamed(context, routeName.assignBooking,
                      arg: book.id);
                  log("selectIndex::$selectIndex");
                },
              );
              // route.pop(context);
            } else {
              isAssignServiceman = false;
              hideLoading(context);
              Future.delayed(const Duration(milliseconds: 150)).then((value) {
                route.pop(context);
                route.pop(context);
                log("selectIndex::fdlopsf[");
              });
            }
          }
        } else {
          isAssignServiceman = false;
          hideLoading(context);
          route.pop(context);
          route.pop(context);
          snackBarMessengers(context,
              color: appColor(context).appTheme.red, message: value.message);
        }
      });
    } catch (e) {
      isAssignServiceman = false;
      hideLoading(context);
      notifyListeners();
      log("EEEE assignServiceman Accepted : $e");
    }
  }

  onBack(context, isBack) {
    // bookingModel = null;
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
  }

  onRefresh(context) async {
    showLoading(context);
    notifyListeners();
    await getBookingDetailById(context, bookingModel!.id);
    hideLoading(context);
    notifyListeners();
  }

  //booking detail by id
  getBookingDetailById(context, id) async {
    try {
      await apiServices
          .getApi("${api.booking}/$id", [], isToken: true, isData: true)
          .then((value) {
        if (value.isSuccess!) {
          // log("DHRUVU :${value.data}");
          notifyListeners();
          bookingModel = BookingModel.fromJson(value.data);
          notifyListeners();
        } else {
          notifyListeners();
        }
      });
    } catch (e) {
      notifyListeners();
    }
  }
}
