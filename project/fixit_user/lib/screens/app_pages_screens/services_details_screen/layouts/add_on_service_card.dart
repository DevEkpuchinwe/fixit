import '../../../../config.dart';

class AddOnServiceCard extends StatelessWidget {
  final AdditionalServices? additionalServices;
  final bool isContain,isDelete,isIconShow;
  final int? index,additionalServicesLength;
  final GestureTapCallback? deleteTap,onTap;
  const AddOnServiceCard({super.key, this.additionalServices,this.isDelete =false,this.isContain =false, this.index, this.additionalServicesLength, this.deleteTap, this.onTap,  this.isIconShow=true});

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            additionalServices!.media != null && additionalServices!.media!.isNotEmpty
                ? CommonImageLayout(
              radius: 8,
              width: Sizes.s52,
              height: Sizes.s52,
              image: additionalServices!.media![0].originalUrl,
              assetImage: eImageAssets.noImageFound2,
            )
                : Container(
                height: Sizes.s52,
                width: Sizes.s52,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                        image: AssetImage(
                            eImageAssets.noImageFound1),
                        fit: BoxFit.contain))),
            const HSpace(Sizes.s10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(additionalServices!.title!.capitalizeFirst(),
                    style: appCss.dmDenseMedium14
                        .textColor(appColor(context).darkText)),
                const VSpace(Sizes.s8),
                Text(
                    "${getSymbol(context)}${currency(context).currencyVal * additionalServices!.price!}",
                    style: appCss.dmDenseMedium14
                        .textColor(appColor(context).darkText)),
              ],
            )
          ],
        ),
        if(isIconShow)
        isDelete ? CommonArrow(
            arrow: eSvgAssets.delete,
            svgColor: appColor(context).red,
            onTap:deleteTap,
            color: appColor(context).red.withOpacity(0.1)):
        isContain
            ? SvgPicture.asset(
          eSvgAssets.tickCircle,
          height: Sizes.s20,
        ).inkWell(
            onTap: onTap)
            : SvgPicture.asset(eSvgAssets.add,
            colorFilter: ColorFilter.mode(
                appColor(context).primary, BlendMode.srcIn))
            .paddingAll(1)
            .decorated(
            shape: BoxShape.circle,
            border:
            Border.all(color: appColor(context).primary))
            .inkWell(
            onTap: onTap)
      ],
    )
        .paddingSymmetric(horizontal: Insets.i15, vertical: Sizes.s12)
        .boxBorderExtension(context,
        bColor:isContain
            ? appColor(context).primary.withOpacity(.10)
            : appColor(context).stroke ,
        color: isContain
            ? appColor(context).primary.withOpacity(.10)
            : appColor(context).whiteBg)
        .paddingOnly(
        bottom:index !=
            additionalServicesLength
            ? Insets.i15
            : 0);
  }
}
