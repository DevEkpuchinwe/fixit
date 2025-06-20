import '../../../../config.dart';

class CompletedBookingBillPaidLayout extends StatelessWidget {
  final BookingModel? bookingModel;

  const CompletedBookingBillPaidLayout({super.key, this.bookingModel});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  "${getSymbol(context)}${(currency(context).currencyVal * bookingModel!.perServicemanCharge!).ceilToDouble()}"),
          BillRowCommon(
            title:
                "${((bookingModel!.requiredServicemen ?? 1) + (bookingModel!.totalExtraServicemen != null ? (bookingModel!.totalExtraServicemen ?? 1) : 0))} ${language(context, translations!.serviceman)}",
            price:
                "${getSymbol(context)}${(currency(context).currencyVal * bookingModel!.subtotal!).ceilToDouble()}",
          ).paddingSymmetric(vertical: Insets.i20),
          if (bookingModel!.extraCharges != null &&
              bookingModel!.extraCharges!.isNotEmpty)
            BillRowCommon(
              title: language(context, translations!.extraServiceCharge),
              price:
                  "${getSymbol(context)}${(currency(context).currencyVal * bookingModel!.subtotal!).ceilToDouble()}",
            ),
          if (bookingModel!.extraCharges != null &&
              bookingModel!.extraCharges!.isNotEmpty)
            const VSpace(Sizes.s20),
          BillRowCommon(
            title: translations!.platformFees,
            price:
                "+${getSymbol(context)}${(currency(context).currencyVal * bookingModel!.platformFees!).ceilToDouble()}",
          ),
          const VSpace(Sizes.s20),
          BillRowCommon(
                  title: translations!.tax,
                  price:
                      "+${getSymbol(context)}${(currency(context).currencyVal * bookingModel!.tax!).ceilToDouble()}",
                  color: appColor(context).online)
              .paddingOnly(bottom: Insets.i20),
          DottedLines(color: appColor(context).stroke)
              .paddingOnly(
                  bottom: bookingModel!.extraCharges != null &&
                          bookingModel!.extraCharges!.isNotEmpty
                      ? 23
                      : Insets.i20)
              .paddingSymmetric(horizontal: Insets.i5),
          BillRowCommon(
                  title: translations!.payableAmount,
                  price:
                      "${getSymbol(context)}${(currency(context).currencyVal * bookingModel!.total!).ceilToDouble()}",
                  styleTitle: appCss.dmDenseMedium14
                      .textColor(appColor(context).primary),
                  style:
                      appCss.dmDenseBold16.textColor(appColor(context).primary))
              .paddingOnly(
                  bottom: bookingModel!.extraCharges != null &&
                          bookingModel!.extraCharges!.isNotEmpty
                      ? Insets.i10
                      : Insets.i3)
        ]).paddingSymmetric(
          vertical: Insets.i20,
        ));
  }
}
