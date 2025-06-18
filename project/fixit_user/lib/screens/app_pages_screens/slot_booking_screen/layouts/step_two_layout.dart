import 'package:intl/intl.dart';

import '../../../../config.dart';

class StepTwoLayout extends StatelessWidget {
  const StepTwoLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SlotBookingProvider>(builder: (context2, value, child) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(children: [
            Text(language(context, translations!.billDetails).toUpperCase(),
                style: appCss.dmDenseSemiBold16
                    .textColor(appColor(context).primary)),
            const VSpace(Sizes.s15),
            value.servicesCart!.selectServiceManType == "app_choose"
                ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        SvgPicture.asset(eSvgAssets.about,
                            colorFilter: ColorFilter.mode(
                                appColor(context).darkText, BlendMode.srcIn),
                            fit: BoxFit.scaleDown),
                        const HSpace(Sizes.s10),
                        Expanded(
                            child: Column(children: [
                          Text(language(context, translations!.asYouPreviously),
                              overflow: TextOverflow.fade,
                              style: appCss.dmDenseRegular14
                                  .textColor(appColor(context).darkText))
                        ]))
                      ])
                    .paddingAll(Insets.i15)
                    .boxShapeExtension(color: appColor(context).fieldCardBg)
                : Container(),
            const VSpace(Sizes.s25),
            Text(language(context, translations!.bookedDateTime),
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).darkText)),
            const VSpace(Sizes.s10),
            BookedDateTimeLayout(
                onTap: () => value.onProviderDateTimeSelect(context),
                date: DateFormat('dd MMMM, yyyy')
                    .format(value.servicesCart!.serviceDate!),
                time:
                    "At ${DateFormat('hh:mm').format(value.servicesCart!.serviceDate!)} ${value.servicesCart!.selectedDateTimeFormat ?? DateFormat('a').format(value.servicesCart!.serviceDate!)}"),
            const VSpace(Sizes.s25),
            BillSummaryLayout(
                balance:
                    "${getSymbol(context)}${(currency(context).currencyVal * (userModel!.wallet != null ? userModel!.wallet!.balance! : 0.0)).toStringAsFixed(1)}"),
            const VSpace(Sizes.s10),
            Container(
                //  height: Sizes.s200,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: Insets.i20),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(isDark(context)
                            ? eImageAssets.pendingBillBgDark
                            : eImageAssets.pendingBillBg),
                        fit: BoxFit.fill)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(children: [
                        BillRowCommon(
                            title: translations!.perServiceCharge,
                            price:
                                "${getSymbol(context)}${(currency(context).currencyVal * (value.servicesCart!.serviceRate!).ceilToDouble())}"),
                        BillRowCommon(
                                title:
                                    "${value.servicesCart!.selectedRequiredServiceMan} ${language(context, translations!.serviceman)} (${getSymbol(context)}${(currency(context).currencyVal * (value.servicesCart!.serviceRate!)).ceilToDouble()} × ${value.servicesCart!.selectedRequiredServiceMan})",
                                price:
                                    "${getSymbol(context)}${(currency(context).currencyVal * (value.servicesCart!.serviceRate!).ceilToDouble()) * (value.servicesCart!.selectedRequiredServiceMan!)}")
                            .marginOnly(top: Insets.i20),
                        const VSpace(Sizes.s20),
                        BillRowCommon(
                            title: translations!.tax,
                            price:
                                language(context, translations!.costAtCheckout))
                      ]),
                      Column(
                        children: [
                          const VSpace(Sizes.s20),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    language(
                                        context, translations!.totalAmount),
                                    style: appCss.dmDenseMedium14
                                        .textColor(appColor(context).darkText)),
                                Text(
                                    "${getSymbol(context)}${(currency(context).currencyVal * (value.servicesCart!.serviceRate!).ceilToDouble()) * (value.servicesCart!.selectedRequiredServiceMan!)}",
                                    style: appCss.dmDenseBold16
                                        .textColor(appColor(context).primary))
                              ]).paddingSymmetric(horizontal: Insets.i15),
                        ],
                      )
                    ])),
            const VSpace(Sizes.s100),
          ]).paddingSymmetric(horizontal: Insets.i20),
          ButtonCommon(
                  title: translations!.confirmBooking,
                  onTap: () => value.addToCart(context),
                  margin: Insets.i20)
              .paddingOnly(bottom: Insets.i20)
              .backgroundColor(appColor(context).whiteBg)
        ],
      );
    });
  }
}
