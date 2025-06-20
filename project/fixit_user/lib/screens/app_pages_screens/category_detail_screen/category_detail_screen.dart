// ignore_for_file: unnecessary_null_comparison

import 'package:fixit_user/screens/app_pages_screens/category_detail_screen/category_detail_shimmer/category_detail_shimmer.dart';

import '../../../config.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesDetailsProvider>(
        builder: (context1, value, child) {
      return StatefulWrapper(
        onInit: () => Future.delayed(DurationClass.ms150)
            .then((val) => value.onReady(context)),
        child: PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            value.onBack(context, false, value.subCategoryId);
            if (didPop) return;
          },
          child: /* value.widget1Opacity == 1
              ? const CategoryDetailShimmer()
              : */
              Scaffold(
                  appBar: AppBarCommon(
                      title: value.categoryModel != null
                          ? value.categoryModel!.title
                          : "",
                      onTap: () =>
                          value.onBack(context, true, value.subCategoryId)),
                  body: RefreshIndicator(
                    onRefresh: () {
                      return value.onRefresh(context);
                    },
                    child: ListView(children: [
                      SearchTextFieldCommon(
                          controller: value.searchCtrl,
                          focusNode: value.searchFocus,
                          onChanged: (v) {
                            if (v.isEmpty) {
                              value.getServiceByCategoryId(
                                  context,
                                  value.categoryModel!.hasSubCategories !=
                                              null &&
                                          value.categoryModel!.hasSubCategories!
                                              .isNotEmpty
                                      ? value.categoryModel!
                                          .hasSubCategories![0].id
                                      : value.categoryModel!.id);
                            } else if (v.length > 3) {
                              value.getServiceByCategoryId(
                                  context,
                                  value.categoryModel!.hasSubCategories !=
                                              null &&
                                          value.categoryModel!.hasSubCategories!
                                              .isNotEmpty
                                      ? value.categoryModel!
                                          .hasSubCategories![0].id
                                      : value.categoryModel!.id);
                            }
                          },
                          onFieldSubmitted: (v) => value.getServiceByCategoryId(
                              context,
                              value.categoryModel!.hasSubCategories != null &&
                                      value.categoryModel!.hasSubCategories!
                                          .isNotEmpty
                                  ? value.categoryModel!.hasSubCategories![0].id
                                  : value.categoryModel!.id),
                          suffixIcon: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (value.searchCtrl.text.isNotEmpty)
                                Icon(Icons.cancel,
                                        color: appColor(context).darkText)
                                    .inkWell(onTap: () {
                                  value.searchCtrl.text = "";
                                  value.notifyListeners();
                                  value.getServiceByCategoryId(
                                      context,
                                      value.categoryModel!.hasSubCategories !=
                                                  null &&
                                              value.categoryModel!
                                                  .hasSubCategories!.isNotEmpty
                                          ? value.categoryModel!
                                              .hasSubCategories![0].id
                                          : value.categoryModel!.id);
                                }),
                              FilterIconCommon(
                                  selectedFilter:
                                      value.totalCountFilter().toString(),
                                  onTap: () => value.onBottomSheet(context)),
                            ],
                          )).paddingSymmetric(horizontal: Insets.i20),
                      /*  Text(homeCategoryList[1] /* .hasSubCategories?[0] */
                                      .title ??
                                  ""
                              /*  . /* hasSubCategories?[4]. */ title ??
                              "" */
                              )
                          .paddingSymmetric(horizontal: Insets.i20), */
                      /*  Text(value.hasCategoryList.length.toString()), */

                      /* Text(value.hasCategoryList.length.toString()), */
                      if (value.hasCategoryList.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(language(context, translations!.subCategories),
                                    style: appCss.dmDenseBold16
                                        .textColor(appColor(context).lightText))
                                .paddingOnly(
                              top: Insets.i15,
                              left: rtl(context) ? 0 : Insets.i20,
                              right: rtl(context) ? Insets.i20 : 0,
                            ),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: IntrinsicHeight(
                                  child: value.hasCategoryList == null
                                      ? Row(
                                          children: value
                                              .categoryModel!.hasSubCategories!
                                              .asMap()
                                              .entries
                                              .map((e) => TopCategoriesLayout(
                                                      index: e.key,
                                                      isCategories: true,
                                                      data: e.value,
                                                      selectedIndex:
                                                          value.selectedIndex,
                                                      onTap: () {
                                                        value.subCategoryId =
                                                            e.value.id;
                                                        print(
                                                            "object======> ${value.subCategoryId}");
                                                        value.onSubCategories(
                                                            context,
                                                            e.key,
                                                            e.value.id);
                                                      })
                                                  .paddingOnly(
                                                      right: Insets.i20))
                                              .toList(),
                                        )
                                      : Row(
                                          children: value.hasCategoryList
                                              .asMap()
                                              .entries
                                              .map((e) => TopCategoriesLayout(
                                                      index: e.key,
                                                      isCategories: true,
                                                      data: e.value,
                                                      selectedIndex:
                                                          value.selectedIndex,
                                                      onTap: () {
                                                        value.subCategoryId =
                                                            e.value.id;
                                                        print(
                                                            "object======> ${value.subCategoryId}");
                                                        value.onSubCategories(
                                                            context,
                                                            e.key,
                                                            e.value.id);
                                                      })
                                                  .paddingOnly(
                                                      right: Insets.i20))
                                              .toList(),
                                        )
                                          /*  Row(
                                          children: value
                                              .categoryModel!.hasSubCategories!
                                              .asMap()
                                              .entries
                                              .map((e) => TopCategoriesLayout(
                                                      index: e.key,
                                                      isCategories: true,
                                                      data: e.value,
                                                      selectedIndex:
                                                          value.selectedIndex,
                                                      onTap: () {
                                                        value.subCategoryId =
                                                            e.value.id;
                                                        print(
                                                            "object======> ${value.subCategoryId}");
                                                        value.onSubCategories(
                                                            context,
                                                            e.key,
                                                            e.value.id);
                                                      })
                                                  .paddingOnly(
                                                      right: Insets.i20))
                                              .toList()) */
                                          .padding(
                                              vertical: Insets.i15,
                                              left: Insets.i20),
                                ))
                          ],
                        )
                            .decorated(color: appColor(context).fieldCardBg)
                            .paddingOnly(top: Insets.i15, bottom: Insets.i25)
                            .width(MediaQuery.of(context).size.width),
                      value.isLoader == true
                          ? const ServicesShimmer(count: 3).padding(
                              horizontal: Insets
                                  .i20) /*  Center(
                              child: Image.asset(
                              eGifAssets.loader,
                              height: Sizes.s100,
                            )) */
                          : value.serviceList.isNotEmpty
                              ? Consumer<CartProvider>(
                                  builder: (context2, cart, child) {
                                  return Column(
                                    children: value.serviceList
                                        .asMap()
                                        .entries
                                        .map((e) => FeaturedServicesLayout(
                                                data: e.value,
                                                isProvider: false,
                                                inCart: isInCart(
                                                    context, e.value.id),
                                                addTap: () =>
                                                    value.getProviderById(
                                                        context,
                                                        e.value.userId,
                                                        e.key,
                                                        e.value),
                                                onTap: value.isAlert
                                                    ? () {}
                                                    : () =>
                                                        value.getServiceById(
                                                            context,
                                                            e.value.id))
                                            .paddingSymmetric(
                                                horizontal: Insets.i20))
                                        .toList(),
                                  ).marginOnly(top: Insets.i15);
                                })
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                            language(context,
                                                translations!.services),
                                            style: appCss.dmDenseBold16
                                                .textColor(
                                                    appColor(context).darkText))
                                        .paddingOnly(
                                      left: rtl(context) ? 0 : Insets.i20,
                                      right: rtl(context) ? Insets.i20 : 0,
                                    ),
                                    EmptyLayout(
                                        title: translations!.noDataFound,
                                        subtitle: translations!.noDataFoundDesc,
                                        buttonText: translations!.refresh,
                                        isButtonShow: false,
                                        /*  bTap: () {
                                          value.getServiceByCategoryId(
                                              context, value.categoryModel!.id);
                                        }, */
                                        widget: Stack(children: [
                                          Image.asset(eImageAssets.emptyCart,
                                              height: Sizes.s230),
                                        ])).marginOnly(top: Insets.i50),
                                  ],
                                )
                    ]),
                  )),
        ),
      );
    });
  }
}
