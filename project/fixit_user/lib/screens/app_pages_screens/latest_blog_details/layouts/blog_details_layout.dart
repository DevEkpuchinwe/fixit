import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import '../../../../config.dart';

class BlogDetailsLayout extends StatelessWidget {
  const BlogDetailsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<LatestBLogDetailsProvider>(context, listen: true);
    return Column(children: [
      CommonImageLayout(
        image: value.data!.media.isEmpty
            ? "https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png?20210521171500"
            : value.data!.media!.first.originalUrl!,
        assetImage: eImageAssets.noImageFound2,
        height: Sizes.s180,
      ),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
              width: Sizes.s190,
              child: Text(language(context, value.data!.title!),
                  overflow: TextOverflow.clip,
                  style: appCss.dmDenseMedium16
                      .textColor(appColor(context).darkText))),
          if (value.data!.tags != null && value.data!.tags!.isNotEmpty)
            SizedBox(
                width: Sizes.s70,
                child: Text(value.data!.tags![0].name!,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: appCss.dmDenseMedium11
                            .textColor(appColor(context).primary))
                    .paddingSymmetric(
                        horizontal: Insets.i7, vertical: Insets.i5)
                    .decorated(
                        borderRadius: BorderRadius.circular(AppRadius.r6),
                        color: appColor(context).primary.withOpacity(0.1)))
        ]),
        Row(children: [
          Expanded(
              child: Text(
                  language(context, value.data!.categories![0].title ?? ''),
                  overflow: TextOverflow.ellipsis,
                  style: appCss.dmDenseRegular13
                      .textColor(appColor(context).lightText)))
        ]),
        const VSpace(Sizes.s15),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
              /*     value.data!.createdAt
                  .tostring() */
              DateFormat("dd MMM, yyyy").format(value.data!.createdAt ?? ""),
              style: appCss.dmDenseRegular13
                  .textColor(appColor(context).lightText)),
          Row(
            children: [
              SvgPicture.asset(eSvgAssets.user, height: Sizes.s16),
              const HSpace(Sizes.s5),
              Text(
                  capitalizeFirstLetter(language(
                      context,
                      value.data!.createdBy!.name
                              .toString()
                              .replaceFirst("HighestRatedProviderName.", "")
                              .toLowerCase() ??
                          "")),
                  style: appCss.dmDenseRegular13
                      .textColor(appColor(context).lightText)),
            ],
          )
        ]),
        const DottedLines().paddingSymmetric(vertical: Insets.i15),
        Text(language(context, translations!.description),
            style:
                appCss.dmDenseMedium12.textColor(appColor(context).lightText)),
        const VSpace(Sizes.s10),
        Html(data: value.data!.content!, style: {
          "body": Style(
              fontFamily: GoogleFonts.dmSans().fontFamily,
              fontSize: FontSize(12),
              fontWeight: FontWeight.w400)
        })
      ]).paddingAll(Insets.i12)
    ]);
  }
}
