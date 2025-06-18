import 'dart:developer';

import '../../../../config.dart';
import 'horizontal_blog_list.dart';
import 'new_job_request_layout.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<DashboardProvider, HomeScreenProvider, CommonApiProvider>(
        builder: (context3, dash, value, commonApi, child) {
      return StatefulWrapper(
        onInit: () {},
        /*   onInit: () => Future.delayed(
            const Duration(milliseconds: 100), () => dash.getCoupons()), */
        child: ListView(children: [
          /* dash.isBannerLoader
              ? Column(
                  children: [
                    Stack(children: [
                      const CommonSkeleton(height: Sizes.s224, radius: 0),
                      const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonWhiteShimmer(width: Sizes.s70),
                            VSpace(Sizes.s12),
                            CommonWhiteShimmer(width: Sizes.s175),
                            VSpace(Sizes.s12),
                            CommonWhiteShimmer(width: Sizes.s130),
                            VSpace(Sizes.s30),
                            CommonWhiteShimmer(
                                width: Sizes.s82, height: Sizes.s34)
                          ]).paddingSymmetric(
                          horizontal: Sizes.s25, vertical: Sizes.s40)
                    ]),
                    const VSpace(Sizes.s3),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonSkeleton(height: Sizes.s5, width: Sizes.s15),
                          HSpace(Sizes.s3),
                          CommonSkeleton(
                              height: Sizes.s5, width: Sizes.s5, isCircle: true)
                        ])
                  ],
                )
              :  */
          Column(
            children: [
              if (commonApi.dashboardModel!.banners!
                      .isNotEmpty /* dash.bannerList
                      .isNotEmpty */ /* &&
              dash.bannerList.any((banner) => banner.media!.isNotEmpty) */
                  )
                BannerLayout(
                    bannerList: commonApi.dashboardModel!.banners,
                    onPageChanged: (index, reason) =>
                        value.onSlideBanner(index),
                    onTap: commonApi.isLoading == true
                        ? (type, id) {
                            print("object=-===-=-=-=-=-=-=-=-=");
                          }
                        : (type, id) => value.onBannerTap(context, type, id)),
              if (dash.bannerList.length > 1 &&
                  dash.bannerList.any((banner) => banner.media!.isNotEmpty))
                const VSpace(Sizes.s12),
              if (dash.bannerList.length > 1 &&
                  dash.bannerList.any((banner) => banner.media!.isNotEmpty))
                DotIndicator(
                    list: dash.bannerList, selectedIndex: value.selectIndex),
              if (dash.bannerList.isNotEmpty &&
                  dash.bannerList.any((banner) => banner.media!.isNotEmpty))
                const VSpace(Sizes.s20),
            ],
          ),
          /*  dash.isCoupons
              ? Column(
                  children: [
                    const VSpace(Sizes.s30),
                    const RowText().paddingSymmetric(horizontal: Sizes.s20),
                    const VSpace(Sizes.s20),
                    const HomeCouponShimmer()
                  ],
                )
              : */
          Column(
            children: [
              if (commonApi.dashboardModel!.coupons!
                  .isNotEmpty /* dash.couponList.isNotEmpty */)
                HeadingRowCommon(
                        title: translations!.coupons,
                        isTextSize: true,
                        onTap: () => route.pushNamed(
                            context, routeName.couponListScreen, arg: true))
                    .paddingSymmetric(horizontal: Insets.i20),
              if (commonApi.dashboardModel!.coupons!
                  .isNotEmpty /* dash.couponList.isNotEmpty */)
                const VSpace(Sizes.s15),
              /*  if (dash.couponList.isNotEmpty)
                SizedBox(
                  height: Sizes.s70,
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: dash.couponList.length,
                      itemBuilder: (context, index) {
                        return HomeCouponLayout(data: dash.couponList[index]);
                      }),
                ), */
              if (commonApi.dashboardModel!.coupons!
                  .isNotEmpty /* dash.couponList.isNotEmpty */)
                SizedBox(
                  height: Sizes.s70,
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: commonApi.dashboardModel!.coupons
                          ?.length /* dash.couponList.length */,
                      itemBuilder: (context, index) {
                        return HomeCouponLayout(
                            data: commonApi.dashboardModel!
                                .coupons![index] /* dash.couponList[index] */);
                      }),
                ),
            ],
          ),

          /*   SingleChildScrollView( https://laravel.webiots.co.in/fixit/api/service?categoryIds=8&min=0&max260&zone_ids=1
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: dash.couponList
                        .asMap()
                        .entries
                        .map((e) => HomeCouponLayout(data: e.value))
                        .toList())), */
          // const RowText().paddingSymmetric(horizontal: Sizes.s20),
          // const VSpace(Sizes.s17),
          // const GridShimmer(),
          VSpace(/* dash.couponList.isNotEmpty */ commonApi
                  .dashboardModel!.coupons!.isNotEmpty
              ? Sizes.s25
              : Sizes.s15),
          const CategoryFeaturePackageServices(),
          if (dash.firstTwoHighRateList.isNotEmpty ||
              dash.highestRateList.isNotEmpty)
            const VSpace(Sizes.s25),
          if (appSettingModel != null &&
              appSettingModel!.activation!.blogsEnable == "1")
            /*   dash.isBlogList
                ? Column(
                    children: [
                      const RowText()
                          .padding(horizontal: Sizes.s20, bottom: Sizes.s17),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            ...List.generate(2, (index) {
                              return const BlogShimmerLayout();
                            })
                          ]).marginSymmetric(horizontal: Sizes.s20))
                    ],
                  )
                : */

            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (commonApi.dashboardModel!.blogs!
                  .isNotEmpty /* homeBlog.isNotEmpty */ /* dash.blogList.isNotEmpty */)
                HeadingRowCommon(
                  title: translations!.latestBlog,
                  isTextSize: true,
                  onTap: () =>
                      route.pushNamed(context, routeName.latestBlogViewAll),
                ).paddingSymmetric(horizontal: Insets.i20),
              HorizontalBlogList(
                blogList: commonApi.dashboardModel!
                    .blogs, /* firstTwoBlogList: dash.firstTwoBlogList */
              ),
              const VSpace(Sizes.s25)
            ]),
          /*  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (dash.blogList.isNotEmpty)
                HeadingRowCommon(
                  title: translations!.latestBlog,
                  isTextSize: true,
                  onTap: () =>
                      route.pushNamed(context, routeName.latestBlogViewAll),
                ).paddingSymmetric(horizontal: Insets.i20),
              HorizontalBlogList(
                  blogList: dash.blogList,
                  firstTwoBlogList: dash.firstTwoBlogList),
              const VSpace(Sizes.s25)
            ]), */
          const NewJobRequestLayout(),
          const VSpace(Sizes.s50)
        ]),
      );
    });
  }
}
