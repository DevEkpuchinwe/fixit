import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../../config.dart';

class CountryDropDown extends StatelessWidget {
  const CountryDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewLocationProvider>(builder: (context2, value, child) {
      return Consumer<LocationProvider>(
          builder: (context2, locationCtrl, child) {
        return Stack(alignment: Alignment.centerLeft, children: [
          DropdownButton2<CountryStateModel>(
              underline: Container(),
              dropdownStyleData: DropdownStyleData(
                  maxHeight: Sizes.s400,
                  decoration: BoxDecoration(color: appColor(context).whiteBg)),
              isExpanded: true,
              isDense: true,
              iconStyleData: IconStyleData(icon: Container()),
              //searchable IconStyle
              hint: Text(language(context, translations!.selectCountry),
                  style: appCss.dmDenseMedium14
                      .textColor(appColor(context).lightText)),

              //Searchable DropDown Title Text
              items: locationCtrl.countryStateList
                  .map((e) => DropdownMenuItem(
                      value: e,
                      //Searchable DropDown SubTitle Text
                      child: Text(
                        e.name!,
                        style: appCss.dmDenseMedium14
                            .textColor(appColor(context).darkText),
                      )))
                  .toList(),
              value: value.country,
              onChanged: (val) {
                CountryStateModel? country = val;
                value.onChangeCountry(context, country!.id, country);
              },
              buttonStyleData: ButtonStyleData(
                  elevation: 0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                      color: appColor(context).whiteBg,
                      border: Border.all(color: appColor(context).trans)),
                  padding: const EdgeInsets.symmetric(horizontal: Insets.i30),
                  height: Sizes.s50),
              //search ButtonStyle Data
              menuItemStyleData: const MenuItemStyleData(height: Sizes.s40),
              dropdownSearchData: DropdownSearchData(
                  searchController: value.countryCtrl,
                  searchInnerWidgetHeight: Sizes.s50,
                  searchInnerWidget: Container(
                      height: Sizes.s60,
                      padding: const EdgeInsets.only(
                          top: Insets.i8,
                          bottom: Insets.i4,
                          right: Insets.i8,
                          left: Insets.i8),
                      child: TextFormField(
                          expands: true,
                          maxLines: null,
                          controller: value.countryCtrl,
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              hintText:
                                  language(context, translations!.searchHere),
                              hintStyle: const TextStyle(fontSize: 12),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))))),
                  //searchable layout container
                  searchMatchFn: (item, searchValue) {
                    return item.value!.name
                        .toString()
                        .toLowerCase()
                        .contains(searchValue);
                  }),
              //This to clear the search value when you close the menu
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  value.countryCtrl.clear();
                }
              }),
          SvgPicture.asset(eSvgAssets.country,
                  fit: BoxFit.scaleDown,
                  colorFilter: ColorFilter.mode(
                      value.country == null
                          ? appColor(context).lightText
                          : appColor(context).darkText,
                      BlendMode.srcIn))
              .paddingSymmetric(horizontal: Insets.i15)
        ]);
      });
    });
  }
}
