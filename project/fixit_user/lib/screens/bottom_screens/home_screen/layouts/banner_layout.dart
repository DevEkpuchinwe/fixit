import 'dart:developer';
import 'package:fixit_user/models/dashboard_user_model.dart';

import '../../../../config.dart';

class BannerLayout extends StatelessWidget {
  final List<AdBanner>? bannerList;
  final Function(int index, CarouselPageChangedReason reason)? onPageChanged;
  final Function(String, String)? onTap;

  const BannerLayout(
      {super.key, this.bannerList, this.onPageChanged, this.onTap});

  @override
  Widget build(BuildContext context) {
    return bannerList!.any((banner) {
      log("banner.media !=::${banner.media?.length}");
      return banner.media!.isNotEmpty;
    })
        ? CarouselSlider(
            options: CarouselOptions(
                height: Sizes.s240,
                viewportFraction: 1,
                enlargeCenterPage: false,
                reverse: false,
                onPageChanged: onPageChanged),
            items: bannerList!
                .where((i) => i.media != null && i.media!.isNotEmpty)
                .map((i) {
              log("i.media![0].originalUrl::${i.media}");
              return Builder(builder: (BuildContext context) {
                final mediaItem = i.media!.first;

                return CachedNetworkImage(
                    imageUrl: mediaItem.originalUrl!,
                    imageBuilder: (context, imageProvider) => Container(
                        // width: double.parse(mediaItem.size!),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.fill))),
                    placeholder: (context, url) => Container(
                        // width: double.parse(mediaItem.size!),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage(eImageAssets.noImageFound2)))),
                    errorWidget: (context, url, error) => Image.asset(
                        eImageAssets.noImageFound2,
                        width: MediaQuery.of(context).size.width)).inkWell(
                  onTap: () /* {} */ => onTap!(i.type!, i.relatedId.toString()),
                );
              });
            }).toList(),
          ).paddingOnly(top: Insets.i20)
        : SizedBox.shrink(); // Display nothing if bannerList is null or empty
  }
}
