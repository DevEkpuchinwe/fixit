import 'package:flutter/cupertino.dart';
import '../../../../config.dart';

class CategoriesFilterLayout extends StatelessWidget {
  const CategoriesFilterLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<CategoriesDetailsProvider>(context, listen: true);
    return Consumer2<LanguageProvider, CategoriesDetailsProvider>(
        builder: (context, lang, value, child) {
      return SizedBox(
          height: MediaQuery.of(context).size.height / 1.2,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${language(context, translations!.filterBy)} (${value.totalCountFilter()})",
                                style: appCss.dmDenseMedium18
                                    .textColor(appColor(context).darkText)),
                            const Icon(CupertinoIcons.multiply)
                                .inkWell(onTap: () => route.pop(context))
                          ]).paddingSymmetric(horizontal: Insets.i20),
                      Container(
                              alignment: Alignment.center,
                              height: Sizes.s50,
                              decoration: BoxDecoration(
                                  color: appColor(context).fieldCardBg,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(AppRadius.r30))),
                              child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: appArray.filterList1
                                          .asMap()
                                          .entries
                                          .map((e) => FilterTapLayout(
                                              data: e.value,
                                              index: e.key,
                                              selectedIndex: value.selectIndex,
                                              onTap: () =>
                                                  value.onFilter(e.key)))
                                          .toList())
                                  .paddingAll(Insets.i5))
                          .paddingOnly(
                              top: Insets.i25,
                              bottom: Insets.i10,
                              left: Insets.i20,
                              right: Insets.i20),
                      const FiltersBody(),
                      const VSpace(Sizes.s80)
                    ]).paddingSymmetric(vertical: Insets.i20),
              ),
              BottomSheetButtonCommon(
                      textOne: translations!.clearAll,
                      textTwo: translations!.apply,
                      applyTap: () {
                        print(
                            "object======> ${value.categoryModel!.hasSubCategories![value.selectIndex].id}");
                        route.pop(context);
                        value.getServiceByCategoryId(
                            context, value.subCategoryId
                            /* value.categoryModel!
                                .id */ /* value.categoryModel!
                                .hasSubCategories![value.selectIndex].id */
                            );
                      },
                      clearTap: () =>
                          value.clearFilter(context, value.subCategoryId))
                  .backgroundColor(appColor(context).whiteBg)
                  .alignment(Alignment.bottomCenter)
            ],
          )).bottomSheetExtension(context);
    });
  }
}
