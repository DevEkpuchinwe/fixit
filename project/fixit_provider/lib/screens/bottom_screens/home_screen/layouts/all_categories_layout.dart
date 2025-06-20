import 'dart:developer';

import 'package:fixit_provider/screens/app_pages_screens/custom_job_request/job_request_list/layouts/job_request_list_card.dart';
import 'package:fixit_provider/screens/bottom_screens/home_screen/layouts/latest_home_blog.dart';

import '../../../../common_shimmer/expert_service_shimmer.dart';
import '../../../../common_shimmer/service_shimmer.dart';
import '../../../../config.dart';
import '../../../app_pages_screens/custom_job_request/job_request_list/layouts/latest_job_request.dart'
    show LatestJobRequestListCard;
import '../../../app_pages_screens/service_list_screen/service_shimmer/service_shimmer.dart';
import '../../booking_screen/layouts/home_booking_layout.dart'
    show HomeBookingLayout;
import 'home_popular_service.dart' show HomeFeaturedServicesLayout;

class AllCategoriesLayout extends StatelessWidget {
  const AllCategoriesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer4<ServiceDetailsProvider, HomeProvider, DashboardProvider,
            UserDataApiProvider>(
        builder: (context, serviceCtrl, value, dashCtrl, userApi, child) {
      // log("booking.bookingList::${userApi.bookingList}");
      return StatefulWrapper(
        onInit: () async {},
        child: Column(
          children: [
            if (!isServiceman)
              if (dashBoardModel != null /*|| dashBoardModel!.booking != null*/)
                dashBoardModel!.booking!.isNotEmpty
                    ? Column(
                        children: [
                          HeadingRowCommon(
                              isViewAllShow:
                                  dashBoardModel!.booking!.length >= 10,
                              title: translations!.recentBooking,
                              onTap: () => value.onTapIndexOne(dashCtrl)),
                          const VSpace(Sizes.s15),
                          Column(
                            children: dashBoardModel!.booking!
                                .map((e) => HomeBookingLayout(
                                    data: e,
                                    onTap: () =>
                                        value.onTapHomeBookings(e, context)))
                                .toList(),
                          ),
                        ],
                      )
                        .padding(
                            horizontal: Insets.i20,
                            top: Insets.i25,
                            bottom: Insets.i10)
                        .decorated(color: appColor(context).appTheme.whiteBg)
                    : Container(
                        color: (isDark(context)
                            ? const Color(0xFF202020).withOpacity(.6)
                            : Colors.grey.withOpacity(0.2)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.s20, vertical: Sizes.s28),
                        child: Column(children: [
                          const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonWhiteShimmer(
                                    height: Sizes.s17, width: Sizes.s184),
                                CommonWhiteShimmer(
                                    height: Sizes.s17, width: Sizes.s48)
                              ]),
                          const VSpace(Sizes.s17),
                          ...List.generate(
                              2,
                              (index) => Stack(children: [
                                    const CommonWhiteShimmer(
                                      height: Sizes.s435,
                                      radius: 12,
                                    ).marginOnly(
                                        bottom: index == 0 ? Sizes.s28 : 0),
                                    Column(children: [
                                      const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CommonSkeleton(
                                                      height: Sizes.s10,
                                                      width: Sizes.s52),
                                                  VSpace(Sizes.s16),
                                                  CommonSkeleton(
                                                      height: Sizes.s10,
                                                      width: Sizes.s160),
                                                  VSpace(Sizes.s16),
                                                  CommonSkeleton(
                                                      height: Sizes.s10,
                                                      width: Sizes.s160)
                                                ]),
                                            CommonSkeleton(
                                                height: Sizes.s84,
                                                width: Sizes.s84,
                                                radius: 10)
                                          ]),
                                      const VSpace(Sizes.s12),
                                      Image.asset(eImageAssets.bulletDotted)
                                          .padding(bottom: Insets.i18),
                                      const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
                                          alignment: Alignment.centerLeft,
                                          children: [
                                            const CommonSkeleton(
                                                height: Sizes.s60, radius: 10),
                                            const Row(children: [
                                              CommonWhiteShimmer(
                                                  height: Sizes.s36,
                                                  width: Sizes.s36,
                                                  isCircle: true),
                                              HSpace(Sizes.s8),
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CommonWhiteShimmer(
                                                        height: Sizes.s10,
                                                        width: Sizes.s55),
                                                    VSpace(Sizes.s7),
                                                    CommonWhiteShimmer(
                                                        height: Sizes.s10,
                                                        width: Sizes.s90)
                                                  ])
                                            ]).padding(horizontal: Sizes.s12)
                                          ]),
                                      const VSpace(Sizes.s10),
                                      const CommonSkeleton(
                                              height: Sizes.s10,
                                              width: Sizes.s150)
                                          .alignment(Alignment.centerLeft),
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
                                        horizontal: Sizes.s15, top: Sizes.s25)
                                  ]))
                        ])),
            if (latestServiceRequest.isNotEmpty)
            const VSpace(Sizes.s25),
            if (latestServiceRequest.isNotEmpty)
              Column(children: [
                HeadingRowCommon(
                        isViewAllShow: latestServiceRequest.length >= 2,
                        title: translations!.customJobRequest,
                        onTap: () =>
                            route.pushNamed(context, routeName.jobRequestList))
                    .paddingSymmetric(horizontal: Insets.i20),
                const VSpace(Sizes.s15),
                Column(children: [
                  ...latestServiceRequest
                      .asMap()
                      .entries
                      .map((e) => LatestJobRequestListCard(
                            data: e.value,
                          ).paddingSymmetric(horizontal: Insets.i20))
                ])
              ]),
            if(latestServiceRequest.isNotEmpty)
            const VSpace(Sizes.s25),
            popularServiceHome.isNotEmpty
                ? Column(children: [
                    HeadingRowCommon(
                            isViewAllShow: popularServiceList.length <= 10,
                            title: translations?.popularService,
                            onTap: () => route.pushNamed(
                                context, routeName.popularServiceScreen))
                        .paddingSymmetric(horizontal: Insets.i20),
                    if (popularServiceHome.isNotEmpty) const VSpace(Sizes.s15),
                    Column(children: [
                      ...popularServiceHome.toList().asMap().entries.map((e) =>
                          HomeFeaturedServicesLayout(
                              data: e.value,
                              onToggle: (val) =>
                                  userApi.updateActiveStatusService(
                                      context, e.value.id, val, e.key),
                              onTap: () {
                                serviceCtrl.getServiceFaqId(
                                    context, e.value.id);
                                route.pushNamed(context,
                                    routeName.homeServicesDetailsScreen,
                                    arg: e.value);
                              }).paddingSymmetric(horizontal: Insets.i20))
                    ])
                  ])
                : const ServicesShimmer(count: 1),
            const VSpace(Sizes.s10),
            if (appSettingModel?.activation?.blogsEnable == "1")
              latestBlogs.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeadingRowCommon(
                                title: translations!.latestBlog,
                                isViewAllShow: blogList.length >= 10,
                                onTap: () => route.pushNamed(
                                    context, routeName.latestBlogViewAll))
                            .paddingSymmetric(horizontal: Insets.i20),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                    children: latestBlogs
                                        .asMap()
                                        .entries
                                        .map((e) =>
                                            HomeLatestBlogLayout(data: e.value))
                                        .toList())
                                .paddingOnly(left: Insets.i20))
                      ],
                    )
                  : Container(
                      color: (isDark(context)
                          ? const Color(0xFF202020).withOpacity(.6)
                          : Colors.grey.withOpacity(0.2)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.s20, vertical: Sizes.s28),
                      child: Column(children: [
                        const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonWhiteShimmer(
                                  height: Sizes.s17, width: Sizes.s184),
                              CommonWhiteShimmer(
                                  height: Sizes.s17, width: Sizes.s48)
                            ]),
                        const VSpace(Sizes.s17),
                        ...List.generate(
                            2,
                            (index) => Stack(children: [
                                  const CommonWhiteShimmer(
                                    height: Sizes.s435,
                                    radius: 12,
                                  ).marginOnly(
                                      bottom: index == 0 ? Sizes.s28 : 0),
                                  Column(children: [
                                    const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CommonSkeleton(
                                                    height: Sizes.s10,
                                                    width: Sizes.s52),
                                                VSpace(Sizes.s16),
                                                CommonSkeleton(
                                                    height: Sizes.s10,
                                                    width: Sizes.s160),
                                                VSpace(Sizes.s16),
                                                CommonSkeleton(
                                                    height: Sizes.s10,
                                                    width: Sizes.s160)
                                              ]),
                                          CommonSkeleton(
                                              height: Sizes.s84,
                                              width: Sizes.s84,
                                              radius: 10)
                                        ]),
                                    const VSpace(Sizes.s12),
                                    Image.asset(eImageAssets.bulletDotted)
                                        .padding(bottom: Insets.i18),
                                    const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                            MainAxisAlignment.spaceBetween,
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
                                            MainAxisAlignment.spaceBetween,
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
                                            MainAxisAlignment.spaceBetween,
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
                                            MainAxisAlignment.spaceBetween,
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
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          const CommonSkeleton(
                                              height: Sizes.s60, radius: 10),
                                          const Row(children: [
                                            CommonWhiteShimmer(
                                                height: Sizes.s36,
                                                width: Sizes.s36,
                                                isCircle: true),
                                            HSpace(Sizes.s8),
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CommonWhiteShimmer(
                                                      height: Sizes.s10,
                                                      width: Sizes.s55),
                                                  VSpace(Sizes.s7),
                                                  CommonWhiteShimmer(
                                                      height: Sizes.s10,
                                                      width: Sizes.s90)
                                                ])
                                          ]).padding(horizontal: Sizes.s12)
                                        ]),
                                    const VSpace(Sizes.s10),
                                    const CommonSkeleton(
                                            height: Sizes.s10,
                                            width: Sizes.s150)
                                        .alignment(Alignment.centerLeft),
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
                                      horizontal: Sizes.s15, top: Sizes.s25)
                                ]))
                      ]))
          ],
        ),
      );
    });
  }
}
