import 'package:intl/intl.dart';
import '../../../../config.dart';

class BookingLayout extends StatefulWidget {
  final BookingModel? data;
  final GestureTapCallback? onTap, editLocationTap, editDateTimeTap;
  final int? index;

  const BookingLayout(
      {super.key,
      this.data,
      this.onTap,
      this.index,
      this.editLocationTap,
      this.editDateTimeTap});

  @override
  State<BookingLayout> createState() => _BookingLayoutState();
}

class _BookingLayoutState extends State<BookingLayout> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(builder: (context1, value, child) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    if (widget.data!.servicePackageId != null) VSpace(Sizes.s8),
                    if (widget.data!.servicePackageId != null)
                      BookingStatusLayout(title: appFonts.package),
                    const VSpace(Sizes.s8),
                    Text(language(context, widget.data!.service!.title!),
                        style: appCss.dmDenseMedium16
                            .textColor(appColor(context).darkText)),
                    Row(children: [
                      Text(
                          language(context,
                              "${getSymbol(context)}${(currency(context).currencyVal * widget.data!.subtotal!).ceilToDouble().toStringAsFixed(2)}"),
                          style: appCss.dmDenseBold18
                              .textColor(appColor(context).darkText)),
                      const HSpace(Sizes.s8),
                      if (widget.data!.service!.discount != null)
                        Text(
                            language(context,
                                "(${widget.data!.service!.discount!}% ${language(context, translations!.off)})"),
                            style: appCss.dmDenseMedium14
                                .textColor(appColor(context).red))
                    ])
                  ])),
              widget.data!.service!.media != null &&
                      widget.data!.service!.media!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: widget.data!.service!.media![0].originalUrl!,
                      imageBuilder: (context, imageProvider) => Container(
                          height: Sizes.s84,
                          width: Sizes.s84,
                          decoration: ShapeDecoration(
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                              shape: const SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius.all(
                                      SmoothRadius(
                                          cornerRadius: AppRadius.r10,
                                          cornerSmoothing: 1))))),
                      placeholder: (context, url) => Container(
                          height: Sizes.s84,
                          width: Sizes.s84,
                          decoration: ShapeDecoration(
                              image: DecorationImage(
                                  image: AssetImage(eImageAssets.noImageFound1),
                                  fit: BoxFit.cover),
                              shape: const SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius.all(
                                      SmoothRadius(cornerRadius: AppRadius.r10, cornerSmoothing: 1))))),
                      errorWidget: (context, url, error) => Container(height: Sizes.s84, width: Sizes.s84, decoration: ShapeDecoration(image: DecorationImage(image: AssetImage(eImageAssets.noImageFound1), fit: BoxFit.cover), shape: const SmoothRectangleBorder(borderRadius: SmoothBorderRadius.all(SmoothRadius(cornerRadius: AppRadius.r10, cornerSmoothing: 1))))))
                  : Container(height: Sizes.s84, width: Sizes.s84, decoration: ShapeDecoration(image: DecorationImage(image: AssetImage(eImageAssets.noImageFound1), fit: BoxFit.cover), shape: const SmoothRectangleBorder(borderRadius: SmoothBorderRadius.all(SmoothRadius(cornerRadius: AppRadius.r10, cornerSmoothing: 1)))))
            ]),
            Image.asset(eImageAssets.bulletDotted)
                .paddingSymmetric(vertical: Insets.i12),
            StatusRow(
              title: translations!.bookingStatus,
              statusText: widget.data!.bookingStatus!.name,
              statusId: widget.data!.bookingStatusId,
            ),
            if (widget.data!.parentBookingNumber != null)
              StatusRow(
                title: translations!.subBookingId,
                title2: widget.data!.parentBookingNumber != null
                    ? "#${widget.data!.parentBookingNumber}"
                    : "",
              ),
            if (widget.data!.bookingStatus!.slug != translations!.cancelled)
              StatusRow(
                  statusText: widget.data!.bookingStatus!.name,
                  statusId: widget.data!.bookingStatusId,
                  title: translations!.selectServicemen,
                  title2:
                      "${((widget.data!.requiredServicemen ?? 1) + (widget.data!.totalExtraServicemen != null ? (widget.data!.totalExtraServicemen ?? 1) : 0))} ${language(context, translations!.serviceman)}",
                  style: appCss.dmDenseMedium12
                      .textColor(appColor(context).darkText)),
            if (widget.data!.dateTime != null)
              StatusRow(
                  statusText: widget.data!.bookingStatus!.name,
                  statusId: widget.data!.bookingStatusId,
                  title: translations!.dateTime,
                  onTap: widget.editDateTimeTap!,
                  title2: DateFormat("dd-MM-yyyy, hh:mm aa")
                      .format(DateTime.parse(widget.data!.dateTime!)),
                  isDateLocation:
                      widget.data!.bookingStatus!.slug == translations!.pending
                          ? true
                          : false,
                  style: appCss.dmDenseMedium12
                      .textColor(appColor(context).darkText)),
            StatusRow(
                statusText: widget.data!.bookingStatus!.name,
                statusId: widget.data!.bookingStatusId,
                title: translations!.location,
                onTap: widget.editLocationTap,
                title2: widget.data!.consumer != null
                    ? widget.data!.address == null
                        ? getAddress(context, widget.data!.addressId)
                        : "${widget.data!.address!.address}-${widget.data!.address!.area ?? widget.data!.address!.state!.name}"
                    : "",
                isDateLocation: (widget.data!.bookingStatus!.slug ==
                        translations!.pending &&
                    widget.data!.bookingStatus!.slug !=
                        translations!.cancelled),
                style: appCss.dmDenseMedium12
                    .textColor(appColor(context).darkText)),
            if (widget.data!.bookingStatus!.slug != translations!.cancelled)
              StatusRow(
                  statusText: widget.data!.bookingStatus!.name,
                  statusId: widget.data!.bookingStatusId,
                  title: translations!.payment,
                  title2: widget.data!.paymentStatus != null
                      ? widget.data!.paymentMethod == "cash"
                          ? widget.data!.paymentStatus!.toLowerCase() ==
                                  "completed"
                              ? widget.data!.paymentStatus!
                              : language(context, translations!.notPaid)
                                  .toUpperCase()
                          : widget.data!.paymentStatus!
                      : widget.data!.bookingStatus!.slug ==
                              translations!.completed
                          ? widget.data!.paymentStatus == "COMPLETED"
                              ? language(context, translations!.paid)
                              : language(context, translations!.notPaid)
                          : widget.data!.paymentMethod == "cash"
                              ? language(context, translations!.notPaid)
                              : language(context, translations!.paid),
                  style: appCss.dmDenseMedium12
                      .textColor(appColor(context).online)),
            StatusRow(
                title: translations!.paymentMode,
                title2: widget.data!.paymentMethod == "on_hand" ||
                        widget.data!.paymentMethod == "cash"
                    ? language(context, translations!.cash)
                    : capitalizeFirstLetter(widget.data!.paymentMethod),
                style:
                    appCss.dmDenseMedium12.textColor(appColor(context).online)),
            const VSpace(Sizes.s15),
            if (widget.data!.isExpand!)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.data!.provider != null)
                    ServiceProviderLayout(
                            title: language(context, translations!.provider),
                            image: widget.data!.provider!.media != null &&
                                    widget.data!.provider!.media!.isNotEmpty
                                ? widget.data!.provider!.media![0].originalUrl!
                                : null,
                            name: widget.data!.provider!.name,
                            rate:
                                widget.data!.provider!.reviewRatings != null
                                    ? widget.data!.provider!.reviewRatings
                                        .toString()
                                    : "0",
                            index: 0,
                            list: const [])
                        .paddingSymmetric(horizontal: Insets.i12)
                        .boxShapeExtension(
                            color: appColor(context).fieldCardBg,
                            radius: AppRadius.r15),
                  if (widget.data!.servicemen != null &&
                      widget.data!.servicemen!.isNotEmpty)
                    Image.asset(eImageAssets.bulletDotted)
                        .paddingSymmetric(vertical: Insets.i12),
                  Stack(alignment: Alignment.bottomCenter, children: [
                    Column(children: [
                      if (widget.data!.servicemen!.isNotEmpty)
                        Column(
                            children: widget.data!.servicemen!
                                .asMap()
                                .entries
                                .map((s) {
                          return ServiceProviderLayout(
                              isProvider: false,
                              title: language(context, translations!.serviceman)
                                  .capitalizeFirst(),
                              image: s.value.media != null
                                  ? s.value.media![0].originalUrl!
                                  : null,
                              name: s.value.name,
                              rate: s.value.reviewRatings ?? "0",
                              index: s.key,
                              list: widget.data!.servicemen!);
                        }).toList())
                    ])
                        .paddingSymmetric(horizontal: Insets.i12)
                        .boxShapeExtension(
                            color: appColor(context).fieldCardBg,
                            radius: AppRadius.r15)
                        .paddingOnly(
                            bottom: widget.data!.servicemen!.length > 1
                                ? Insets.i15
                                : 0),
                  ])
                ],
              ),
          ])
              .paddingSymmetric(vertical: Insets.i15, horizontal: Insets.i15)
              .decorated(
                  color: appColor(context).whiteBg,
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                  boxShadow: [
                    BoxShadow(
                        color: appColor(context).darkText.withOpacity(0.06),
                        blurRadius: 12,
                        spreadRadius: 0,
                        offset: const Offset(0, 2)),
                  ],
                  border: Border.all(color: appColor(context).stroke))
              .padding(bottom: Insets.i20, horizontal: Sizes.s20)
              .inkWell(onTap: widget.onTap),
          Transform.translate(
            offset: const Offset(0, -Insets.i10), // Moves the container upwards
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Insets.i10),
                color: appColor(context).primary,
              ),
              padding: const EdgeInsets.symmetric(
                  vertical: Sizes.s4, horizontal: Sizes.s10),
              child: Text(
                "#${widget.data!.bookingNumber!}",
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).whiteColor),
              ),
            ),
          ).padding(horizontal: Sizes.s40),
          Positioned(
              bottom: Insets.i2,
              left: 175,
              right: 175,
              child: CommonArrow(
                      arrow: widget.data!.isExpand == true
                          ? eSvgAssets.upDoubleArrow
                          : eSvgAssets.downDoubleArrow,
                      isThirteen: true,
                      onTap: () => value.onExpand(widget.data, widget.index!),
                      color: appColor(context).fieldCardBg)
                  .center()),
        ],
      ).paddingOnly(top: Sizes.s10, bottom: Sizes.s8);
    });
  }
}
