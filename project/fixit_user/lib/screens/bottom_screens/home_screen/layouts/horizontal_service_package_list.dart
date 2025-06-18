import '../../../../config.dart';

class HorizontalServicePackageList extends StatelessWidget {
  final List<ServicePackageModel>? /* firstThreeServiceList, */
      servicePackagesList;
  final Animation<double>? rotationAnimation;
  const HorizontalServicePackageList(
      {super.key,
      /* this.firstThreeServiceList, */
      this.servicePackagesList,
      this.rotationAnimation});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: /* firstThreeServiceList!.isNotEmpty
            ? Row(
                    children: firstThreeServiceList!
                        .asMap()
                        .entries
                        .map((e) => ServicePackageList(
                              rotationAnimation: rotationAnimation,
                              data: e.value,
                              onTap: () => route.pushNamed(
                                  context, routeName.packageDetailsScreen,
                                  arg: {"services": e.value}),
                            ))
                        .toList())
                .paddingSymmetric(horizontal: Insets.i20)
            : */
            Row(
                    children: servicePackagesList!
                        .asMap()
                        .entries
                        .map((e) => ServicePackageList(
                            rotationAnimation: rotationAnimation,
                            data: e.value,
                            onTap: () => route.pushNamed(
                                context, routeName.packageDetailsScreen,
                                arg: {"services": e.value})))
                        .toList())
                .paddingSymmetric(horizontal: Insets.i20));
  }
}
