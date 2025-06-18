import '../../../config.dart';

class ChangeLanguageScreen extends StatelessWidget {
  const ChangeLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(builder: (context1, languageCtrl, child) {
      return LoadingComponent(
          child: Scaffold(
              appBar: AppBar(
                  elevation: 0,
                  centerTitle: true,
                  leadingWidth: 80,
                  leading: CommonArrow(
                      arrow: languageCtrl.getLocal() == "ar"
                          ? eSvgAssets.arrowRight
                          : eSvgAssets.arrowLeft1,
                      onTap: () => route.pop(context)).paddingAll(Insets.i8),
                  title: Text(
                      language(context,
                          language(context, translations!.changeLanguage)),
                      style: appCss.dmDenseBold18
                          .textColor(appColor(context).darkText))),
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const RadioLayout(),
                    ButtonCommon(
                        title: translations!.update,
                        margin: Insets.i20,
                        onTap: () async {
                          languageCtrl.changeLocale(languageCtrl
                              .languageList[languageCtrl.selectedIndex]);
                          final dashCtrl = Provider.of<DashboardProvider>(
                              context,
                              listen: false);
                          dashCtrl.getCurrency();
                          dashCtrl.getBanner();
                          dashCtrl.getOffer();
                          dashCtrl.getCoupons();
                          dashCtrl.getBookingStatus();
                          dashCtrl.getProvider();
                          dashCtrl.getCategory();
                          dashCtrl.getServicePackage();
                          dashCtrl.getJobRequest();
                          dashCtrl.getFeaturedPackage(1);
                          dashCtrl.getHighestRate();
                          dashCtrl.getBlog();
                          final locationCtrl = Provider.of<LocationProvider>(
                              context,
                              listen: false);
                          locationCtrl.getCountryState();
                          await locationCtrl.getUserCurrentLocation(context);
                        }).marginOnly(bottom: Insets.i20)
                  ])));
    });
  }
}
