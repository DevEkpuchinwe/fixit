import '../../../../config.dart';

class NoExtraServiceAddedBill extends StatelessWidget {
  final BookingModel? bookingModel;
  const NoExtraServiceAddedBill({super.key, this.bookingModel});

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
              price: bookingModel!.perServicemanCharge == null
                  ? ""
                  : "${getSymbol(context)}${(currency(context).currencyVal * bookingModel!.perServicemanCharge!).ceilToDouble()}"),
          BillRowCommon(
                  title:
                      "${((bookingModel!.requiredServicemen ?? 1) + (bookingModel!.totalExtraServicemen != null ? (bookingModel!.totalExtraServicemen ?? 1) : 0))} ${language(context, translations!.serviceman)}",
                  price:
                      "${getSymbol(context)}${(currency(context).currencyVal * bookingModel!.subtotal!).ceilToDouble()}",
                  style: appCss.dmDenseBold14
                      .textColor(appColor(context).darkText))
              .paddingSymmetric(vertical: Insets.i20),
          BillRowCommon(
              title: translations!.tax,
              price:
                  "+${getSymbol(context)}${(currency(context).currencyVal * bookingModel!.tax!).ceilToDouble()}",
              color: appColor(context).online),
          BillRowCommon(
                  title: translations!.platformFees,
                  price:
                      "+${getSymbol(context)}${(currency(context).currencyVal * bookingModel!.platformFees!).ceilToDouble()}",
                  color: appColor(context).online)
              .paddingOnly(top: Insets.i20, bottom: Insets.i25),
          BillRowCommon(
              title: translations!.totalAmount,
              price:
                  "${getSymbol(context)}${(currency(context).currencyVal * bookingModel!.total!).ceilToDouble()}",
              styleTitle:
                  appCss.dmDenseMedium14.textColor(appColor(context).darkText),
              style: appCss.dmDenseBold16.textColor(appColor(context).primary))
        ]).paddingSymmetric(vertical: Insets.i30));
  }
}
