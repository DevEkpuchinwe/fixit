import 'dart:developer';

import 'package:fixit_user/screens/bottom_screens/offer_screen/offer_shimmer.dart';

import '../../../config.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen>
    with TickerProviderStateMixin {
  double widget1Opacity = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(milliseconds: 700), () {
      widget1Opacity = 1;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<DashboardProvider, ServicesDetailsProvider,
        CommonApiProvider>(builder: (context3, dash, value, commonApi, child) {
      // log("dash.offerList.isEmpty:3${dash.offerList.isEmpty}");
      return dash.offerList.isEmpty && widget1Opacity == 0.0
          ? const OfferShimmer()
          : StatefulWrapper(
              onInit: () => Future.delayed(DurationClass.ms50,
                  () => dash.onAnimateOfficer(this, context)),
              child: Scaffold(
                  appBar: AppBar(
                      title: Text(language(context, translations!.dealsZone),
                          style: appCss.dmDenseBold18
                              .textColor(appColor(context).darkText))),
                  body: RefreshIndicator(
                      onRefresh: () async {
                        dash.getOffer();
                      },
                      child: dash.offerList.isEmpty
                          ? const CommonEmpty()
                          : ListView(children: [
                              const VSpace(Sizes.s20),
                              if (dash.offerList.isNotEmpty)
                                ...dash.offerList.asMap().entries.map((e) {
                                  log("dash.offerList::${e.value.media}");
                                  return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(e.value.title ?? "",
                                            style: appCss.dmDenseBold16
                                                .textColor(appColor(context)
                                                    .darkText)),
                                        const VSpace(Sizes.s15),
                                        ...e.value.media!.reversed
                                            .toList()
                                            .asMap()
                                            .entries
                                            .map((m) => CommonImageLayout(
                                                    image: m.value.originalUrl!,
                                                    radius: AppRadius.r12,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: Sizes.s137,
                                                    assetImage: eImageAssets
                                                        .noImageFound2,
                                                    isAllBorderRadius: true)
                                                .inkWell(
                                                    onTap: value.isLoading ==
                                                                true ||
                                                            commonApi
                                                                    .isLoading ==
                                                                true
                                                        ? () {
                                                            print(
                                                                "object=================");
                                                          }
                                                        : () {
                                                            if (e.value.type ==
                                                                "service") {
                                                              route.pushNamed(
                                                                  context,
                                                                  routeName
                                                                      .servicesDetailsScreen,
                                                                  arg: {
                                                                    "serviceId": e
                                                                        .value
                                                                        .relatedId
                                                                  });
                                                            } else if (e.value
                                                                    .type ==
                                                                "category") {
                                                              dash.onBannerTap(
                                                                  context,
                                                                  e.value
                                                                      .relatedId);
                                                            } else {
                                                              route.pushNamed(
                                                                  context,
                                                                  routeName
                                                                      .providerDetailsScreen,
                                                                  arg: {
                                                                    'providerId': e
                                                                        .value
                                                                        .relatedId
                                                                  });
                                                            }
                                                          })
                                                .marginOnly(
                                                    bottom: m.key !=
                                                            e.value.media!
                                                                    .length -
                                                                1
                                                        ? Insets.i15
                                                        : Insets.i30))
                                      ]);
                                }),
                              const VSpace(Sizes.s50)
                            ]).paddingOnly(
                              right: Insets.i20, left: Insets.i20))),
            );
    });
  }
}
