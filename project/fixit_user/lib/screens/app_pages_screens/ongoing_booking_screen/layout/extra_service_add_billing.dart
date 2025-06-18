import '../../../../config.dart';

class ExtraServiceAddBilling extends StatelessWidget {
  final BookingModel? booking;

  const ExtraServiceAddBilling({super.key, this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(isDark(context)
                    ? eImageAssets.completedBillBg
                    : eImageAssets.ongoingBg),
                fit: BoxFit.fill)),
        child: Column(children: [
          BillRowCommon(
              title: translations!.perServiceCharge,
              price:
                  "${getSymbol(context)}${(currency(context).currencyVal * booking!.perServicemanCharge!).ceilToDouble()}"),
          BillRowCommon(
                  title:
                      "${((booking!.requiredServicemen ?? 1) + (booking!.totalExtraServicemen != null ? (booking!.totalExtraServicemen ?? 1) : 0))} ${language(context, translations!.serviceman)}",
                  price:
                      "${getSymbol(context)}${(currency(context).currencyVal * booking!.subtotal!).ceilToDouble()}",
                  style: appCss.dmDenseBold14
                      .textColor(appColor(context).darkText))
              .paddingSymmetric(vertical: Insets.i20),
          BillRowCommon(
              title: translations!.tax,
              price:
                  "+${getSymbol(context)}${(currency(context).currencyVal * booking!.tax!).ceilToDouble()}",
              color: appColor(context).online),
          BillRowCommon(
                  title: translations!.platformFees,
                  price:
                      "+${getSymbol(context)}${(currency(context).currencyVal * booking!.platformFees!).ceilToDouble()}",
                  color: appColor(context).online)
              .paddingOnly(
                  top: Insets.i20,
                  bottom:
                      isPaymentComplete(booking!) ? Insets.i20 : Insets.i34),
          if (isPaymentComplete(booking!))
            if (booking!.extraCharges !=
                    null &&
                booking!.extraCharges!.isNotEmpty)
              ...booking!.extraCharges!.asMap().entries.map((e) => BillRowCommon(
                      title:
                          "Extra service charge(${e.value.perServiceAmount} × ${e.value.noServiceDone})",
                      price:
                          "+${getSymbol(context)}${(e.value.noServiceDone ?? 1) * (currency(context).currencyVal * e.value.perServiceAmount!).ceilToDouble()}",
                      style: appCss.dmDenseBold14
                          .textColor(appColor(context).green))
                  .paddingOnly(bottom: Insets.i20)),
          const DottedLines().paddingSymmetric(horizontal: Insets.i5),
          if (!isPaymentComplete(booking!))
            BillRowCommon(
                    title: translations!.totalAmount,
                    price:
                        "${getSymbol(context)}${(currency(context).currencyVal * booking!.total!).ceilToDouble()}",
                    styleTitle: appCss.dmDenseSemiBold14
                        .textColor(appColor(context).darkText),
                    style: appCss.dmDenseBold16
                        .textColor(appColor(context).darkText))
                .paddingSymmetric(vertical: Insets.i20),
          if (!isPaymentComplete(booking!))
            if (booking!.extraCharges !=
                    null &&
                booking!.extraCharges!.isNotEmpty)
              ...booking!.extraCharges!.asMap().entries.map((e) => BillRowCommon(
                      title:
                          "Extra service charge(${e.value.perServiceAmount} × ${e.value.noServiceDone})",
                      price:
                          "+${getSymbol(context)}${(e.value.noServiceDone ?? 1) * (currency(context).currencyVal * e.value.perServiceAmount!).ceilToDouble()}",
                      style: appCss.dmDenseBold14
                          .textColor(appColor(context).green))
                  .paddingOnly(bottom: Insets.i20)),
          if (booking!.paymentMethod != "on_hand")
            BillRowCommon(
                title: translations!.advancePaid,
                price:
                    "-${getSymbol(context)}${(currency(context).currencyVal * booking!.total!).ceilToDouble()}",
                style: appCss.dmDenseMedium14.textColor(appColor(context).red)),
          if (!isPaymentComplete(booking!))
            Divider(color: appColor(context).stroke)
                .paddingSymmetric(horizontal: Insets.i8),
          const VSpace(Sizes.s20),
          BillRowCommon(
              title: translations!.payableAmount,
              price:
                  "${getSymbol(context)}${booking!.extraCharges != null && booking!.extraCharges!.isNotEmpty ? (currency(context).currencyVal * (totalServicesCharges(booking!) + booking!.total!).roundToDouble()) : (currency(context).currencyVal * booking!.total!.roundToDouble())}",
              styleTitle:
                  appCss.dmDenseMedium15.textColor(appColor(context).primary),
              style: appCss.dmDenseBold16.textColor(appColor(context).primary))
        ]).paddingSymmetric(vertical: Insets.i30));
  }
}
