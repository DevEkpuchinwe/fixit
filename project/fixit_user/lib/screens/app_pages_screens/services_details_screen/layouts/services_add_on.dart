import 'package:fixit_user/screens/app_pages_screens/services_details_screen/layouts/add_on_service_card.dart';

import '../../../../config.dart';

class ServicesAddOn extends StatelessWidget {
  final bool isDelete;
  final GestureTapCallback? onTap;
  const ServicesAddOn({super.key, this.isDelete = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesDetailsProvider>(
        builder: (context, serviceCtrl, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (serviceCtrl.service!.additionalServices!.isNotEmpty)
            Text(language(context, translations!.addOns),
                    overflow: TextOverflow.clip,
                    style: appCss.dmDenseBold16
                        .textColor(appColor(context).darkText))
                .padding(vertical: Sizes.s10),
          ...serviceCtrl.service!.additionalServices!
              .asMap()
              .entries
              .map((e) => AddOnServiceCard(
                    isContain: serviceCtrl.isContain(e.value.id),
                    onTap: () => serviceCtrl.addAdditionalService(e.value),
                    index: e.key,
                    additionalServices: e.value,
                    additionalServicesLength:
                        serviceCtrl.service!.additionalServices!.length - 1,
                  ))
        ],
      ).marginOnly(top: Sizes.s10).paddingSymmetric(horizontal: Sizes.s20);
    });
  }
}
