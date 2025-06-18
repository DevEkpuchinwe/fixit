import 'package:fixit_user/common_tap.dart';

import '../../../config.dart';

class ProviderDetailsScreen extends StatelessWidget {
  final String? id;

  const ProviderDetailsScreen({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return Consumer2<FavouriteListProvider, CategoriesDetailsProvider>(
        builder: (context1, favCtrl, categories, child) {
      return Consumer<ProviderDetailsProvider>(
          builder: (context, value, child) {
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            value.onBack(context, false);
            if (didPop) return;
          },
          child: StatefulWrapper(
            onInit: () => Future.delayed(DurationClass.ms50)
                .then((s) => value.onReady(context)),
            child: RefreshIndicator(
              onRefresh: () {
                return value.onRefresh(context);
              },
              child: /* value.widget1Opacity == 0.0
                  ? const Scaffold(body: ProviderDetailShimmer())
                  :
                  AnimatedOpacity(
                duration: const Duration(milliseconds: 1200),
                opacity: value.widget1Opacity,
                child: */
                  Scaffold(
                      appBar: AppBar(
                          leadingWidth: 80,
                          title: Text(
                              language(context, translations!.providerDetails),
                              style: appCss.dmDenseBold18
                                  .textColor(appColor(context).darkText)),
                          centerTitle: true,
                          leading: CommonArrow(
                                  arrow: eSvgAssets.arrowLeft,
                                  onTap: () => value.onBack(context, true))
                              .paddingAll(Insets.i8),
                          actions: [
                            value.provider != null
                                ? favCtrl.providerFavList
                                        .where((element) =>
                                            element.providerId ==
                                            value.provider!.id)
                                        .isNotEmpty
                                    ? SvgPicture.asset(
                                        eSvgAssets.heart,
                                      )
                                        .inkWell(
                                            onTap: () => favCtrl.deleteToFav(
                                                context,
                                                value.provider!.id,
                                                "provider"))
                                        .paddingOnly(right: Insets.i20)
                                    : CommonArrow(
                                            arrow: eSvgAssets.like,
                                            svgColor: appColor(context).primary,
                                            color: appColor(context)
                                                .primary
                                                .withValues(alpha: 0.15),
                                            onTap: () => favCtrl.addToFav(
                                                context,
                                                value.provider!.id,
                                                "provider"))
                                        .paddingOnly(right: Insets.i20)
                                : Container()
                          ]),
                      body: Consumer<CartProvider>(
                          builder: (context2, cart, child) {
                        return SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const ProviderTopLayout(),
                                if (value.categoryList.isNotEmpty)
                                  Text(
                                          language(context,
                                              translations!.provideServiceIn),
                                          style: appCss.dmDenseSemiBold16
                                              .textColor(
                                                  appColor(context).darkText))
                                      .paddingOnly(top: Insets.i25),
                                SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                            children: value.categoryList
                                                .asMap()
                                                .entries
                                                .map((e) => TopCategoriesLayout(
                                                    index: e.key,
                                                    data: e.value,
                                                    isExapnded: false,
                                                    selectedIndex:
                                                        value.selectIndex,
                                                    rPadding: Insets.i20,
                                                    onTap: () =>
                                                        value.onSelectService(
                                                            context,
                                                            e.key,
                                                            e.value.id)).marginOnly(
                                                    right: rtl(context)
                                                        ? 0
                                                        : Sizes.s10,
                                                    left: rtl(context)
                                                        ? Sizes.s10
                                                        : 0))
                                                .toList())
                                        .padding(vertical: Insets.i15)),
                                value.isCategoriesLoadeer == true
                                    ? const ServicesShimmer(count: 3)
                                    : ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(), // Disable scrolling if inside another scrollable widget
                                        shrinkWrap: true, // Wrap content size
                                        /*   padding: const EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                    20), // Adjust padding if needed */
                                        itemCount: value.serviceList.length,
                                        itemBuilder: (context, index) {
                                          final service =
                                              value.serviceList[index];
                                          return FeaturedServicesLayout(
                                            data: service,
                                            isProvider: true,
                                            inCart:
                                                isInCart(context, service.id),
                                            onTap: categories.isAlert
                                                ? () {}
                                                : () =>
                                                    categories.getServiceById(
                                                        context, service.id),
                                            addTap: () {
                                              final providerDetail = Provider
                                                  .of<ProviderDetailsProvider>(
                                                context,
                                                listen: false,
                                              );
                                              providerDetail
                                                  .selectProviderIndex = 0;
                                              providerDetail.notifyListeners();
                                              onBook(
                                                context,
                                                service,
                                                provider: service.user,
                                                addTap: () =>
                                                    value.onAdd(index),
                                                minusTap: () =>
                                                    value.onRemoveService(
                                                        context, index),
                                              ).then((_) {
                                                value.serviceList[index]
                                                        .selectedRequiredServiceMan =
                                                    value.serviceList[index]
                                                        .requiredServicemen;
                                                value.notifyListeners();
                                              });
                                            },
                                          );
                                        },
                                      )
                              ]).paddingAll(Insets.i20),
                        );
                      })),
            ),
          ),
          /*  ), */
        );
      });
    });
  }
}
