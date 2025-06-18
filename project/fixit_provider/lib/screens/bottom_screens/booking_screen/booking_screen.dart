import 'dart:developer';

import '../../../config.dart';
import 'booking_shimmer/booking_list_shimmer.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    return Consumer4<HomeProvider, BookingProvider, UserDataApiProvider,
        DashboardProvider>(
      builder: (context1, home, value, userApi, dash, child) {
        log("isFreelancer::$isFreelancer");

        return StatefulWrapper(
          onInit: () {
            // Check if data is already loaded before calling API
            if (value.bookingList.isEmpty) {
              Future.delayed(const Duration(milliseconds: 150),
                  () => value.onReady(context));
            }
          },
          child: Scaffold(
            appBar: AppBar(
              leadingWidth: 0,
              centerTitle: false,
              title: Text(language(context, translations!.bookings),
                  style: appCss.dmDenseBold18
                      .textColor(appColor(context).appTheme.darkText)),
              actions: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    CommonArrow(
                      arrow: eSvgAssets.filter,
                      onTap: () => value.onTapFilter(context),
                    ).paddingAll(Insets.i4),
                    if (value.totalCountFilter() != "0")
                      Container(
                        child: Text(value.totalCountFilter(),
                                style: appCss.dmDenseMedium8.textColor(
                                    appColor(context).appTheme.whiteColor))
                            .paddingAll(Insets.i5),
                      )
                          .decorated(
                              color: appColor(context).appTheme.red,
                              shape: BoxShape.circle)
                          .paddingOnly(top: Insets.i2, left: Insets.i2),
                  ],
                ),
                CommonArrow(
                  arrow: eSvgAssets.chat,
                  onTap: () => route.pushNamed(context, routeName.chatHistory),
                ).paddingSymmetric(horizontal: Insets.i10),
                CommonArrow(
                  arrow: eSvgAssets.notification,
                  onTap: () => route.pushNamed(context, routeName.notification),
                ),
                const HSpace(Sizes.s20),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await userApi.getBookingHistory(context);
              },
              child: NotificationListener(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      !userApi.isLoadingForBookingHistory &&
                      value.hasMoreData) {
                    userApi.getBookingHistory(context, isLoadMore: true);
                  }
                  return false;
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchTextFieldCommon(
                        suffixIcon: const Icon(Icons.close).inkWell(onTap: () {
                          value.searchCtrl.clear();
                          userApi.getBookingHistory(context,
                              search: value.searchCtrl.text);
                        }),
                        focusNode: value.searchFocus,
                        hinText: language(
                            context, translations!.searchWithBookingId),
                        controller: value.searchCtrl,
                        onChanged: (v) {
                          if (v.isEmpty || v.length > 2) {
                            userApi.getBookingHistory(context,
                                search: value.searchCtrl.text);
                          }
                        },
                        onFieldSubmitted: (v) =>
                            userApi.getBookingHistory(context, search: v),
                      ).padding(horizontal: Insets.i20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(language(context, translations!.allBooking),
                                  style: appCss.dmDenseMedium18.textColor(
                                      appColor(context).appTheme.darkText))
                              .paddingOnly(top: Insets.i25, bottom: Insets.i15),
                          if (!isFreelancer && !isServiceman)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Sizes.s200,
                                  child: Text(
                                      language(context,
                                          translations!.onlyViewBookings),
                                      style: appCss.dmDenseMedium12.textColor(
                                        value.isAssignMe
                                            ? appColor(context).appTheme.primary
                                            : appColor(context)
                                                .appTheme
                                                .darkText,
                                      )),
                                ),
                                FlutterSwitchCommon(
                                    value: value.isAssignMe,
                                    onToggle: (val) {
                                      value.onTapSwitch(val, context);
                                      hideLoading(context);
                                    }),
                              ],
                            )
                                .paddingAll(Insets.i15)
                                .boxShapeExtension(
                                    color: value.isAssignMe
                                        ? appColor(context)
                                            .appTheme
                                            .primary
                                            .withOpacity(0.15)
                                        : appColor(context)
                                            .appTheme
                                            .fieldCardBg,
                                    radius: AppRadius.r10)
                                .paddingOnly(bottom: Insets.i20),
                          if (!isFreelancer)
                            userApi.isLoadingForBookingHistory &&
                                    value.bookingList.isEmpty
                                ? const BookingListShimmer()
                                : value.bookingList.isNotEmpty
                                    ? Column(
                                        children: [
                                          ListView.builder(
                                            padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  value.bookingList.length,
                                              itemBuilder: (context, index) {
                                                return BookingLayout(
                                                    data: value
                                                        .bookingList[index],
                                                    onTap: () =>
                                                        value.onTapBookings(
                                                            value.bookingList[
                                                                index],
                                                            context));
                                              }),
                                          if (userApi
                                                  .isLoadingForBookingHistory &&
                                              value.hasMoreData)
                                            Image.asset(eGifAssets.loaderGif,height: Sizes.s80,width: Sizes.s80)
                                                .center()
                                                .paddingOnly(
                                                    bottom: Sizes.s120),
                                        ],
                                      )
                                    : EmptyLayout(
                                        isButton: false,
                                        title: translations!.ohhNoListEmpty,
                                        subtitle: translations!.yourBookingList,
                                        widget: Stack(
                                          children: [
                                            Image.asset(
                                              isFreelancer
                                                  ? eImageAssets.noListFree
                                                  : eImageAssets.noBooking,
                                              height: Sizes.s306,
                                            ),
                                          ],
                                        ),
                                      ),
                          if (isFreelancer)
                            value.bookingList.isNotEmpty
                                ? Column(
                                    children: value.bookingList
                                        .asMap()
                                        .entries
                                        .map((e) {
                                      return BookingLayout(
                                        data: e.value,
                                        onTap: () => home.onTapBookings(
                                            e.value, context),
                                      );
                                    }).toList(),
                                  )
                                : EmptyLayout(
                                    isButton: false,
                                    title: translations!.ohhNoListEmpty,
                                    subtitle: translations!.yourBookingList,
                                    widget: Stack(
                                      children: [
                                        Image.asset(
                                          isFreelancer
                                              ? eImageAssets.noListFree
                                              : eImageAssets.noBooking,
                                          height: Sizes.s306,
                                        ),
                                      ],
                                    ),
                                  ),
                        ],
                      ).padding(
                          horizontal: Insets.i20,
                          top: Insets.i15,
                          bottom: Insets.i50),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
