import '../../../../config.dart';

class ServiceDescription extends StatelessWidget {
  final Services? services;

  const ServiceDescription({super.key, this.services});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(builder: (context, lang, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: DescriptionLayout(
                  icon: eSvgAssets.clock,
                  title: translations!.time,
                  subtitle: "${services?.duration} ${services!.durationUnit}")),
          Container(
            color: appColor(context).stroke,
            width: 2,
            height: Sizes.s78,
          ),
          // if (services!.categories?.isNotEmpty ?? false)
          Expanded(
            child: DescriptionLayout(
                    icon: eSvgAssets.categories,
                    title: translations?.category ?? "",
                    subtitle: services?.categories?.first.title ?? "")
                .paddingOnly(
                    left: lang.locale?.languageCode == "ar" ? 0 : Insets.i20,
                    right: lang.locale?.languageCode == "ar" ? 0 : Insets.i20),
          )
        ]).paddingSymmetric(horizontal: Insets.i25),
        const DottedLines(),
        const VSpace(Sizes.s17),
        DescriptionLayout(
                icon: eSvgAssets.accountTag,
                title: translations!.requiredServicemen,
                subtitle:
                    "${services?.requiredServicemen ?? '1'} ${capitalizeFirstLetter(language(context, translations!.serviceman))}")
            .paddingSymmetric(horizontal: Insets.i25),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Text("${language(context, translations!.serviceType)} : ",
                  style: appCss.dmDenseMedium12
                      .textColor(appColor(context).lightText)),
              const HSpace(Sizes.s6),
              Text(
                services?.type == "fixed"
                    ? language(context, translations!.userSite)
                    : services?.type?.capitalizeFirst() ?? "",
                style: TextStyle(
                    color: appColor(context).darkText,
                    fontFamily: GoogleFonts.dmSans().fontFamily,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const VSpace(Sizes.s20),
          Text(language(context, translations!.description),
              style: appCss.dmDenseMedium12
                  .textColor(appColor(context).lightText)),
          const VSpace(Sizes.s6),
          if (services!.description != null && services!.user != null)
            ReadMoreLayout(text: services!.description!),
          const VSpace(Sizes.s20),
          ProviderDetailsLayout(
              image: (services?.user?.media != null &&
                      services!.user!.media!.isNotEmpty)
                  ? services!.user!.media![0].originalUrl
                  : "",
              pName: services!.user?.name!,
              rating: services!.user?.reviewRatings != null
                  ? services!.user?.reviewRatings.toString()
                  : "0.0",
              experience:
                  "${services!.user?.experienceDuration ?? ""} ${capitalizeFirstLetter(services!.user?.experienceInterval ?? 'Hours')} ${language(context, translations!.of)} ${language(context, translations!.experience)}",
              onTap: () => route.pushNamed(
                  context, routeName.providerDetailsScreen,
                  arg: {'provider': services!.user}),
              service: services!.user?.served ?? "0"),
          if (services?.reviews?.isNotEmpty ?? false)
            HeadingRowCommon(
                    title: translations!.review,
                    onTap: () => route.pushNamed(
                        context, routeName.servicesReviewScreen,
                        arg: services!))
                .paddingOnly(top: Insets.i20, bottom: Insets.i12),
          if (services?.reviews?.isNotEmpty ?? false)
            Column(
                children: services!.reviews!
                    .asMap()
                    .entries
                    .map((e) => ServiceReviewLayout(
                        data: e.value, index: e.key, list: appArray.reviewList))
                    .toList())
        ]).paddingSymmetric(horizontal: Insets.i20, vertical: Insets.i20)
      ]).boxBorderExtension(context, isShadow: true);
    });
  }
}
