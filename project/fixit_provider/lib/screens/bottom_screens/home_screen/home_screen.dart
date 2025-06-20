import 'dart:developer';

import 'package:fixit_provider/screens/bottom_screens/home_screen/home_shimmer/home_shimmer.dart';

import '../../../config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  AnimationStatus status = AnimationStatus.dismissed;

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    animation = Tween(end: 1.0, begin: 0.0).animate(controller)
      ..addListener(() {
        setState(() {});
        controller.repeat();
      })
      ..addStatusListener((status) {
        status = status;
      });
    controller.repeat();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<LanguageProvider, HomeProvider, BookingProvider,
            DashboardProvider>(
        builder: (context1, lang, value, booking, dashCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(const Duration(milliseconds: 100),
              () => value.onReady(context, this)),
          child: /* value.isSkeleton
              ? const HomeShimmer()
              : */
              RefreshIndicator(
            onRefresh: () async {
              return dashCtrl.onRefresh(context);
            },
            child: Scaffold(
                appBar: AppBar(
                    leadingWidth: MediaQuery.of(context).size.width,
                    leading:
                        userModel != null ? const HomeAppBar() : Container()),
                body: userModel == null
                    ? Container()
                    : SingleChildScrollView(
                        controller: value.scrollController,
                        child: Column(children: [
                          const VSpace(Sizes.s15),
                          if (userModel!.subscriptionReminderNote != null)
                            Column(
                              children: [
                                Text(userModel!.subscriptionReminderNote!,
                                        style: appCss.dmDenseRegular14
                                            .textColor(
                                                appColor(context).appTheme.red))
                                    .paddingAll(Sizes.s20)
                                    .boxShapeExtension(
                                        color: appColor(context)
                                            .appTheme
                                            .red
                                            .withOpacity(.10),
                                        radius: 8),
                                const VSpace(Sizes.s15),
                              ],
                            )
                                .padding(horizontal: Sizes.s20)
                                .width(MediaQuery.sizeOf(context).width),
                          if (isServiceman) const ProviderInfo(),
                          WalletBalanceLayout(
                              onTap: () => value.onWithdraw(context)),
                          const VSpace(Sizes.s16),
                          if (isServiceman)
                            ServicemanStatistics(animation: animation)
                          else
                            Column(children: [
                              Row(children: [
                                ...appArray.earningList
                                    .getRange(0, 2)
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map((e) {
                                  return Expanded(
                                      child: Row(children: [
                                    Expanded(
                                        child: GridViewLayout(
                                            data: e.value,
                                            index: e.key,
                                            isHeight: false,
                                            animation: animation,
                                            onTap: () => value.onTapOption(
                                                e.key,
                                                context,
                                                e.value['title'],
                                                e.value))),
                                    if (e.key == 0) const HSpace(Sizes.s12)
                                  ]));
                                })
                              ]),
                              const VSpace(Sizes.s12),
                              Row(children: [
                                ...appArray.earningList
                                    .getRange(2, (isFreelancer ? 4 : 5))
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map((e) {
                                  // log("earningList:::${e.value}");
                                  return Expanded(
                                      child: Row(children: [
                                    Expanded(
                                        child: GridViewLayout(
                                            data: e.value,
                                            index: e.key,
                                            animation: animation,
                                            onTap: () => value.onTapOption(
                                                e.key,
                                                context,
                                                e.value['title'],
                                                e.value))),
                                    if (e.key !=
                                        appArray.earningList
                                                .getRange(
                                                    2, isFreelancer ? 4 : 5)
                                                .length -
                                            1)
                                      const HSpace(Sizes.s12)
                                  ]));
                                })
                              ])
                            ]).marginSymmetric(horizontal: Sizes.s20),
                          if (!isServiceman) const VSpace(Sizes.s25),
                          if (isServiceman)
                            booking.bookingList.isNotEmpty
                                ? Column(children: [
                                    HeadingRowCommon(
                                        isViewAllShow:
                                            booking.bookingList.length >= 10,
                                        title: translations!.recentBooking,
                                        onTap: () =>
                                            value.onTapIndexOne(dashCtrl)),
                                    const VSpace(Sizes.s15),
                                    booking.bookingList.length > 2
                                        ? Column(children: [
                                            ...booking.bookingList
                                                .getRange(0, 2)
                                                .toList()
                                                .asMap()
                                                .entries
                                                .map((e) => BookingLayout(
                                                    data: e.value,
                                                    onTap: () =>
                                                        value.onTapBookings(
                                                            e.value, context)))
                                          ])
                                        : Column(children: [
                                            ...booking.bookingList
                                                .toList()
                                                .asMap()
                                                .entries
                                                .map((e) => BookingLayout(
                                                    data: e.value,
                                                    onTap: () =>
                                                        value.onTapBookings(
                                                            e.value, context)))
                                          ])
                                  ])
                                    .padding(
                                      horizontal: Insets.i20,
                                      top: Insets.i25,
                                    )
                                    .decorated(
                                        color:
                                            appColor(context).appTheme.whiteBg)
                                : Container(
                                    color: (isDark(context)
                                        ? const Color(0xFF202020)
                                            .withOpacity(.6)
                                        : Colors.grey.withOpacity(0.2)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Sizes.s20,
                                        vertical: Sizes.s28),
                                    child: Column(children: [
                                      const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CommonWhiteShimmer(
                                                height: Sizes.s17,
                                                width: Sizes.s184),
                                            CommonWhiteShimmer(
                                                height: Sizes.s17,
                                                width: Sizes.s48)
                                          ]),
                                      const VSpace(Sizes.s17),
                                      ...List.generate(
                                          2,
                                          (index) => Stack(children: [
                                                const CommonWhiteShimmer(
                                                  height: Sizes.s435,
                                                  radius: 12,
                                                ).marginOnly(
                                                    bottom: index == 0
                                                        ? Sizes.s28
                                                        : 0),
                                                Column(children: [
                                                  const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              CommonSkeleton(
                                                                  height:
                                                                      Sizes.s10,
                                                                  width: Sizes
                                                                      .s52),
                                                              VSpace(Sizes.s16),
                                                              CommonSkeleton(
                                                                  height:
                                                                      Sizes.s10,
                                                                  width: Sizes
                                                                      .s160),
                                                              VSpace(Sizes.s16),
                                                              CommonSkeleton(
                                                                  height:
                                                                      Sizes.s10,
                                                                  width: Sizes
                                                                      .s160)
                                                            ]),
                                                        CommonSkeleton(
                                                            height: Sizes.s84,
                                                            width: Sizes.s84,
                                                            radius: 10)
                                                      ]),
                                                  const VSpace(Sizes.s12),
                                                  Image.asset(eImageAssets
                                                          .bulletDotted)
                                                      .padding(
                                                          bottom: Insets.i18),
                                                  const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        CommonSkeleton(
                                                            height: Sizes.s10,
                                                            width: Sizes.s52),
                                                        CommonSkeleton(
                                                            height: Sizes.s22,
                                                            radius: 12,
                                                            width: Sizes.s66)
                                                      ]),
                                                  const VSpace(Sizes.s15),
                                                  const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        CommonSkeleton(
                                                            height: Sizes.s10,
                                                            width: Sizes.s116),
                                                        CommonSkeleton(
                                                            height: Sizes.s10,
                                                            width: Sizes.s76)
                                                      ]),
                                                  const VSpace(Sizes.s18),
                                                  const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        CommonSkeleton(
                                                            height: Sizes.s10,
                                                            width: Sizes.s67),
                                                        CommonSkeleton(
                                                            height: Sizes.s10,
                                                            width: Sizes.s128)
                                                      ]),
                                                  const VSpace(Sizes.s18),
                                                  const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        CommonSkeleton(
                                                            height: Sizes.s10,
                                                            width: Sizes.s52),
                                                        CommonSkeleton(
                                                            height: Sizes.s10,
                                                            width: Sizes.s128)
                                                      ]),
                                                  const VSpace(Sizes.s18),
                                                  const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        CommonSkeleton(
                                                            height: Sizes.s10,
                                                            width: Sizes.s55),
                                                        CommonSkeleton(
                                                            height: Sizes.s10,
                                                            width: Sizes.s128)
                                                      ]),
                                                  const VSpace(Sizes.s18),
                                                  Stack(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      children: [
                                                        const CommonSkeleton(
                                                            height: Sizes.s60,
                                                            radius: 10),
                                                        const Row(children: [
                                                          CommonWhiteShimmer(
                                                              height: Sizes.s36,
                                                              width: Sizes.s36,
                                                              isCircle: true),
                                                          HSpace(Sizes.s8),
                                                          Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CommonWhiteShimmer(
                                                                    height: Sizes
                                                                        .s10,
                                                                    width: Sizes
                                                                        .s55),
                                                                VSpace(
                                                                    Sizes.s7),
                                                                CommonWhiteShimmer(
                                                                    height: Sizes
                                                                        .s10,
                                                                    width: Sizes
                                                                        .s90)
                                                              ])
                                                        ]).padding(
                                                            horizontal:
                                                                Sizes.s12)
                                                      ]),
                                                  const VSpace(Sizes.s10),
                                                  const CommonSkeleton(
                                                          height: Sizes.s10,
                                                          width: Sizes.s150)
                                                      .alignment(
                                                          Alignment.centerLeft),
                                                  const VSpace(Sizes.s15),
                                                  const Row(children: [
                                                    Stack(children: [
                                                      CommonSkeleton(
                                                          height: Sizes.s44,
                                                          width: Sizes.s145),
                                                      CommonWhiteShimmer()
                                                    ])
                                                  ])
                                                ]).padding(
                                                    horizontal: Sizes.s15,
                                                    top: Sizes.s25)
                                              ]))
                                    ])),
                          const StaticDetailChart(),
                          const AllCategoriesLayout()
                        ]).paddingOnly(bottom: Insets.i110))),
          ));
    });
  }
}
