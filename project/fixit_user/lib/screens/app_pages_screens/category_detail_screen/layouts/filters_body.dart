import 'dart:developer';

import '../../../../config.dart';

class FiltersBody extends StatelessWidget {
  const FiltersBody({super.key});

  @override
  Widget build(BuildContext context) {
    // final value = Provider.of<CategoriesDetailsProvider>(context, listen: true);
    // log("MAS :${value.maxPrice} // ${value.upperVal}");
    return Consumer2<LanguageProvider, CategoriesDetailsProvider>(
        builder: (context, lang, value, child) {
      log("value.providerList:::${value.providerList}");
      return StatefulWrapper(
        onInit: () {
          Future.delayed(const Duration(milliseconds: 150)).then((valuee) {
            value.getProvider();
          });
        },
        child: Stack(alignment: Alignment.bottomCenter, children: [
          value.selectIndex == 0
              ? Column(children: [
                  Row(children: [
                    Expanded(
                        child: Text(
                                "${language(context, translations!.providerList)} (${value.providerList.length})",
                                style: appCss.dmDenseMedium14
                                    .textColor(appColor(context).lightText))
                            .alignment(Alignment.centerLeft)),
                    DropDownLayout(
                            isIcon: false,
                            val: value.exValue,
                            categoryList: appArray.experienceList,
                            onChanged: (val) => value.onExperience(val))
                        .width(Sizes.s180)
                  ]).paddingSymmetric(
                      vertical: Insets.i20, horizontal: Insets.i20),
                  SearchTextFieldCommon(
                    controller: value.filterSearchCtrl,
                    focusNode: value.filterSearchFocus,
                    onChanged: (v) {
                      if (v.isEmpty) {
                        value.fetchProviderByFilter();
                      } else if (v.length > 3) {
                        value.fetchProviderByFilter();
                      }
                    },
                    onFieldSubmitted: (v) => value.fetchProviderByFilter(),
                  ).paddingSymmetric(horizontal: Insets.i20),
                  const VSpace(Sizes.s10),
                  ...value.providerList.asMap().entries.map((e) {
                    log("value.providerList:::${value.providerList}");
                    return ExperienceLayout(
                        data: e.value,
                        isContain: value.selectedProvider.contains(e.value.id),
                        onTap: () =>
                            value.onCategoryChange(e.value.id)).inkWell(
                        onTap: () =>
                            value.onCategoryChange(/* e.key */ e.value.id));
                  })

                  /*             Expanded(
                      child: ListView.builder(
                          itemCount: value.providerList.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ExperienceLayout(
                            
                                data: value.providerList[index],
                                isContain: value.selectedProvider.contains(index),
                                onTap: () =>
                                    value.onCategoryChange(index));
                          }))*/
                ])
              : value.selectIndex == 1
                  ? SecondFilter(
                      min: 0.0,
                      max: value.maxPrice,
                      lowerVal: value.lowerVal,
                      upperVal: value.upperVal,
                      selectIndex: value.ratingIndex,
                      onDragging: (handlerIndex, lowerValue, upperValue) =>
                          value.onSliderChange(
                              handlerIndex, lowerValue, upperValue),
                      isSearch: false)
                  : const ThirdFilter(),
        ]),
      );
    });
  }
}
