import '../../../../../config.dart';

class BidListCard extends StatelessWidget {
  final ProviderModel? provider;
  final GestureTapCallback? rejectTap, acceptTap;
  final bool isAction;
  final dynamic amount;

  const BidListCard(
      {super.key,
      this.provider,
      this.rejectTap,
      this.acceptTap,
      this.isAction = true,
      this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              CommonImageLayout(
                  radius: 8,
                  image: provider!.media![0].originalUrl,
                  assetImage: eImageAssets.noImageFound1,
                  height: Sizes.s52,
                  width: Sizes.s52),
              const HSpace(Sizes.s10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(provider!.name!,
                    style: appCss.dmDenseMedium14
                        .textColor(appColor(context).darkText)),
                const VSpace(Sizes.s6),
                Text(
                    "${getSymbol(context)}${currency(context).currencyVal * amount!}",
                    style: appCss.dmDenseMedium14
                        .textColor(appColor(context).darkText))
              ])
            ]),
            if (provider!.reviewRatings != null)
              Row(children: [
                Text(provider!.reviewRatings!.toString()),
                SvgPicture.asset(eSvgAssets.star)
              ])
          ]),
      if (isAction) const VSpace(Sizes.s20),
      if (isAction)
        Row(children: [
          Expanded(
              child: ButtonCommon(
                  title: translations!.reject,
                  color: appColor(context).whiteBg,
                  borderColor: appColor(context).primary,
                  onTap: rejectTap,
                  style: appCss.dmDenseMedium14
                      .textColor(appColor(context).primary))),
          const HSpace(Sizes.s15),
          Expanded(
              child: ButtonCommon(
                  title: language(context, translations!.accept),
                  onTap: acceptTap,
                  style: appCss.dmDenseMedium14
                      .textColor(appColor(context).whiteBg)))
        ])
    ])
        .paddingAll(12)
        .boxBorderExtension(context,
            isShadow: true, bColor: appColor(context).fieldCardBg)
        .marginSymmetric(horizontal: Sizes.s20);
  }
}
