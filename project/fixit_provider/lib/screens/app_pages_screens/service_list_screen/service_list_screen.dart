import 'dart:developer';

import 'package:fixit_provider/screens/app_pages_screens/service_list_screen/service_shimmer/service_shimmer.dart';

import '../../../config.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, ServiceListProvider>(
        builder: (context1, lang, value, child) {
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          value.onBack(context, false);
          if (didPop) return;
        },
        child: StatefulWrapper(
            onInit: () => Future.delayed(const Duration(milliseconds: 150),
                () => value.onReady(context, this)),
            child:
                Scaffold(
                    appBar: AppBar(
                        leadingWidth: 80,
                        title: Text(
                            language(context, translations!.serviceList),
                            style: appCss.dmDenseBold18.textColor(
                                appColor(context).appTheme.darkText)),
                        centerTitle: true,
                        leading: CommonArrow(
                                arrow: rtl(context)
                                    ? eSvgAssets.arrowRight
                                    : eSvgAssets.arrowLeft,
                                onTap: () => value.onBack(context, true))
                            .paddingAll(Insets.i8),
                        actions: [
                          CommonArrow(
                                  arrow: eSvgAssets.search,
                                  onTap: () => route.pushNamed(
                                      context, routeName.search))
                              .paddingOnly(right: Insets.i10),
                          CommonArrow(
                              arrow: eSvgAssets.add,
                              onTap: () => route.pushNamed(context,
                                  routeName.addNewService)).paddingOnly(
                              right: Insets.i20,
                              left: lang.getLocal() == 'ar' ? Insets.i20 : 0)
                        ]),
                    body: categoryList.isEmpty
                        ? const CommonEmpty()
                        : SingleChildScrollView(
                            child: Column(children: [
                            Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                  Text(
                                          language(context,
                                              translations!.categories),
                                          style: appCss.dmDenseMedium12
                                              .textColor(appColor(context)
                                                  .appTheme
                                                  .lightText))
                                      .paddingSymmetric(horizontal: Insets.i20),
                                  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: IntrinsicHeight(
                                        child: Row(
                                                children: categoryList
                                                    .asMap()
                                                    .entries
                                                    .map((e) =>
                                                        TopCategoriesLayout(
                                                            index: e.key,
                                                            data: e.value,
                                                            selectedIndex: value
                                                                .selectedIndex,
                                                            rPadding:
                                                                Insets.i20,
                                                            onTap: () {
                                                              log(" e.key:::${e.key}");
                                                              value
                                                                  .onCategories(
                                                                      context,
                                                                      e.key,
                                                                      this);
                                                            }))
                                                    .toList())
                                            .paddingOnly(
                                                left: Insets.i20,
                                                top: Insets.i15),
                                      ))
                                ])
                                .paddingSymmetric(vertical: Insets.i15)
                                .decorated(
                                    color:
                                        appColor(context).appTheme.fieldCardBg)
                                .paddingOnly(
                                    top: Insets.i10, bottom: Insets.i25)
                                .width(MediaQuery.of(context).size.width),
                            /*  value.widget1Opacity == 0.0
                                ? /* const */ /* Container(
                                    height: 20,
                                    width: 20,
                                    color: Colors.amber,
                                  ) */
                                ServiceShimmer()
                                : */
                            ServiceListBottomLayout(
                                subCategory: categoryList[value.selectedIndex]
                                    .hasSubCategories)
                          ])))),
      );
    });
  }
}
