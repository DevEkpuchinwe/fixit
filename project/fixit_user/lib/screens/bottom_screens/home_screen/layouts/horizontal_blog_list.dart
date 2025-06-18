import 'package:fixit_user/models/dashboard_user_model.dart';
import 'package:intl/intl.dart';

import '../../../../config.dart';

class HorizontalBlogList extends StatelessWidget {
  final List? firstTwoBlogList, blogList;

  const HorizontalBlogList({super.key, this.firstTwoBlogList, this.blogList});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: /*  firstTwoBlogList!.isNotEmpty
            ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: firstTwoBlogList!
                        .asMap()
                        .entries
                        .map((e) => LatestBlogLayout(data: e.value))
                        .toList())
                .paddingOnly(left: Insets.i20)
            : */
            Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: blogList!
                        .asMap()
                        .entries
                        .map((e) => HomeLatestBlogLayout(data: e.value))
                        .toList())
                .paddingOnly(left: Insets.i20));
  }
}

// import 'package:intl/intl.dart';
// import '../../../../config.dart';

class HomeLatestBlogLayout extends StatelessWidget {
  final Blog? data;
  final GestureTapCallback? onTap;

  const HomeLatestBlogLayout({
    super.key,
    this.onTap,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
            width: Sizes.s257,
            child: Column(children: [
              CommonImageLayout(
                  image: data!.media != null && data!.media!.isNotEmpty
                      ? data!.media!.first.originalUrl!
                      : "",
                  assetImage: eImageAssets.noImageFound2,
                  height: Sizes.s155,
                  isAllBorderRadius: false,
                  tRRadius: 8,
                  tlRadius: 8,
                  bRRadius: 0,
                  blRadius: 0),
              // Image.network(data!.media![0].originalUrl!),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: Sizes.s190,
                        child: Text(language(context, data!.title!),
                            overflow: TextOverflow.ellipsis,
                            style: appCss.dmDenseMedium16
                                .textColor(appColor(context).darkText))),
                  ],
                ),
                Row(children: [
                  Expanded(
                    child: Text(language(context, data!.description!),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: appCss.dmDenseRegular13
                            .textColor(appColor(context).lightText)),
                  ),
                ]),
                const VSpace(Sizes.s15),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (data!.createdAt != null)
                        Text(
                            DateFormat('yyyy-MM-dd').format(
                                DateTime.parse(data!.createdAt.toString())),
                            /*  DateTime.parse(data!.createdAt.toString())
                              .toString() */
                            /* DateFormat("dd MMM, yyyy")
                                .format(DateTime.parse(data!.createdAt!) */
                            /*   ,
                            data!.createdAt.toString() */
                            /* DateFormat("dd MMM, yyyy")
                                .format(DateTime.parse(data!.createdAt!) */
                            /*  , */
                            style: appCss.dmDenseRegular13
                                .textColor(appColor(context).lightText)),
                      if (data!.createdBy != null)
                        Row(
                          children: [
                            SvgPicture.asset(eSvgAssets.user,
                                height: Sizes.s16),
                            const HSpace(Sizes.s5),
                            Text(
                                capitalizeFirstLetter(language(
                                    context,
                                    data!.createdBy!.name
                                        .toString()
                                        .replaceFirst(
                                            "HighestRatedProviderName.", "")
                                        .toLowerCase())),
                                style: appCss.dmDenseRegular13
                                    .textColor(appColor(context).lightText)),
                          ],
                        )
                    ])
              ]).paddingAll(Insets.i12)
            ]))
        .decorated(
            color: appColor(context).whiteBg,
            boxShadow: [
              BoxShadow(
                  blurRadius: 3,
                  spreadRadius: 2,
                  color: appColor(context).darkText.withOpacity(0.06))
            ],
            borderRadius: BorderRadius.circular(AppRadius.r8),
            border: Border.all(color: appColor(context).stroke))
        .inkWell(
            onTap: () => route.pushNamed(context, routeName.latestBlogDetails,
                arg: data))
        .padding(right: Insets.i15, vertical: Insets.i10);
  }
}
