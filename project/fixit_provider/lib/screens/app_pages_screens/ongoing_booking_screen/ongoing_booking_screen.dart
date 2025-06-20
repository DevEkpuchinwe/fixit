import '../../../config.dart';
import '../../bottom_screens/booking_screen/booking_shimmer/booking_detail_shimmer.dart';

class OngoingBookingScreen extends StatelessWidget {
  const OngoingBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<OngoingBookingProvider, AddExtraChargesProvider>(
        builder: (context1, value, addValue, child) {
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          value.onBack(context, false);
          if (didPop) return;
        },
        child: StatefulWrapper(
            onInit: () => Future.delayed(
                const Duration(milliseconds: 50), () => value.onReady(context)),
            child:  Scaffold(
                    appBar: AppBarCommon(
                      title: translations!.ongoingBooking,
                      onTap: () => value.onBack(context, true),
                    ),
                    body:value.bookingModel == null
                        ? const BookingDetailShimmer()
                        : RefreshIndicator(
                      onRefresh: () async {
                        value.onRefresh(context);
                      },
                      child:
                          Stack(alignment: Alignment.bottomCenter, children: [
                        SingleChildScrollView(
                            child: Column(children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StatusDetailLayout(
                                    data: value.bookingModel,
                                    onTapStatus: () => showBookingStatus(
                                        context, value.bookingModel)),
                                if (value.amount != null)
                                  ServicemenPayableLayout(amount: value.amount),
                                Text(
                                        language(
                                            context, translations!.billSummary),
                                        style: appCss.dmDenseMedium14.textColor(
                                            appColor(context)
                                                .appTheme
                                                .darkText))
                                    .paddingOnly(
                                        top: Insets.i25, bottom: Insets.i10),
                                !(userModel!.role!.name == "provider")
                                    ? PendingApprovalBillSummary(
                                        bookingModel: value.bookingModel)
                                    : OngoingBillSummary(
                                        bookingModel: value.bookingModel),
                                const VSpace(Sizes.s20),
                                if (value.bookingModel!.extraCharges != null &&
                                    value
                                        .bookingModel!.extraCharges!.isNotEmpty)
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            language(
                                                context,
                                                translations!
                                                    .addServiceDetails),
                                            style: appCss.dmDenseMedium14
                                                .textColor(appColor(context)
                                                    .appTheme
                                                    .darkText)),
                                        const VSpace(Sizes.s10),
                                        AddServiceLayout(
                                            extraCharge: value
                                                .bookingModel!.extraCharges),
                                        const VSpace(Sizes.s25)
                                      ]),
                                if (value.bookingModel!.service!.reviews !=
                                        null &&
                                    value.bookingModel!.service!.reviews!
                                        .isNotEmpty)
                                  ReviewListWithTitle(
                                      reviews:
                                          value.bookingModel!.service!.reviews!)
                              ]).paddingAll(Insets.i20),
                        ]).paddingOnly(bottom: Insets.i100)),
                        Material(
                            elevation: 20,
                            child: (value.bookingModel!.servicemen!
                                    .where((element) =>
                                        element.id.toString() ==
                                        userModel!.id.toString())
                                    .isEmpty)
                                ? AssignStatusLayout(
                                    status: translations!.status,
                                    title: translations!.serviceInProgress,
                                    isGreen: true)
                                : value.bookingModel!.bookingStatus!.slug !=
                                        appFonts.onGoing
                                    ? AssignStatusLayout(
                                        status: translations!.status,
                                        title: translations!.serviceNotStarted,
                                        isGreen: true)
                                    : Row(children: [
                                        Expanded(
                                            child: ButtonCommon(
                                                onTap: () => value.updateStatus(
                                                    context,
                                                    value.bookingModel!.id),
                                                title: translations!.complete,
                                                color: appColor(context)
                                                    .appTheme
                                                    .green)),
                                        const HSpace(Sizes.s15),
                                        Expanded(
                                            child: ButtonCommon(
                                                title: translations!.addCharges,
                                                onTap: () =>
                                                    value.addCharges(context)))
                                      ]).paddingAll(Insets.i20).decorated(
                                        color:
                                            appColor(context).appTheme.whiteBg))
                      ]),
                    ))),
      );
    });
  }
}
