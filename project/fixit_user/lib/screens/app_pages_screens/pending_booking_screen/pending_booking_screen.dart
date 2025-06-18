import 'package:fixit_user/screens/bottom_screens/booking_screen/booking_shimmer/booking_detail_shimmer.dart';

import '../../../common_tap.dart';
import '../../../config.dart';

class PendingBookingScreen extends StatelessWidget {
  const PendingBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PendingBookingProvider>(builder: (context1, value, child) {
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          value.onBack(context, false);
          if (didPop) return;
        },
        child: StatefulWrapper(
          onInit: () => Future.delayed(
              const Duration(milliseconds: 100), () => value.onReady(context)),
          child: value.booking == null
              ? const BookingDetailShimmer()
              : Scaffold(
                  // bottomNavigationBar: value.booking!.bookingStatus!.slug !=
                  //         translations!.cancel
                  //     ? value.checkForCancelButtonShow()
                  //         ? ButtonCommon(
                  //                 title: translations!.cancelBooking,
                  //                 onTap: () => value.onCancelBooking(context))
                  //             .paddingOnly(
                  //                 top: Insets.i10,
                  //                 bottom: Insets.i30,
                  //                 left: Insets.i20,
                  //                 right: Insets.i20)
                  //         : null
                  //     : null,
                  appBar: AppBarCommon(
                      title: translations!.pendingBooking,
                      onTap: () => value.onBack(context, true)),
                  body: RefreshIndicator(
                    onRefresh: () async {
                      value.onRefresh(context);
                    },
                    child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          StatusDetailLayout(
                              data: value.booking,
                              onTapStatus: () =>
                                  showBookingStatus(context, value.booking)),
                          /* if (value.booking!.service!.reviews!.isNotEmpty)
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                          language(context,
                                              translations!.review),
                                          overflow: TextOverflow.clip,
                                          style: appCss.dmDenseSemiBold14
                                              .textColor(appColor(context)
                                                  .darkText))),
                                  Text(
                                          language(context,
                                              translations!.viewAll),
                                          style: appCss.dmDenseRegular14
                                              .textColor(appColor(context)
                                                  .primary))
                                      .inkWell(
                                          onTap: () => route.pushNamed(
                                              context,
                                              routeName
                                                  .servicesReviewScreen,
                                              arg: value.booking!.service))
                                ]).paddingOnly(
                                top: Insets.i20, bottom: Insets.i12), */
                          ...value.booking!.service!.reviews!
                              .asMap()
                              .entries
                              .map((e) => ServiceReviewLayout(
                                  data: e.value,
                                  index: e.key,
                                  list: appArray.reviewList)),
                          Text(language(context, translations!.billSummary),
                                  style: appCss.dmDenseSemiBold14
                                      .textColor(appColor(context).darkText))
                              .paddingOnly(top: Insets.i15, bottom: Insets.i10),
                          Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(isDark(context)
                                          ? eImageAssets.pendingBillBgDark
                                          : eImageAssets.pendingBillBg),
                                      fit: BoxFit.fill)),
                              child: Column(children: [
                                BillRowCommon(
                                    title: translations!.perServiceCharge,
                                    price:
                                        "${getSymbol(context)}${(currency(context).currencyVal * value.booking!.perServicemanCharge!).ceilToDouble()}"),
                                BillRowCommon(
                                        title:
                                            "${((value.booking!.requiredServicemen ?? 1) + (value.booking!.totalExtraServicemen != null ? (value.booking!.totalExtraServicemen ?? 1) : 0))} ${language(context, translations!.serviceman)}",
                                        price:
                                            "${getSymbol(context)}${(currency(context).currencyVal * value.booking!.subtotal!).ceilToDouble()}",
                                        style: appCss.dmDenseBold14.textColor(
                                            appColor(context).darkText))
                                    .paddingSymmetric(vertical: Insets.i20),
                                BillRowCommon(
                                    title: translations!.tax,
                                    price:
                                        "+${getSymbol(context)}${(currency(context).currencyVal * value.booking!.tax!).ceilToDouble()}",
                                    color: appColor(context).online),
                                BillRowCommon(
                                        title: translations!.platformFees,
                                        price:
                                            "+${getSymbol(context)}${(currency(context).currencyVal * (value.booking!.platformFees ?? 0.0)).ceilToDouble()}",
                                        color: appColor(context).online)
                                    .paddingSymmetric(vertical: Insets.i20),
                                Divider(
                                        color: appColor(context).stroke,
                                        thickness: 1,
                                        height: 1,
                                        indent: 6,
                                        endIndent: 6)
                                    .paddingOnly(bottom: 23),
                                BillRowCommon(
                                    title: translations!.totalAmount,
                                    price:
                                        "${getSymbol(context)}${(currency(context).currencyVal * value.booking!.total!).ceilToDouble()}",
                                    styleTitle: appCss.dmDenseMedium14
                                        .textColor(appColor(context).darkText),
                                    style: appCss.dmDenseBold16
                                        .textColor(appColor(context).primary)),
                              ]).paddingSymmetric(vertical: Insets.i20)),
                          if (value.booking!.bookingStatus!.slug !=
                              translations!.cancel)
                            if (value.checkForCancelButtonShow())
                              ButtonCommon(
                                      title: translations!.cancelBooking,
                                      onTap: value.isCancel
                                          ? () {
                                              print(
                                                  "object=-=-=-=-=-=-=-=-=-=-=-=-");
                                            }
                                          : () =>
                                              value.onCancelBooking(context))
                                  .paddingOnly(
                                      top: Insets.i35, bottom: Insets.i30),
                          // if (value.checkForCancelButtonShow() == false)
                          //   SizedBox(
                          //     width: MediaQuery.of(context).size.width,
                          //     child: Row(
                          //         mainAxisSize: MainAxisSize.min,
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Text(
                          //               language(context,
                          //                   "${translations!.status}:"),
                          //               style: appCss.dmDenseMedium14
                          //                   .textColor(appColor(context).red)),
                          //           const HSpace(Sizes.s10),
                          //           Expanded(
                          //               child: Text(
                          //                   language(context,
                          //                       "You can’t cancel this booking shortly before it starts." /* translations!.statusHasNotBeen */),
                          //                   overflow: TextOverflow.fade,
                          //                   style: appCss.dmDenseRegular14
                          //                       .textColor(
                          //                           appColor(context).red)))
                          //         ]).paddingAll(Insets.i15),
                          //   ).boxShapeExtension(
                          //       color: appColor(context).red.withOpacity(0.1))
                        ]).paddingOnly(left: Insets.i20, right: Insets.i20)),
                  )),
        ),
      );
    });
  }
}
