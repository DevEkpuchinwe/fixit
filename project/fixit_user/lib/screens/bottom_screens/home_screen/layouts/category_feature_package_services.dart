import 'package:fixit_user/screens/bottom_screens/home_screen/layouts/horizontal_service_package_list.dart';

import '../../../../config.dart';

class CategoryFeaturePackageServices extends StatelessWidget {
  const CategoryFeaturePackageServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer5<DashboardProvider, HomeScreenProvider, CartProvider,
            CommonApiProvider, CategoriesDetailsProvider>(
        builder:
            (context3, dash, value, cart, commonApi, categoryDetails, child) {
      return Column(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          /*   dash.isCategory
              ? Column(
                  children: [
                    const RowText().paddingSymmetric(horizontal: Sizes.s20),
                    const VSpace(Sizes.s17),
                    const GridShimmer(),
                  ],
                )
              : Column(
                  children: [
                    if (dash.categoryList.isNotEmpty)
                      HeadingRowCommon(
                              title: translations!.topCategories,
                              isTextSize: true,
                              onTap: () => route.pushNamed(
                                  context, routeName.categoriesListScreen))
                          .paddingSymmetric(horizontal: Insets.i20),
                    if (dash.categoryList.isNotEmpty) const VSpace(Sizes.s15),
                    GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding:
                            const EdgeInsets.symmetric(horizontal: Sizes.s20),
                        itemCount: dash.categoryList.length >= 8
                            ? dash.categoryList.getRange(0, 8).length
                            : dash.categoryList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisExtent: Sizes.s110,
                                mainAxisSpacing: Sizes.s10,
                                crossAxisSpacing: Sizes.s10),
                        itemBuilder: (context, index) {
                          // Top Categories lists
                          return TopCategoriesLayout(
                              index: index,
                              selectedIndex: dash.topSelected,
                              data: dash.categoryList[index],
                              onTap: () => route.pushNamed(
                                  context, routeName.categoriesDetailsScreen,
                                  arg: dash.categoryList[index]));
                        }),
                  ],
                ), */

          Column(
            children: [
              if (commonApi.dashboardModel!.categories!
                  .isNotEmpty /*  dash.categoryList.isNotEmpty */)
                HeadingRowCommon(
                        title: translations!.topCategories,
                        isTextSize: true,
                        onTap: () => route.pushNamed(
                            context, routeName.categoriesListScreen))
                    .paddingSymmetric(horizontal: Insets.i20),
              if (commonApi.dashboardModel!.categories!
                  .isNotEmpty /* dash.categoryList.isNotEmpty */)
                const VSpace(Sizes.s15),
              GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.s20),
                  itemCount: /* dash.categoryList.length */
                      commonApi.dashboardModel!.categories?.length == 8
                          ? commonApi.dashboardModel!.categories
                              ?.getRange(0, 8)
                              .length /* dash.categoryList.getRange(0, 8).length */
                          : commonApi.dashboardModel!.categories
                              ?.length /* dash.categoryList.length */,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisExtent: Sizes.s110,
                      mainAxisSpacing: Sizes.s10,
                      crossAxisSpacing: Sizes.s10),
                  itemBuilder: (context, index) {
                    // Top Categories lists
                    return TopCategoriesLayout(
                        index: index,
                        selectedIndex: dash.topSelected,
                        data: homeCategoryList[
                            index] /* dash.categoryList[index] */,
                        onTap: () {
                          print("object=-=-=-=-==-=-=-=-$index");
                          print(
                              "object=-=-=-=-==-=-=-=-${commonApi.dashboardModel!.categories?[index].hasSubCategories?.length /* homeCategoryList[index].hasSubCategories */}");
                          categoryDetails.hasCategoryList.clear();
                          categoryDetails.hasCategoryList.addAll(
                            (commonApi.dashboardModel!.categories?[index]
                                        .hasSubCategories ??
                                    [])
                                .map((subCategory) => CategoryModel(
                                      // Map fields from HasSubCategoryElement to CategoryModel
                                      id: subCategory
                                          .id, // Example: assuming id exists
                                      title: subCategory
                                          .title, // Adjust based on your model
                                      media: [
                                        Media(
                                            originalUrl: subCategory
                                                .media?.first.originalUrl)
                                      ],
                                      // Add other required fields here
                                    ))
                                .toList() as Iterable<CategoryModel>,
                          );
                          // print(
                          //     "object=-=-=-=-==-=-=-=-${categoryDetails.hasCategoryList.first.title /* homeCategoryList[index].hasSubCategories */}");
                          /*  categoryDetails.hasCategoryList.addAll((commonApi
                                      .dashboardModel!
                                      .categories?[index]
                                      .hasSubCategories ??
                                  [])
                              as Iterable<
                                  CategoryModel>)  */ /* = homeCategoryList[
                                  index]
                              .hasSubCategories! */ /*   .add(homeCategoryList[index].hasSubCategories!) */;
                          /* homeHasSubCategoryList.addAll(homeCategoryList[index]
                                  .hasSubCategories!) */ /* =
                              homeCategoryList[index].hasSubCategories! */

                          route.pushNamed(
                              context, routeName.categoriesDetailsScreen,
                              arg: /* dash.categoryList */
                                  homeCategoryList[index]);
                        });
                  }),
            ],
          ),
          /* dash.isServiceList
              ? Column(
                  children: [
                    const RowText().paddingSymmetric(horizontal: Sizes.s20),
                    const VSpace(Sizes.s17),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          ...List.generate(3, (index) {
                            return const PackageShimmer();
                          })
                        ]).marginSymmetric(horizontal: Sizes.s10)),
                  ],
                )
              : */
          Column(
            children: [
              if (homeServicePackagesList
                  .isNotEmpty /* dash.servicePackagesList.isNotEmpty */)
                HeadingRowCommon(
                        title: translations!.servicePackage,
                        isTextSize: true,
                        onTap: () => route.pushNamed(
                            context, routeName.servicePackagesScreen))
                    .paddingSymmetric(horizontal: Insets.i20),
              if (homeServicePackagesList
                  .isNotEmpty /* dash.servicePackagesList.isNotEmpty */)
                const VSpace(Sizes.s15),
              HorizontalServicePackageList(
                  /* firstThreeServiceList:
                      homeServicePackagesList /* dash.firstThreeServiceList */, */
                  rotationAnimation: value.rotationAnimation,
                  servicePackagesList:
                      homeServicePackagesList /*  dash.servicePackagesList */),
            ],
          ),
          /*  if (dash.featuredServiceList.isNotEmpty) const VSpace(Sizes.s25),
          dash.isFeaturedServiceList
              ? Column(
                  children: [
                    const VSpace(Sizes.s30),
                    const RowText().paddingSymmetric(horizontal: Sizes.s20),
                    const ServicesShimmer(),
                  ],
                )
              : Column(
                  children: [
                    if (dash.featuredServiceList.isNotEmpty)
                      HeadingRowCommon(
                              title: translations!.featuredService,
                              isTextSize: true,
                              onTap: () => route.pushNamed(
                                  context, routeName.featuredServiceScreen))
                          .paddingSymmetric(horizontal: Insets.i20),
                    const VSpace(Sizes.s15),
                    if (dash.firstTwoFeaturedServiceList.isNotEmpty)
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: dash.firstTwoFeaturedServiceList.length,
                          itemBuilder: (context, index) {
                            return FeaturedServicesLayout(
                                data: dash.firstTwoFeaturedServiceList[index],
                                addTap: () => dash.onFeatured(
                                    context,
                                    dash.firstTwoFeaturedServiceList[index],
                                    index,
                                    inCart: isInCart(
                                        context,
                                        dash.firstTwoFeaturedServiceList[index]
                                            .id)),
                                inCart: isInCart(context,
                                    dash.firstTwoFeaturedServiceList[index].id),
                                onTap: () => route.pushNamed(context,
                                        routeName.servicesDetailsScreen, arg: {
                                      'services': dash
                                          .firstTwoFeaturedServiceList[index]
                                    }).then((e) {
                                      dash.getFeaturedPackage(1);
                                    }));
                          }).paddingSymmetric(horizontal: Insets.i20),
                    if (dash.firstTwoFeaturedServiceList.isEmpty)
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: dash.featuredServiceList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return FeaturedServicesLayout(
                                data: dash.featuredServiceList[index],
                                addTap: () => dash.onFeatured(context,
                                    dash.featuredServiceList[index], index,
                                    inCart: isInCart(context,
                                        dash.featuredServiceList[index].id)),
                                inCart: isInCart(context,
                                    dash.featuredServiceList[index].id),
                                onTap: () => route.pushNamed(context,
                                        routeName.servicesDetailsScreen, arg: {
                                      'services':
                                          dash.featuredServiceList[index]
                                    }).then((e) {
                                      dash.getFeaturedPackage(1);
                                    }));
                          })
                  ],
                ), */
          const VSpace(Sizes.s20),
          Column(
            children: [
              if (homeFeaturedService.isNotEmpty)
                HeadingRowCommon(
                        title: translations!.featuredService,
                        isTextSize: true,
                        onTap: () => route.pushNamed(
                            context, routeName.featuredServiceScreen))
                    .paddingSymmetric(horizontal: Insets.i20),
              const VSpace(Sizes.s15),
              if (homeFeaturedService.isNotEmpty)
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: homeFeaturedService.length,
                    itemBuilder: (context, index) {
                      return FeaturedServicesLayout(
                          data: homeFeaturedService[index],
                          addTap: () => dash.onFeatured(
                              context, homeFeaturedService[index], index,
                              inCart: isInCart(
                                  context, homeFeaturedService[index].id)),
                          inCart:
                              isInCart(context, homeFeaturedService[index].id),
                          onTap: () => route.pushNamed(
                                  context, routeName.servicesDetailsScreen,
                                  arg: {
                                    'services': homeFeaturedService[index]
                                  }).then((e) {
                                dash.getFeaturedPackage(1);
                              }));
                    }).paddingSymmetric(horizontal: Insets.i20),
              /* if (dash.firstTwoFeaturedServiceList.isEmpty)
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: dash.featuredServiceList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return FeaturedServicesLayout(
                          data: dash.featuredServiceList[index],
                          addTap: () => dash.onFeatured(
                              context, dash.featuredServiceList[index], index,
                              inCart: isInCart(
                                  context, dash.featuredServiceList[index].id)),
                          inCart: isInCart(
                              context, dash.featuredServiceList[index].id),
                          onTap: () => route.pushNamed(
                                  context, routeName.servicesDetailsScreen,
                                  arg: {
                                    'services': dash.featuredServiceList[index]
                                  }).then((e) {
                                dash.getFeaturedPackage(1);
                              }));
                    }) */
            ],
          ),
          // const VSpace(Sizes.s30),

          /*  ...dash.firstTwoFeaturedServiceList.asMap().entries.map((e) =>
                FeaturedServicesLayout(
                    data: e.value,
                    addTap: () => dash.onFeatured(context, e.value, e.key,
                        inCart: isInCart(context, e.value.id)),
                    inCart: isInCart(context, e.value.id),
                    onTap: () => route.pushNamed(
                            context, routeName.servicesDetailsScreen,
                            arg: {'services': e.value}).then((e) {
                          dash.getFeaturedPackage(1);
                        })).paddingSymmetric(horizontal: Insets.i20)), */

          /*  ...dash.featuredServiceList.asMap().entries.map((e) =>
                FeaturedServicesLayout(
                        data: e.value,
                        inCart: isInCart(context, e.value.id),
                        addTap: () => dash.onFeatured(context, e.value, e.key,
                            inCart: isInCart(context, e.value.id)),
                        onTap: () => route.pushNamed(
                            context, routeName.servicesDetailsScreen,
                            arg: {'services': e.value}))
                    .paddingSymmetric(horizontal: Insets.i20)) */
        ]).padding(bottom: Insets.i10),
        // Text(dash.highestRateList.length.toString()),
        /*  dash.isHidhestRate
            ? Container(
                color: appColor(context).skeletonColor,
                padding: const EdgeInsets.symmetric(vertical: Sizes.s28),
                child: Column(children: [
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonWhiteShimmer(
                            height: Sizes.s18, width: Sizes.s155),
                        HSpace(Sizes.s3),
                        CommonWhiteShimmer(height: Sizes.s18, width: Sizes.s45)
                      ]).padding(horizontal: Sizes.s20, bottom: Sizes.s17),
                  const ExpertServiceShimmer()
                ]))
            : */
        Column(
          children: [
            /*   if (dash.firstTwoHighRateList.isNotEmpty ||
                      dash.highestRateList.isNotEmpty) */
            Column(children: [
              HeadingRowCommon(
                  title: translations!.expertService,
                  isTextSize: true,
                  onTap: () =>
                      route.pushNamed(context, routeName.expertServiceScreen)),
              const VSpace(Sizes.s15),
              /*   if (dash.firstTwoHighRateList.isNotEmpty)
                        ...dash.firstTwoHighRateList
                            .asMap()
                            .entries
                            .map((e) => ExpertServiceLayout(
                                  data: e.value,
                                  onTap: () => route.pushNamed(
                                      context, routeName.providerDetailsScreen,
                                      arg: {'provider': e.value}),
                                )),
                      if (dash.firstTwoHighRateList.isEmpty) */

              ListView.builder(
                shrinkWrap: true,
                itemCount:
                    homeProvider /* commonApi.dashboardModel!.highestRatedProviders */
                        .length /* dash.highestRateList.length */,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ExpertServiceLayout /* HomeExpertServiceLayout */ (
                      data: homeProvider[
                          index] /* commonApi
                          .dashboardModel!.highestRatedProviders?[index] */
                      ,
                      onTap: () => route.pushNamed(
                              context, routeName.providerDetailsScreen,
                              arg: {
                                'provider': /* commonApi
                                .dashboardModel!.highestRatedProviders? */
                                    homeProvider[index]
                              }));
                },
              )
              /*  ...dash.highestRateList.asMap().entries.map((e) =>
                  ExpertServiceLayout(
                      data: e.value,
                      onTap: () => route.pushNamed(
                          context, routeName.providerDetailsScreen,
                          arg: {'provider': e.value}))) */
            ])
                .paddingSymmetric(horizontal: Insets.i20, vertical: Insets.i25)
                .backgroundColor(appColor(context).fieldCardBg)
          ],
        ),
      ]);
    });
  }
}
