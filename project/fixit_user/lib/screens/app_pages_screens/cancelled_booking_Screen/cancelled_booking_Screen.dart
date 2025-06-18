import '../../../common_tap.dart';
import '../../../config.dart';

class CancelledBookingScreen extends StatelessWidget {
  const CancelledBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CancelledBookingProvider>(builder: (context1, val, child) {
      return StatefulWrapper(
        onInit: () => Future.delayed(
            const Duration(milliseconds: 100), () => val.onReady(context)),
        child: Scaffold(
            appBar: AppBarCommon(title: translations!.cancelledBooking),
            body: val.booking == null
                ? Container()
                : SingleChildScrollView(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        val.getBookingDetailBy(context);
                      },
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StatusDetailLayout(
                                  data: val.booking,
                                  onTapStatus: () =>
                                      showBookingStatus(context, val.booking)),
                              Text(language(context, translations!.billSummary),
                                      style: appCss.dmDenseSemiBold14.textColor(
                                          appColor(context).darkText))
                                  .paddingOnly(
                                      top: Insets.i25, bottom: Insets.i10),
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(isDark(context)
                                            ? eImageAssets.pendingBillBgDark
                                            : eImageAssets.pendingBillBg),
                                        fit: BoxFit.fill)),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                                  style: appCss.dmDenseBold14
                                                      .textColor(
                                                          appColor(context)
                                                              .darkText))
                                              .paddingSymmetric(
                                                  vertical: Insets.i20),
                                          BillRowCommon(
                                                  title: translations!.tax,
                                                  price:
                                                      "+${getSymbol(context)}${(currency(context).currencyVal * val.booking!.tax!).ceilToDouble()}",
                                                  color:
                                                      appColor(context).online)
                                              .paddingOnly(bottom: Insets.i20),
                                          BillRowCommon(
                                              title: translations!.platformFees,
                                              price:
                                                  "+${getSymbol(context)}${(currency(context).currencyVal * (val.booking!.platformFees ?? 0.0)).ceilToDouble()}",
                                              color: appColor(context).online)
                                        ],
                                      ),
                                      const VSpace(Sizes.s30),
                                      /* Divider(
                                      color: appColor(context).stroke, thickness: 1, height: 1,indent: 6,endIndent: 6).paddingOnly(bottom:23),*/
                                      BillRowCommon(
                                              title: translations!.totalAmount,
                                              price:
                                                  "${getSymbol(context)}${(currency(context).currencyVal * val.booking!.total!).ceilToDouble()}",
                                              styleTitle: appCss.dmDenseMedium14
                                                  .textColor(appColor(context)
                                                      .darkText),
                                              style: appCss.dmDenseBold16
                                                  .textColor(appColor(context)
                                                      .primary))
                                          .paddingOnly(top: Insets.i10),
                                    ]).paddingSymmetric(vertical: Insets.i20),
                              ),
                              Text(language(context, translations!.reason),
                                      style: appCss.dmDenseSemiBold14.textColor(
                                          appColor(context).darkText))
                                  .paddingOnly(
                                      top: Insets.i10, bottom: Insets.i10),
                              // const VSpace(Sizes.s20),
                              Container(
                                padding: EdgeInsets.all(Insets.i20),
                                width: MediaQuery.of(context).size.width,
                                decoration: ShapeDecoration(
                                  color: appColor(context).red.withOpacity(
                                      0.1) /* appColor(context).whiteBg */,
                                  shadows: [
                                    BoxShadow(
                                      color: appColor(context).whiteBg,
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                    )
                                  ],
                                  shape: SmoothRectangleBorder(
                                    side: BorderSide(
                                        color: appColor(context).fieldCardBg),
                                    borderRadius: SmoothBorderRadius(
                                      cornerRadius: AppRadius.r12,
                                      cornerSmoothing: 1,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  val.booking?.bookingReasons?.first.reason ??
                                      "",
                                  style: TextStyle(
                                      fontSize: Sizes.s15,
                                      color: appColor(context).red),
                                ),
                              ),
                            ]).paddingSymmetric(horizontal: Insets.i20),
                      ),
                    ),
                  )),
      );
    });
  }
}
