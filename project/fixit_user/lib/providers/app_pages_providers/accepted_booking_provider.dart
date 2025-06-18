import 'dart:developer';

import 'package:fixit_user/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/status_booking_model.dart';

class AcceptedBookingProvider with ChangeNotifier {
  List<StatusBookingModel> acceptedStatusList = [];
  BookingModel? booking;
  final FocusNode searchFocus = FocusNode();
  TextEditingController reasonCtrl = TextEditingController();

  onReady(context) {
    dynamic arg = ModalRoute.of(context)!.settings.arguments;

    if (arg['bookingId'] != null) {
      getBookingDetailBy(context, id: arg['bookingId']);
    } else {
      booking = arg['booking'];
      notifyListeners();
      getBookingDetailBy(context);
    }
  }

  onBack(context, isBack) {
    booking = null;
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
  }

  onStart(context) {
    showDialog(
        context: context,
        builder: (context1) {
          return AlertDialogCommon(
              title: translations!.startService,
              image: eGifAssets.restart,
              subtext: translations!.areYouSureBeing,
              bText1: translations!.startService,
              height: Sizes.s145,
              isBooked: true,
              widget: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(eImageAssets.restartBg,
                          width: Sizes.s150)),
                  Image.asset(
                    eGifAssets.restart,
                    height: Sizes.s137,
                  ),
                ],
              ).height(Sizes.s150).paddingOnly(bottom: Insets.i20).decorated(
                  color: appColor(context).fieldCardBg,
                  borderRadius: BorderRadius.circular(AppRadius.r10)),
              b1OnTap: () {
                route.pop(context);
                if (booking!.service!.type == "remotely") {
                  chatAndUpdateStatus(context);
                } else {
                  updateStatus(context);
                }
              });
        });
  }

  chatAndUpdateStatus(context) {
    updateStatus(context);
    route.pushNamed(context, routeName.chatScreen, arg: {
      "image": booking!.servicemen![0].media != null &&
              booking!.servicemen![0].media!.isNotEmpty
          ? booking!.servicemen![0].media![0].originalUrl!
          : "",
      "name": booking!.servicemen![0].name,
      "role": "serviceman",
      "userId": booking!.servicemen![0].id,
      "token": booking!.servicemen![0].fcmToken,
      "phone": booking!.servicemen![0].phone,
      "code": booking!.servicemen![0].code,
      "bookingId": booking!.id
    }).then((e) {
      route.pop(context);
      route.pop(context);
    });
  }

  onCancelBooking(context) {
    showDialog(
        context: context,
        builder: (context1) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppRadius.r14))),
            backgroundColor: appColor(context).whiteBg,
            content: Stack(alignment: Alignment.topRight, children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(language(context, translations!.reason),
                        style: appCss.dmDenseMedium14
                            .textColor(appColor(context).darkText)),
                    const VSpace(Sizes.s8),
                    TextFieldCommon(
                        controller: reasonCtrl,
                        focusNode: searchFocus,
                        hintText: translations!.writeHere,
                        maxLines: 4,
                        minLines: 4,
                        fillColor: appColor(context).fieldCardBg),
                    // Sub text
                    const VSpace(Sizes.s15),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(language(context, "\u2022"),
                              style: appCss.dmDenseMedium14
                                  .textColor(appColor(context).lightText)),
                          const HSpace(Sizes.s10),
                          Expanded(
                              child: RichText(
                                  text: TextSpan(
                                      style: appCss.dmDenseMedium14.textColor(
                                          appColor(context).lightText),
                                      text: language(
                                          context, translations!.pleaseReadThe),
                                      children: [
                                TextSpan(
                                    style: TextStyle(
                                        color: appColor(context).darkText,
                                        fontFamily:
                                            GoogleFonts.dmSans().fontFamily,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline),
                                    text: language(context,
                                        translations!.cancellationPolicy)),
                                TextSpan(
                                    style: appCss.dmDenseMedium14
                                        .textColor(appColor(context).lightText),
                                    text: language(context,
                                        translations!.beforeCancelling))
                              ])))
                        ]),
                    const VSpace(Sizes.s20),
                    ButtonCommon(
                        /*onTap: ()=>updateStatus(context,isCancel: true),*/
                        color: reasonCtrl.text.isNotEmpty
                            ? appColor(context).primary
                            : appColor(context).primary.withOpacity(0.10),
                        borderColor: reasonCtrl.text.isNotEmpty
                            ? appColor(context).primary
                            : appColor(context).primary.withOpacity(0.10),
                        fontColor: reasonCtrl.text.isNotEmpty
                            ? appColor(context).whiteColor
                            : appColor(context).primary,
                        onTap: () {
                          if (reasonCtrl.text.isNotEmpty) {
                            updateStatus(context, isCancel: true);
                          } else {
                            Fluttertoast.showToast(msg: "Please Enter reason");
                          }
                        },
                        title: translations!.submit)
                  ]).padding(
                  horizontal: Insets.i20, top: Insets.i60, bottom: Insets.i20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                // Title
                Text(language(context, translations!.reasonOfCancelBooking),
                    style: appCss.dmDenseExtraBold16
                        .textColor(appColor(context).darkText)),
                Icon(CupertinoIcons.multiply,
                        size: Sizes.s20, color: appColor(context).darkText)
                    .inkWell(onTap: () => route.pop(context))
              ]).paddingAll(Insets.i20)
            ])));
  }

  //booking detail by id
  getBookingDetailBy(context, {id}) async {
    try {
      await apiServices
          .getApi("${api.booking}/${id ?? booking!.id}", [],
              isToken: true, isData: true)
          .then((value) {
        debugPrint("BOOKING DATA : ${value.data}");

        if (value.isSuccess!) {
          booking = BookingModel.fromJson(value.data);
          notifyListeners();
        }
      });
      log("STATYS L $booking");
    } catch (e) {
      notifyListeners();
    }
  }

  onRefresh(context) async {
    showLoading(context);
    notifyListeners();
    await getBookingDetailBy(context);
    hideLoading(context);
    notifyListeners();
  }

  completeSuccess(context) {
    showCupertinoDialog(
      context: context,
      builder: (context1) {
        return AlertDialogCommon(
          title: translations!.successfullyDelete,
          height: Sizes.s140,
          image: eGifAssets.successGif,
          subtext: language(context, translations!.cancelBookingSuccessfully),
          bText1: language(context, translations!.okay),
          b1OnTap: () {
            route.pop(context);
            route.pop(context);
            route.pushNamed(context, routeName.cancelledServiceScreen,
                arg: {"booking": booking!}).then((e) {
              log("CHEC");
              route.pushNamedAndRemoveUntil(context, routeName.dashboard);
              final dash =
                  Provider.of<DashboardProvider>(context, listen: false);
              dash.selectIndex = 1;
              dash.notifyListeners();
            });
          },
        );
      },
    );
  }

  //update status
  updateStatus(context, {isCancel = false}) async {
    try {
      showLoading(context);
      notifyListeners();
      dynamic data;
      if (isCancel) {
        route.pop(context);
        data = {
          "reason": reasonCtrl.text,
          "booking_status": translations!.cancel
        };
      } else {
        data = {"booking_status": appFonts.onGoing};
      }
      await apiServices
          .putApi("${api.booking}/${booking!.id}", data,
              isToken: true, isData: true)
          .then((value) {
        hideLoading(context);
        notifyListeners();
        reasonCtrl.text = "";
        if (value.isSuccess!) {
          debugPrint("BOOKING DATA : ${value.data}");
          booking = BookingModel.fromJson(value.data);
          if (isCancel) {
            completeSuccess(context);
          }
          notifyListeners();
        }
      });
      hideLoading(context);
      notifyListeners();
    } catch (e) {
      hideLoading(context);
      notifyListeners();
    }
  }

  checkForCancelButtonShow() {
    bool isShow = false;

    DateTime now = DateTime.now();
    DateTime bookDate = DateTime.parse(booking!.dateTime!);
    Duration duration = now.difference(bookDate);
    isShow = duration.inHours <
        int.parse(appSettingModel!.general!.cancellationRestrictionHours!);
    return isShow;
  }
}
