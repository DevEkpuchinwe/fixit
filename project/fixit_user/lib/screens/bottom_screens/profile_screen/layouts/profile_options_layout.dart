import 'dart:developer';

import '../../../../config.dart';

class ProfileOptionsLayout extends StatelessWidget {
  final AnimationController controller;
  final TickerProvider? sync;

  const ProfileOptionsLayout({super.key, required this.controller, this.sync});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, ProfileProvider>(
      builder: (context, lang, value, child) {
        return Column(
          children: value.profileLists.asMap().entries.map((e) {
            bool isGuest = value.isGuest;
            var title = isGuest ? e.value.title : e.value['title'];
            var data = isGuest ? e.value.data : e.value['data'];
            //log("e.value:::${e.value}/// ${e.key}");
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (e.key != 3 /*  2 */)
                  Text(
                    language(context, title.toString())
                        .toString()
                        .toUpperCase(),
                    style: appCss.dmDenseBold14.textColor(
                        /* e.key == 3
                        ? appColor(context).red
                        : */
                        appColor(context).primary),
                  ).paddingSymmetric(vertical: Insets.i15),
                if (data != null && data is List && data.isNotEmpty)
                  Container(
                    decoration: ShapeDecoration(
                      color: e.key == 3
                          ? appColor(context).red.withOpacity(0.1)
                          : appColor(context)
                              .whiteBg /* appColor(context).whiteBg */,
                      shadows: [
                        BoxShadow(
                          color: e.key == 3
                              ? appColor(context).whiteBg
                              : appColor(context).darkText.withOpacity(0.06),
                          spreadRadius: 1,
                          blurRadius: 2,
                        )
                      ],
                      shape: SmoothRectangleBorder(
                        side: BorderSide(color: appColor(context).fieldCardBg),
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: AppRadius.r12,
                          cornerSmoothing: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      children: (data)
                          .asMap()
                          .entries
                          .map(
                            (s) => isGuest
                                ? ProfileOptionLayout2(
                                    data: s.value,
                                    index: s.key,
                                    mainIndex: e.key,
                                    list: data,
                                    onTap: () => value.onTapOption(
                                        s.value, context, controller, sync),
                                  )
                                : ProfileOptionLayout(
                                    data: s.value,
                                    index: s.key,
                                    mainIndex: e.key,
                                    list: data,
                                    onTap: () => value.onTapOption(
                                        s.value, context, controller, sync),
                                  ),
                          )
                          .toList(),
                    ).paddingAll(Insets.i15),
                  ),
                if (e.key == 1) const BecomeProviderLayout(),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
