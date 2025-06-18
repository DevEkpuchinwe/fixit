// ignore_for_file: deprecated_member_use

import 'package:fixit_user/common_tap.dart';
import 'package:fixit_user/screens/app_pages_screens/services_details_screen/layouts/service_faq.dart';
import 'package:fixit_user/screens/app_pages_screens/services_details_screen/layouts/services_add_on.dart';
import 'package:fixit_user/screens/app_pages_screens/services_details_screen/service_detail_shimmer/services_details_shimmer.dart';

import '../../../config.dart';

import 'dart:developer';

class ServicesDetailsScreen extends StatelessWidget {
  const ServicesDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavouriteListProvider>(builder: (context2, favCtrl, child) {
      return Consumer<ServicesDetailsProvider>(
          builder: (context1, serviceCtrl, child) {
        return Container(
          color: appColor(context).whiteBg,
          child: SafeArea(
            child: StatefulWrapper(
                onInit: () => Future.delayed(DurationClass.ms50)
                    .then((val) => serviceCtrl.onReady(context)),
                child: PopScope(
                    // canPop: true,

                    /* onPopInvoked: (didPop) {
                      serviceCtrl.onBack(context, false);
                      if (didPop) return;
                    }, */
                    child: RefreshIndicator(
                  onRefresh: () {
                    return serviceCtrl.onRefresh(context);
                  },
                  child: (serviceCtrl.widget1Opacity ==
                          0.0) /* ||
                          serviceCtrl.service!.categories == null */
                      ? const ServiceDetailShimmer()
                      : Scaffold(
                          body: AnimatedOpacity(
                          duration: const Duration(milliseconds: 1200),
                          opacity: serviceCtrl.widget1Opacity,
                          child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                SingleChildScrollView(
                                    controller: serviceCtrl.scrollController,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ServiceImageLayout(
                                            onBack: () => serviceCtrl.onBack(
                                                context, true),
                                            isFav: favCtrl.serviceFavList
                                                .where((element) =>
                                                    element.serviceId != null &&
                                                    element.serviceId
                                                            .toString() ==
                                                        serviceCtrl.service!.id
                                                            .toString())
                                                .isNotEmpty,
                                            title: serviceCtrl.service!.title!,
                                            image: serviceCtrl
                                                    .service!.media!.isNotEmpty
                                                ? serviceCtrl
                                                    .service!
                                                    .media![serviceCtrl
                                                        .selectedIndex]
                                                    .originalUrl!
                                                : "",
                                            rating: serviceCtrl
                                                .service!.ratingCount
                                                ?.toString(),
                                            favTap: (p0) {
                                              log("FAV : $p0");
                                              if (p0) {
                                                favCtrl.addToFav(
                                                    context,
                                                    serviceCtrl.service!.id,
                                                    'service');
                                              } else {
                                                favCtrl.deleteToFav(
                                                    context,
                                                    serviceCtrl.service!.id,
                                                    'service');
                                              }
                                            },
                                          ),
                                          if (serviceCtrl
                                                  .service!.media!.length >
                                              1)
                                            const VSpace(Sizes.s12),
                                          if (serviceCtrl.service!.media!.length >
                                              1)
                                            serviceCtrl.service!.media != null &&
                                                    serviceCtrl.service!.media!
                                                        .isNotEmpty &&
                                                    serviceCtrl.service!.media!
                                                            .length <
                                                        4
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: serviceCtrl
                                                        .service!.media!
                                                        .asMap()
                                                        .entries
                                                        .map((e) => ServicesImageLayout(
                                                            data: e.value,
                                                            index: e.key,
                                                            selectIndex:
                                                                serviceCtrl
                                                                    .selectedIndex,
                                                            onTap: () =>
                                                                serviceCtrl
                                                                    .onImageChange(
                                                                        e.key)))
                                                        .toList())
                                                : SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: serviceCtrl
                                                            .service!.media!
                                                            .asMap()
                                                            .entries
                                                            .map((e) => ServicesImageLayout(
                                                                data: e.value,
                                                                index: e.key,
                                                                selectIndex:
                                                                    serviceCtrl
                                                                        .selectedIndex,
                                                                onTap: () =>
                                                                    serviceCtrl
                                                                        .onImageChange(
                                                                            e.key)))
                                                            .toList()),
                                                  ).paddingOnly(left: Sizes.s20),
                                          Column(children: [
                                            Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Image.asset(
                                                      eImageAssets.servicesBg,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            language(
                                                                context,
                                                                translations!
                                                                    .amount),
                                                            style: appCss
                                                                .dmDenseMedium12
                                                                .textColor(appColor(
                                                                        context)
                                                                    .primary)),
                                                        Text(
                                                            "${getSymbol(context)}${(currency(context).currencyVal * (serviceCtrl.service!.serviceRate!)).toStringAsFixed(2)}",
                                                            style: appCss
                                                                .dmDenseBold18
                                                                .textColor(appColor(
                                                                        context)
                                                                    .primary))
                                                      ]).paddingSymmetric(
                                                      horizontal: Insets.i20)
                                                ]).paddingSymmetric(
                                                vertical: Insets.i15),
                                            ServiceDescription(
                                                services: serviceCtrl.service),
                                          ]).paddingSymmetric(
                                              horizontal: Insets.i20),
                                          if (appSettingModel!.activation!
                                                  .additionalServices ==
                                              "1")
                                            if (serviceCtrl.service!
                                                    .additionalServices !=
                                                null)
                                              const ServicesAddOn(),
                                          if (serviceCtrl.serviceFaq.isNotEmpty)
                                            const ServiceFaq(),
                                          /*  if (serviceCtrl
                                              .service!.reviews!.isNotEmpty)
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                          language(
                                                              context,
                                                              translations!
                                                                  .review),
                                                          overflow:
                                                              TextOverflow.clip,
                                                          style: appCss
                                                              .dmDenseSemiBold14
                                                              .textColor(appColor(
                                                                      context)
                                                                  .darkText))),
                                                  Text(
                                                          language(
                                                              context,
                                                              translations!
                                                                  .viewAll),
                                                          style: appCss
                                                              .dmDenseRegular14
                                                              .textColor(appColor(
                                                                      context)
                                                                  .primary))
                                                      .inkWell(
                                                          onTap: () =>
                                                              route.pushNamed(
                                                                  context,
                                                                  routeName
                                                                      .servicesReviewScreen,
                                                                  arg: serviceCtrl
                                                                      .service))
                                                ]).paddingOnly(
                                                top: Insets.i20,
                                                bottom: Insets.i12), */
                                          /* if (serviceCtrl
                                                  .service!.reviews!.length >
                                              3)
                                            ...serviceCtrl.service!.reviews!
                                                .getRange(0, 3)
                                                .toList()
                                                .asMap()
                                                .entries
                                                .map((e) => ServiceReviewLayout(
                                                    data: e.value,
                                                    index: e.key,
                                                    list: serviceCtrl
                                                        .service!.reviews)),
                                          if (serviceCtrl
                                                  .service!.reviews!.length >
                                              3)
                                            ...serviceCtrl.service!.reviews!
                                                .asMap()
                                                .entries
                                                .map((e) => ServiceReviewLayout(
                                                    data: e.value,
                                                    index: e.key,
                                                    list: serviceCtrl
                                                        .service!.reviews)),
                                          if (serviceCtrl.service!
                                                      .relatedServices !=
                                                  null &&
                                              serviceCtrl.service!
                                                  .relatedServices!.isNotEmpty) */
                                          HeadingRowCommon(
                                            title: translations!.alsoProvided,
                                            onTap: () => route.pushNamed(
                                                context,
                                                routeName.providerDetailsScreen,
                                                arg: {
                                                  'provider':
                                                      serviceCtrl.service!.user
                                                }),
                                          ).padding(
                                              top: Insets.i25,
                                              bottom: Insets.i15,
                                              horizontal: Insets.i20),
                                          if (serviceCtrl.service!
                                                      .relatedServices !=
                                                  null &&
                                              serviceCtrl.service!
                                                  .relatedServices!.isNotEmpty)
                                            SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: serviceCtrl
                                                        .service!
                                                        .relatedServices!
                                                        .asMap()
                                                        .entries
                                                        .map((e) =>
                                                            ServiceListLayout(
                                                              data: e.value,
                                                              favTap: (p0) {
                                                                log("FAV : $p0");
                                                                if (p0) {
                                                                  favCtrl.addToFav(
                                                                      context,
                                                                      e.value
                                                                          .id,
                                                                      'service');
                                                                } else {
                                                                  favCtrl.deleteToFav(
                                                                      context,
                                                                      e.value
                                                                          .id,
                                                                      'service');
                                                                }
                                                              },
                                                              onTap: () => serviceCtrl
                                                                  .onFeatured(
                                                                      context,
                                                                      e.value,
                                                                      e.key),
                                                              isFav: favCtrl
                                                                  .serviceFavList
                                                                  .where((element) =>
                                                                      element.serviceId !=
                                                                          null &&
                                                                      element.serviceId ==
                                                                          e.value
                                                                              .id
                                                                              .toString())
                                                                  .isNotEmpty,
                                                            )
                                                                .inkWell(
                                                                    onTap: () =>
                                                                        route.pushNamed(context, routeName.servicesDetailsScreen, arg: {'services': e.value}))
                                                                .paddingOnly(left: Insets.i20))
                                                        .toList())),
                                        ]).marginOnly(bottom: Insets.i100)),
                                /*                  ButtonCommon(
                                margin: Insets.i20,
                                title: translations!.addToCart,
                                onTap: () => onBook(context, serviceCtrl.service!,
                                        addTap: () => serviceCtrl.onAdd(),
                                        minusTap: () =>
                                            serviceCtrl.onRemoveService(context))
                                    .then((e) {
                                  serviceCtrl
                                          .service!.selectedRequiredServiceMan =
                                      serviceCtrl.service!.requiredServicemen;
                                  serviceCtrl.notifyListeners();
                                }),
                              ).paddingOnly(bottom: Insets.i20).decorated(
                                  color: appColor(context).whiteBg)*/
                                ButtonCommon(
                                        margin: Insets.i20,
                                        title: translations!.addToCart,
                                        onTap: () {
                                          final providerDetail = Provider.of<
                                                  ProviderDetailsProvider>(
                                              context,
                                              listen: false);
                                          providerDetail.selectProviderIndex =
                                              0;
                                          providerDetail.notifyListeners();
                                          serviceCtrl.service!
                                                  .selectedAdditionalServices =
                                              serviceCtrl.additionalService;
                                          serviceCtrl.notifyListeners();
                                          onBook(context, serviceCtrl.service!,
                                              addTap: () => serviceCtrl.onAdd(),
                                              minusTap: () =>
                                                  serviceCtrl.onRemoveService(
                                                      context)).then((e) {
                                            serviceCtrl.service!
                                                    .selectedRequiredServiceMan =
                                                serviceCtrl.service!
                                                    .requiredServicemen;
                                            serviceCtrl.notifyListeners();
                                          });
                                        })
                                    .marginOnly(bottom: Insets.i20)
                                    .backgroundColor(appColor(context).whiteBg)
                              ]),
                        )),
                ))),
          ),
        );
      });
    });
  }
}
