import 'package:fixit_user/common_tap.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../../config.dart';
import '../../bottom_screens/booking_screen/booking_shimmer/booking_detail_shimmer.dart';

class AcceptedBookingScreen extends StatelessWidget {
  const AcceptedBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AcceptedBookingProvider, PendingBookingProvider>(
        builder: (context, val, val2, child) {
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          val.onBack(context, false);
          if (didPop) return;
        },
        child: StatefulWrapper(
            onInit: () => Future.delayed(
                const Duration(milliseconds: 100), () => val.onReady(context)),
            child: val.booking == null
                ? const BookingDetailShimmer()
                : Scaffold(
                    appBar: AppBarCommon(
                        title: translations!.acceptedBookings,
                        onTap: () => val.onBack(context, true)),
                    body: LoadingComponent(
                      child: val.booking == null
                          ? Container()
                          : Stack(
                              children: [
                                RefreshIndicator(
                                  onRefresh: () async {
                                    val.onRefresh(context);
                                  },
                                  child: SingleChildScrollView(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        StatusDetailLayout(
                                            data: val.booking,
                                            onTapStatus: () =>
                                                showBookingStatus(
                                                    context, val.booking)),
                                        Text(
                                                language(context,
                                                    translations!.billSummary),
                                                style: appCss.dmDenseSemiBold14
                                                    .textColor(appColor(context)
                                                        .darkText))
                                            .paddingOnly(
                                                top: Insets.i25,
                                                bottom: Insets.i10),
                                        Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      isDark(context)
                                                          ? eImageAssets
                                                              .pendingBillBgDark
                                                          : eImageAssets
                                                              .pendingBillBg),
                                                  fit: BoxFit.fill)),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    BillRowCommon(
                                                        title: translations!
                                                            .perServiceCharge,
                                                        price:
                                                            "${getSymbol(context)}${(currency(context).currencyVal * val.booking!.perServicemanCharge!).ceilToDouble()}"),
                                                    BillRowCommon(
                                                            title:
                                                                "${((val.booking!.requiredServicemen ?? 1) + (val.booking!.totalExtraServicemen != null ? (val.booking!.totalExtraServicemen ?? 1) : 0))} ${language(context, translations!.serviceman)}",
                                                            price:
                                                                "${getSymbol(context)}${(currency(context).currencyVal * val.booking!.subtotal!).ceilToDouble()}",
                                                            style: appCss
                                                                .dmDenseBold14
                                                                .textColor(appColor(
                                                                        context)
                                                                    .darkText))
                                                        .paddingSymmetric(
                                                            vertical:
                                                                Insets.i20),
                                                    BillRowCommon(
                                                            title: translations!
                                                                .tax,
                                                            price:
                                                                "+${getSymbol(context)}${(currency(context).currencyVal * val.booking!.tax!).ceilToDouble()}",
                                                            color: appColor(
                                                                    context)
                                                                .online)
                                                        .paddingOnly(
                                                            bottom: Insets.i20),
                                                    BillRowCommon(
                                                        title: translations!
                                                            .platformFees,
                                                        price:
                                                            "+${getSymbol(context)}${(currency(context).currencyVal * (val.booking!.platformFees ?? 0.0)).ceilToDouble()}",
                                                        color: appColor(context)
                                                            .online)
                                                  ],
                                                ),
                                                const VSpace(Sizes.s30),
                                                /* Divider(
                                                color: appColor(context).stroke, thickness: 1, height: 1,indent: 6,endIndent: 6).paddingOnly(bottom:23),*/
                                                BillRowCommon(
                                                        title: translations!
                                                            .totalAmount,
                                                        price:
                                                            "${getSymbol(context)}${(currency(context).currencyVal * val.booking!.total!).ceilToDouble()}",
                                                        styleTitle: appCss
                                                            .dmDenseMedium14
                                                            .textColor(appColor(
                                                                    context)
                                                                .darkText),
                                                        style: appCss
                                                            .dmDenseBold16
                                                            .textColor(appColor(
                                                                    context)
                                                                .primary))
                                                    .paddingOnly(
                                                        top: Insets.i10)
                                              ]).paddingSymmetric(
                                              vertical: Insets.i20),
                                        ),
                                        if (val.booking!.service!.reviews!
                                            .isNotEmpty)
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                        language(
                                                            context,
                                                            translations!
                                                                .review),
                                                        overflow:
                                                            TextOverflow.clip,
                                                        style: appCss
                                                            .dmDenseSemiBold14
                                                            .textColor(appColor(
                                                                    context)
                                                                .darkText))),
                                                Text(
                                                        language(
                                                            context,
                                                            translations!
                                                                .viewAll),
                                                        style: appCss
                                                            .dmDenseRegular14
                                                            .textColor(appColor(
                                                                    context)
                                                                .primary))
                                                    .inkWell(
                                                        onTap: () =>
                                                            route.pushNamed(
                                                                context,
                                                                routeName
                                                                    .servicesReviewScreen,
                                                                arg: val
                                                                    .booking!
                                                                    .service))
                                              ]).paddingOnly(
                                              top: Insets.i20,
                                              bottom: Insets.i12),
                                        ...val.booking!.service!.reviews!
                                            .asMap()
                                            .entries
                                            .map((e) => ServiceReviewLayout(
                                                data: e.value,
                                                index: e.key,
                                                list: appArray.reviewList)),
                                        (val.booking!.bookingStatus!.slug ==
                                                    translations!.accepted ||
                                                val.booking!.bookingStatus!
                                                        .slug ==
                                                    translations!.pending)
                                            ? val.checkForCancelButtonShow()
                                                ? ButtonCommon(
                                                        title: translations!
                                                            .cancelBooking,
                                                        onTap: () =>
                                                            val.onCancelBooking(
                                                                context))
                                                    .paddingOnly(
                                                        top: Insets.i35,
                                                        bottom: Insets.i30)
                                                : const VSpace(Sizes.s80)
                                            : const VSpace(Sizes.s80)
                                      ]).paddingSymmetric(
                                          horizontal: Insets.i20)),
                                ),
                                if (val.booking!.service!.type == "remotely" ||
                                    val.booking!.service!.type ==
                                        "provider_site")
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      children: [
                                        if (val.booking!.service!.type ==
                                            "provider_site")
                                          Expanded(
                                            child: ButtonCommon(
                                                    title: translations!.location,
                                                    color: appColor(context)
                                                        .whiteBg,
                                                    borderColor: appColor(
                                                            context)
                                                        .primary,
                                                    fontColor: appColor(
                                                            context)
                                                        .primary,
                                                    onTap: () async {
                                                      final availableMaps =
                                                          await MapLauncher
                                                              .installedMaps;

                                                      await availableMaps.first
                                                          .showMarker(
                                                        coords: Coords(
                                                            double.parse(val
                                                                .booking!
                                                                .service!
                                                                .destinationLocation!
                                                                .latitude!),
                                                            double.parse(val
                                                                .booking!
                                                                .service!
                                                                .destinationLocation!
                                                                .longitude!)),
                                                        title: "Ocean Beach",
                                                      );
                                                    })
                                                .paddingOnly(
                                                    left: Sizes.s20,
                                                    right: Sizes.s20,
                                                    bottom: Insets.i20)
                                                .backgroundColor(
                                                    appColor(context).whiteBg),
                                          ),
                                        Expanded(
                                          child: ButtonCommon(
                                                  title:
                                                      val.booking!.service!
                                                                  .type ==
                                                              "remotely"
                                                          ? translations!.chat
                                                          : translations!
                                                              .startService,
                                                  onTap: () =>
                                                      val.onStart(context))
                                              .paddingOnly(
                                                  left: Sizes.s20,
                                                  right: Sizes.s20,
                                                  bottom: Insets.i20)
                                              .backgroundColor(
                                                  appColor(context).whiteBg),
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                    ))),
      );
    });
  }
}
