import 'dart:developer';

import '../../../config.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<LanguageProvider, ProfileProvider, ThemeService>(
        builder: (contextTheme, lang, value, theme, child) {
      log("isSer :$isFreelancer");
      return StatefulWrapper(
          onInit: () => Future.delayed(const Duration(milliseconds: 150),
              () => value.onReady(contextTheme)),
          child: Scaffold(
              appBar: AppBar(
                  leadingWidth: 0,
                  centerTitle: false,
                  title: Text(language(context, translations!.profileSetting),
                      style: appCss.dmDenseBold18
                          .textColor(appColor(contextTheme).appTheme.darkText)),
                  actions: [
                    CommonArrow(
                            arrow: eSvgAssets.setting,
                            onTap: () => value.onTapSettingTap(context))
                        .paddingSymmetric(horizontal: Insets.i20)
                  ]),
              body: Consumer<ThemeService>(builder: (context, value, child) {
                return SingleChildScrollView(
                    child: const Column(children: [
                  ProfileSettingTopLayout(),
                  VSpace(Sizes.s15),
                  ProfileOptionsLayout()
                ]).padding(
                        horizontal: Insets.i20,
                        top: Insets.i20,
                        bottom: Insets.i110));
              })));
    });
  }
}
