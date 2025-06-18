import 'dart:developer';

import 'package:fixit_user/screens/bottom_screens/booking_screen/booking_shimmer/booking_shimmer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with TickerProviderStateMixin {
  /*   SharedPreferences preferences =  SharedPreferences.getInstance(); */
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context2, dash, child) {
      return Consumer<BookingProvider>(builder: (context1, value, child) {
        return StatefulWrapper(
          onInit: () => Future.delayed(const Duration(milliseconds: 100),
              () => value.onFetchData(context, this)),
          child: /* (value.widget1Opacity == 1 /* 0.0 */)
              ? const BookingShimmer()
              :  */
              Scaffold(
                  appBar: AppBar(
                      leadingWidth: 80,
                      title: Text(language(context, translations!.bookings),
                          style: appCss.dmDenseBold18
                              .textColor(appColor(context).darkText)),
                      centerTitle: true,
                      leading: CommonArrow(
                          arrow: rtl(context)
                              ? eSvgAssets.arrowRight
                              : eSvgAssets.arrowLeft,
                          onTap: () {
                            dash.selectIndex = 0;
                            // value.clearTap(context);
                            dash.notifyListeners();
                          }).paddingAll(Insets.i8),
                      actions: [
                        Consumer<NotificationProvider>(
                            builder: (context2, notify, child) {
                          return Container(
                                  alignment: Alignment.center,
                                  height: Sizes.s40,
                                  width: Sizes.s40,
                                  child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        SvgPicture.asset(
                                            eSvgAssets.notification,
                                            alignment: Alignment.center,
                                            fit: BoxFit.scaleDown,
                                            colorFilter: ColorFilter.mode(
                                                appColor(context).darkText,
                                                BlendMode.srcIn)),
                                        if (notify.totalCount() != 0)
                                          Positioned(
                                              top: 2,
                                              right: 2,
                                              child: Icon(Icons.circle,
                                                  size: Sizes.s7,
                                                  color: appColor(context).red))
                                      ]))
                              .decorated(
                                  shape: BoxShape.circle,
                                  color: appColor(context).fieldCardBg)
                              .inkWell(
                                  onTap: () => route.pushNamed(
                                      context, routeName.notifications))
                              .paddingOnly(
                                  left: rtl(context) ? Insets.i20 : 0,
                                  right: rtl(context) ? 0 : Insets.i20);
                        })
                      ]),
                  body: RefreshIndicator(
                      onRefresh: () async {
                        value.onRefresh(context);
                      },
                      child: /*  dash.isSearchData
                          ? EmptyLayout(
                              title: translations!.noMatching,
                              subtitle: translations!.attemptYourSearch,
                              buttonText: translations!.refresh,
                              isBooking: true,
                              bTap: () async {
                                if (value.bookingList.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "${language(context, translations!.refresh)}...");

                                  dash.getBookingHistory(context);
                                }
                              },
                              widget: Stack(children: [
                                Image.asset(eImageAssets.noSearch,
                                        height: Sizes.s346)
                                    .paddingOnly(top: Insets.i40),
                                /* if (value.animationController != null)
                                  Positioned(
                                      left: 40,
                                      top: 0,
                                      child: RotationTransition(
                                          turns: Tween(begin: 0.01, end: -.01)
                                              .chain(CurveTween(
                                                  curve: Curves.easeIn))
                                              .animate(
                                                  value.animationController!),
                                          child: Image.asset(
                                              eImageAssets.mGlass,
                                              height: Sizes.s190,
                                              width: Sizes.s178))) */
                              ]))
                          : /* value.bookingList.isNotEmpty
                              ? */
                         */
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            SearchTextFieldCommon(
                                    focusNode: value.searchFocus,
                                    hinText: language(context,
                                        translations!.searchWithBookingId),
                                    controller: value.searchText,
                                    onTap: () {
                                      dash.isTap = true;
                                      dash.notifyListeners();
                                    },
                                    onChanged: (v) {
                                      if (v.isEmpty) {
                                        dash.getBookingHistory(context,
                                            search: v);
                                      } else if (v.length > 3) {
                                        dash.getBookingHistory(context,
                                            search: v);
                                      }
                                    },
                                    onFieldSubmitted: (v) {
                                      log("HHHHH");
                                      dash.isTap = false;
                                      dash.notifyListeners();
                                      dash.getBookingHistory(context,
                                          search: v);
                                    },
                                    suffixIcon:
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                          if (value.searchText.text.isNotEmpty)
                                            Icon(Icons.cancel,
                                                    color: appColor(context)
                                                        .darkText)
                                                .inkWell(onTap: () {
                                              value.searchText.text = "";
                                              value.notifyListeners();
                                              dash.getBookingHistory(context);
                                            }),
                                          const HSpace(Sizes.s5),
                                          FilterIconCommon(
                                              onTap: () =>
                                                  value.onTapFilter(context),
                                              selectedFilter:
                                                  value.totalCountFilter()),
                                        ]))
                                .paddingSymmetric(horizontal: Insets.i20),
                            const VSpace(Sizes.s25),
                            Text(language(context, translations!.allBooking),
                                    style: appCss.dmDenseBold18
                                        .textColor(appColor(context).darkText))
                                .paddingSymmetric(horizontal: Insets.i20),
                            const VSpace(Sizes.s15),

                            isGuest == true
                                ? EmptyLayout(
                                    title:
                                        "You must login/register to modify or view your profile information." /* translations!.noMatching */,
                                    subtitle: "",
                                    buttonText: translations!.login,
                                    isBooking: true,
                                    isButtonShow: true,
                                    bTap: () async {
                                      route.pushNamed(context, routeName.login);
                                      /* if (value.bookingList.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "${language(context, translations!.refresh)}...");

                                        dash.getBookingHistory(context);
                                      } */
                                    },
                                    widget: Stack(children: [
                                      Image.asset(eImageAssets.noList,
                                              height: Sizes.s230)
                                          .paddingOnly(top: Insets.i40),
                                    ]))
                                : Expanded(
                                    child: Column(
                                      children: [
                                        dash.isSearchData
                                            ? EmptyLayout(
                                                title: translations!.noMatching,
                                                subtitle: translations!
                                                    .attemptYourSearch,
                                                buttonText:
                                                    translations!.refresh,
                                                isBooking: true,
                                                isButtonShow: false,
                                                /*  bTap: () async {
                                        if (value.bookingList.isEmpty) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "${language(context, translations!.refresh)}...");
                                  
                                          dash.getBookingHistory(context);
                                        }
                                      }, */
                                                widget: Stack(children: [
                                                  Image.asset(
                                                          eImageAssets.noList,
                                                          height: Sizes.s230)
                                                      .paddingOnly(
                                                          top: Insets.i40),
                                                  /* if (value.animationController != null)
                                    Positioned(
                                        left: 40,
                                        top: 0,
                                        child: RotationTransition(
                                            turns: Tween(begin: 0.01, end: -.01)
                                                .chain(CurveTween(
                                                    curve: Curves.easeIn))
                                                .animate(
                                                    value.animationController!),
                                            child: Image.asset(
                                                eImageAssets.mGlass,
                                                height: Sizes.s190,
                                                width: Sizes.s178))) */
                                                ]))
                                            : /* value.bookingList.isNotEmpty
                                                                ? */

                                            value.bookingList.isNotEmpty
                                                ? value.widget1Opacity == 0.0 &&
                                                        dash.isLoading == false
                                                    ? Expanded(
                                                        child: ListView.builder(
                                                                itemCount: 2,
                                                                shrinkWrap: true,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return Column(
                                                                    children: [
                                                                      Column(
                                                                              children: [
                                                                            const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                Row(children: [
                                                                                  CommonSkeleton(height: Sizes.s14, width: Sizes.s50),
                                                                                  HSpace(Sizes.s5),
                                                                                  CommonSkeleton(height: Sizes.s22, width: Sizes.s68, radius: 12)
                                                                                ]),
                                                                                VSpace(Sizes.s8),
                                                                                CommonSkeleton(height: Sizes.s14, width: Sizes.s124),
                                                                                VSpace(Sizes.s11),
                                                                                CommonSkeleton(height: Sizes.s14, width: Sizes.s124)
                                                                              ]),
                                                                              CommonSkeleton(height: Sizes.s84, width: Sizes.s84, radius: 10)
                                                                            ]),
                                                                            const VSpace(Sizes.s15),
                                                                            const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                              CommonSkeleton(height: Sizes.s14, width: Sizes.s40),
                                                                              CommonSkeleton(height: Sizes.s22, width: Sizes.s66, radius: 12),
                                                                            ]),
                                                                            const VSpace(Sizes.s14),
                                                                            const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                              CommonSkeleton(height: Sizes.s14, width: Sizes.s116),
                                                                              CommonSkeleton(height: Sizes.s14, width: Sizes.s76),
                                                                            ]),
                                                                            const VSpace(Sizes.s15),
                                                                            const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                              CommonSkeleton(height: Sizes.s14, width: Sizes.s106),
                                                                              CommonSkeleton(height: Sizes.s14, width: Sizes.s76)
                                                                            ]),
                                                                            const VSpace(Sizes.s15),
                                                                            const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                              CommonSkeleton(height: Sizes.s14, width: Sizes.s106),
                                                                              CommonSkeleton(height: Sizes.s14, width: Sizes.s76)
                                                                            ]),
                                                                            const VSpace(Sizes.s12),
                                                                            const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                              CommonSkeleton(height: Sizes.s14, width: Sizes.s106),
                                                                              CommonSkeleton(height: Sizes.s14, width: Sizes.s106)
                                                                            ]),
                                                                            const VSpace(Sizes.s17),
                                                                            Stack(alignment: Alignment.center, children: [
                                                                              const CommonSkeleton(height: Sizes.s68, radius: 8),
                                                                              const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                                Row(children: [
                                                                                  CommonWhiteShimmer(height: Sizes.s36, width: Sizes.s36, isCircle: true),
                                                                                  HSpace(Sizes.s9),
                                                                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                    CommonWhiteShimmer(height: Sizes.s10, width: Sizes.s55),
                                                                                    VSpace(Sizes.s5),
                                                                                    CommonWhiteShimmer(height: Sizes.s12, width: Sizes.s78)
                                                                                  ])
                                                                                ]),
                                                                                CommonWhiteShimmer(height: Sizes.s12, width: Sizes.s30)
                                                                              ]).paddingSymmetric(horizontal: Sizes.s12)
                                                                            ])
                                                                          ])
                                                                          .padding(
                                                                              horizontal: Sizes
                                                                                  .s15,
                                                                              top: Sizes
                                                                                  .s23,
                                                                              bottom: Sizes
                                                                                  .s15)
                                                                          .boxBorderExtension(
                                                                              context,
                                                                              color: isDark(context) ? Colors.black26 : appColor(context).whiteColor,
                                                                              bColor: isDark(context) ? Colors.grey.withOpacity(.2) : appColor(context).stroke)
                                                                          .paddingOnly(bottom: Sizes.s15)
                                                                    ],
                                                                  );
                                                                })
                                                            .paddingSymmetric(
                                                                horizontal:
                                                                    Insets.i20),
                                                      )
                                                    : Expanded(
                                                        child: ListView.builder(
                                                            controller: value
                                                                .scrollController,
                                                            itemCount: value
                                                                .bookingList
                                                                .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return BookingLayout(
                                                                  data: value
                                                                          .bookingList[
                                                                      index],
                                                                  index: index,
                                                                  editLocationTap: () =>
                                                                      value.editAddress(
                                                                          context,
                                                                          value.bookingList[
                                                                              index]),
                                                                  editDateTimeTap: () =>
                                                                      value.editDateTimeTap(
                                                                          context,
                                                                          value.bookingList[
                                                                              index]),
                                                                  onTap: () {
                                                                    print(
                                                                        "object====> ${value.bookingList[index]} ");
                                                                    value.onTapBookings(
                                                                        value.bookingList[
                                                                            index],
                                                                        context);
                                                                  });
                                                            }),
                                                      )
                                                : EmptyLayout(
                                                    title:
                                                        translations!.ohhNoList,
                                                    subtitle: translations!
                                                        .yourBookingList,
                                                    buttonText:
                                                        translations!.refresh,
                                                    isButtonShow: false,
                                                    /*   bTap: () {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "${language(context, translations!.refresh)}...");
                                            dash.getBookingHistory(context);
                                          }, */
                                                    widget: Stack(children: [
                                                      Image.asset(
                                                          eImageAssets.noList,
                                                          height: Sizes.s250)
                                                    ])),
                                        VSpace(dash.isTap ? 0 : Insets.i80)
                                      ],
                                    ),
                                  ),
                            // dash.isSearchData
                            //     ? EmptyLayout(
                            //         title: translations!.noMatching,
                            //         subtitle: translations!.attemptYourSearch,
                            //         buttonText: translations!.refresh,
                            //         isBooking: true,
                            //         isButtonShow: false,
                            //         /*  bTap: () async {
                            //           if (value.bookingList.isEmpty) {
                            //             Fluttertoast.showToast(
                            //                 msg:
                            //                     "${language(context, translations!.refresh)}...");

                            //             dash.getBookingHistory(context);
                            //           }
                            //         }, */
                            //         widget: Stack(children: [
                            //           Image.asset(eImageAssets.noSearch,
                            //                   height: Sizes.s230)
                            //               .paddingOnly(top: Insets.i40),
                            //           /* if (value.animationController != null)
                            //       Positioned(
                            //           left: 40,
                            //           top: 0,
                            //           child: RotationTransition(
                            //               turns: Tween(begin: 0.01, end: -.01)
                            //                   .chain(CurveTween(
                            //                       curve: Curves.easeIn))
                            //                   .animate(
                            //                       value.animationController!),
                            //               child: Image.asset(
                            //                   eImageAssets.mGlass,
                            //                   height: Sizes.s190,
                            //                   width: Sizes.s178))) */
                            //         ]))
                            //     : /* value.bookingList.isNotEmpty
                            //   ? */

                            //     value.bookingList.isNotEmpty
                            //         ? value.widget1Opacity == 0.0 &&
                            //                 dash.isLoading == false
                            //             ? Expanded(
                            //                 child: ListView.builder(
                            //                         itemCount: 2,
                            //                         itemBuilder: (context, index) {
                            //                           return Column(
                            //                             children: [
                            //                               Column(children: [
                            //                                 const Row(
                            //                                     mainAxisAlignment:
                            //                                         MainAxisAlignment
                            //                                             .spaceBetween,
                            //                                     children: [
                            //                                       Column(
                            //                                           crossAxisAlignment:
                            //                                               CrossAxisAlignment
                            //                                                   .start,
                            //                                           children: [
                            //                                             Row(
                            //                                                 children: [
                            //                                                   CommonSkeleton(height: Sizes.s14, width: Sizes.s50),
                            //                                                   HSpace(Sizes.s5),
                            //                                                   CommonSkeleton(height: Sizes.s22, width: Sizes.s68, radius: 12)
                            //                                                 ]),
                            //                                             VSpace(Sizes
                            //                                                 .s8),
                            //                                             CommonSkeleton(
                            //                                                 height:
                            //                                                     Sizes.s14,
                            //                                                 width: Sizes.s124),
                            //                                             VSpace(Sizes
                            //                                                 .s11),
                            //                                             CommonSkeleton(
                            //                                                 height:
                            //                                                     Sizes.s14,
                            //                                                 width: Sizes.s124)
                            //                                           ]),
                            //                                       CommonSkeleton(
                            //                                           height: Sizes
                            //                                               .s84,
                            //                                           width: Sizes
                            //                                               .s84,
                            //                                           radius:
                            //                                               10)
                            //                                     ]),
                            //                                 const VSpace(
                            //                                     Sizes.s15),
                            //                                 const Row(
                            //                                     mainAxisAlignment:
                            //                                         MainAxisAlignment
                            //                                             .spaceBetween,
                            //                                     children: [
                            //                                       CommonSkeleton(
                            //                                           height: Sizes
                            //                                               .s14,
                            //                                           width: Sizes
                            //                                               .s40),
                            //                                       CommonSkeleton(
                            //                                           height: Sizes
                            //                                               .s22,
                            //                                           width: Sizes
                            //                                               .s66,
                            //                                           radius:
                            //                                               12),
                            //                                     ]),
                            //                                 const VSpace(
                            //                                     Sizes.s14),
                            //                                 const Row(
                            //                                     mainAxisAlignment:
                            //                                         MainAxisAlignment
                            //                                             .spaceBetween,
                            //                                     children: [
                            //                                       CommonSkeleton(
                            //                                           height: Sizes
                            //                                               .s14,
                            //                                           width: Sizes
                            //                                               .s116),
                            //                                       CommonSkeleton(
                            //                                           height: Sizes
                            //                                               .s14,
                            //                                           width: Sizes
                            //                                               .s76),
                            //                                     ]),
                            //                                 const VSpace(
                            //                                     Sizes.s15),
                            //                                 const Row(
                            //                                     mainAxisAlignment:
                            //                                         MainAxisAlignment
                            //                                             .spaceBetween,
                            //                                     children: [
                            //                                       CommonSkeleton(
                            //                                           height: Sizes
                            //                                               .s14,
                            //                                           width: Sizes
                            //                                               .s106),
                            //                                       CommonSkeleton(
                            //                                           height: Sizes
                            //                                               .s14,
                            //                                           width: Sizes
                            //                                               .s76)
                            //                                     ]),
                            //                                 const VSpace(
                            //                                     Sizes.s15),
                            //                                 const Row(
                            //                                     mainAxisAlignment:
                            //                                         MainAxisAlignment
                            //                                             .spaceBetween,
                            //                                     children: [
                            //                                       CommonSkeleton(
                            //                                           height: Sizes
                            //                                               .s14,
                            //                                           width: Sizes
                            //                                               .s106),
                            //                                       CommonSkeleton(
                            //                                           height: Sizes
                            //                                               .s14,
                            //                                           width: Sizes
                            //                                               .s76)
                            //                                     ]),
                            //                                 const VSpace(
                            //                                     Sizes.s12),
                            //                                 const Row(
                            //                                     mainAxisAlignment:
                            //                                         MainAxisAlignment
                            //                                             .spaceBetween,
                            //                                     children: [
                            //                                       CommonSkeleton(
                            //                                           height: Sizes
                            //                                               .s14,
                            //                                           width: Sizes
                            //                                               .s106),
                            //                                       CommonSkeleton(
                            //                                           height: Sizes
                            //                                               .s14,
                            //                                           width: Sizes
                            //                                               .s106)
                            //                                     ]),
                            //                                 const VSpace(
                            //                                     Sizes.s17),
                            //                                 Stack(
                            //                                     alignment:
                            //                                         Alignment
                            //                                             .center,
                            //                                     children: [
                            //                                       const CommonSkeleton(
                            //                                           height: Sizes
                            //                                               .s68,
                            //                                           radius:
                            //                                               8),
                            //                                       const Row(
                            //                                           mainAxisAlignment:
                            //                                               MainAxisAlignment
                            //                                                   .spaceBetween,
                            //                                           children: [
                            //                                             Row(
                            //                                                 children: [
                            //                                                   CommonWhiteShimmer(height: Sizes.s36, width: Sizes.s36, isCircle: true),
                            //                                                   HSpace(Sizes.s9),
                            //                                                   Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            //                                                     CommonWhiteShimmer(height: Sizes.s10, width: Sizes.s55),
                            //                                                     VSpace(Sizes.s5),
                            //                                                     CommonWhiteShimmer(height: Sizes.s12, width: Sizes.s78)
                            //                                                   ])
                            //                                                 ]),
                            //                                             CommonWhiteShimmer(
                            //                                                 height:
                            //                                                     Sizes.s12,
                            //                                                 width: Sizes.s30)
                            //                                           ]).paddingSymmetric(
                            //                                           horizontal:
                            //                                               Sizes
                            //                                                   .s12)
                            //                                     ])
                            //                               ])
                            //                                   .padding(
                            //                                       horizontal:
                            //                                           Sizes.s15,
                            //                                       top: Sizes
                            //                                           .s23,
                            //                                       bottom: Sizes
                            //                                           .s15)
                            //                                   .boxBorderExtension(
                            //                                       context,
                            //                                       color: isDark(
                            //                                               context)
                            //                                           ? Colors
                            //                                               .black26
                            //                                           : appColor(
                            //                                                   context)
                            //                                               .whiteColor,
                            //                                       bColor: isDark(
                            //                                               context)
                            //                                           ? Colors
                            //                                               .grey
                            //                                               .withOpacity(
                            //                                                   .2)
                            //                                           : appColor(
                            //                                                   context)
                            //                                               .stroke)
                            //                                   .paddingOnly(
                            //                                       bottom:
                            //                                           Sizes.s15)
                            //                             ],
                            //                           );
                            //                         })
                            //                     .paddingSymmetric(
                            //                         horizontal: Insets.i20),
                            //               )
                            //             : Expanded(
                            //                 child: ListView.builder(
                            //                     controller:
                            //                         value.scrollController,
                            //                     itemCount:
                            //                         value.bookingList.length,
                            //                     itemBuilder: (context, index) {
                            //                       return BookingLayout(
                            //                           data: value
                            //                               .bookingList[index],
                            //                           index: index,
                            //                           editLocationTap: () =>
                            //                               value.editAddress(
                            //                                   context,
                            //                                   value.bookingList[
                            //                                       index]),
                            //                           editDateTimeTap: () =>
                            //                               value.editDateTimeTap(
                            //                                   context,
                            //                                   value.bookingList[
                            //                                       index]),
                            //                           onTap: () {
                            //                             print(
                            //                                 "object====> ${value.bookingList[index]} ");
                            //                             value.onTapBookings(
                            //                                 value.bookingList[
                            //                                     index],
                            //                                 context);
                            //                           });
                            //                     }),
                            //               )
                            //         : EmptyLayout(
                            //             title: translations!.ohhNoList,
                            //             subtitle: translations!.yourBookingList,
                            //             buttonText: translations!.refresh,
                            //             isButtonShow: false,
                            //             /*   bTap: () {
                            //               Fluttertoast.showToast(
                            //                   msg:
                            //                       "${language(context, translations!.refresh)}...");
                            //               dash.getBookingHistory(context);
                            //             }, */
                            //             widget: Stack(children: [
                            //               Image.asset(eImageAssets.noList,
                            //                   height: Sizes.s250)
                            //             ])),
                            // VSpace(dash.isTap ? 0 : Insets.i80)
                          ])
                      /*  : EmptyLayout(
                                  title: translations!.ohhNoList,
                                  subtitle: translations!.yourBookingList,
                                  buttonText: translations!.refresh,
                                  bTap: () {
                                    Fluttertoast.showToast(
                                        msg:
                                            "${language(context, translations!.refresh)}...");
                                    dash.getBookingHistory(context);
                                  },
                                  widget: Stack(children: [
                                    Image.asset(eImageAssets.noList,
                                        height: Sizes.s306)
                                  ])) */
                      )),
        );
      });
    });
  }
}
