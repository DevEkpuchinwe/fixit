import 'dart:developer';

import 'package:fixit_user/config.dart';
import 'package:fixit_user/screens/app_pages_screens/app_details_screen/layouts/page_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/status_booking_model.dart';

class PendingBookingProvider with ChangeNotifier {
  List<StatusBookingModel> pendingBookingList = [];
  StatusBookingModel? statusModel;
  BookingModel? booking;
  final FocusNode searchFocus = FocusNode();

  TextEditingController reasonCtrl = TextEditingController();

  onReady(context) async {
    dynamic arg = ModalRoute.of(context)!.settings.arguments;
    await Future.delayed(Durations.long1);
    log("ATG ;:$arg");
    if (arg['bookingId'] != null) {
      getBookingDetailById(context, id: arg['bookingId']);
    } else {
      booking = arg["booking"];
      notifyListeners();
      getBookingDetailById(context);
    }
  }

  onBack(context, isBack) {
    // booking = null;
    notifyListeners();
    if (isBack) {
      route.pop(context);
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

  onCancelBooking(context) {
    final appDetails = Provider.of<AppDetailsProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (context1) =>
            Consumer<PendingBookingProvider>(builder: (context2, value, child) {
              return AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  insetPadding:
                      const EdgeInsets.symmetric(horizontal: Insets.i20),
                  shape: const SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius.all(SmoothRadius(
                          cornerRadius: AppRadius.r14, cornerSmoothing: 1))),
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
                              isNumber: true,
                              hintText: translations!.writeHere,
                              maxLines: 4,
                              onChanged: (v) {
                                notifyListeners();
                              },
                              minLines: 4,
                              fillColor: appColor(context).fieldCardBg),
                          // Sub text
                          const VSpace(Sizes.s15),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(language(context, "\u2022"),
                                    style: appCss.dmDenseMedium14.textColor(
                                        appColor(context).lightText)),
                                const HSpace(Sizes.s10),
                                Expanded(
                                    child: RichText(
                                        text: TextSpan(
                                            style: appCss.dmDenseMedium14
                                                .textColor(appColor(context)
                                                    .lightText),
                                            text: language(context,
                                                translations!.pleaseReadThe),
                                            children: [
                                      TextSpan(
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              appDetails.pageList
                                                  .asMap()
                                                  .entries
                                                  .map((e) {
                                                e.value.title ==
                                                        language(
                                                            context,
                                                            translations!
                                                                .cancellationPolicy)
                                                    ? route.push(
                                                        context,
                                                        PageDetail(
                                                          page: e.value,
                                                        ))
                                                    : null;
                                              }).toList();
                                            },
                                          style: TextStyle(
                                              color: appColor(context).darkText,
                                              fontFamily: GoogleFonts.dmSans()
                                                  .fontFamily,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              decoration:
                                                  TextDecoration.underline),
                                          text: language(
                                              context,
                                              translations!
                                                  .cancellationPolicy)),
                                      TextSpan(
                                          style: appCss.dmDenseMedium14
                                              .textColor(
                                                  appColor(context).lightText),
                                          text: language(context,
                                              translations!.beforeCancelling))
                                    ])))
                              ]),
                          const VSpace(Sizes.s20),
                          ButtonCommon(
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
                                  Fluttertoast.showToast(
                                      msg: "Please Enter reason");
                                }
                              },
                              title: translations!.submit)
                        ]).padding(
                        horizontal: Insets.i20,
                        top: Insets.i60,
                        bottom: Insets.i20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title
                          Text(
                              language(
                                  context, translations!.reasonOfCancelBooking),
                              style: appCss.dmDenseExtraBold16
                                  .textColor(appColor(context).darkText)),
                          Icon(CupertinoIcons.multiply,
                                  size: Sizes.s20,
                                  color: appColor(context).darkText)
                              .inkWell(onTap: () => route.pop(context))
                        ]).paddingAll(Insets.i20)
                  ]));
            })).then((value) {
      reasonCtrl.text = "";
      notifyListeners();
    });
  }

  completeSuccess(
    context,
  ) {
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

  //booking detail by id
  getBookingDetailById(context, {id}) async {
    try {
      await apiServices
          .getApi("${api.booking}/${id ?? booking!.id}", [],
              isToken: true, isData: true)
          .then((value) {
        if (value.isSuccess!) {
          debugPrint("BOOKING DATA : ${value.data}");
          booking = BookingModel.fromJson(value.data);
          notifyListeners();
        }
      });

      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  onRefresh(context) async {
    showLoading(context);
    notifyListeners();
    await getBookingDetailById(context);
    hideLoading(context);
    notifyListeners();
  }

  //update status
  bool isCancel = false;
  updateStatus(context, {isCancel = false}) async {
    try {
      isCancel = true;
      showLoading(context);
      notifyListeners();
      dynamic data;
      if (isCancel) {
        route.pop(context);

        data = {"reason": reasonCtrl.text, "booking_status": "cancel"};
      } else {
        data = {"booking_status": "cancel"};
      }
      log("=============>$data");
      await apiServices
          .putApi("${api.booking}/${booking!.id}", data,
              isToken: true, isData: true)
          .then((value) {
        hideLoading(context);
        notifyListeners();
        reasonCtrl.text = "";
        if (value.isSuccess!) {
          isCancel = false;
          log("STATYS L ${value.isSuccess}");
          booking = BookingModel.fromJson(value.data);
          completeSuccess(context);
          notifyListeners();
        }
      });
      hideLoading(context);
      log("STATYS L $booking");
      notifyListeners();
    } catch (e) {
      isCancel = false;
      hideLoading(context);
      notifyListeners();
    }
  }
}
