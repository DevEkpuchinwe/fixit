import 'package:fixit_user/screens/bottom_screens/home_screen/layouts/home_body.dart';
import 'package:upgrader/upgrader.dart';

import '../../../config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer2<DashboardProvider, CommonApiProvider>(
        builder: (context3, dash, common, child) {
      return Consumer<HomeScreenProvider>(builder: (context1, value, child) {
        return Consumer<LocationProvider>(
            builder: (context2, locationCtrl, child) {
          return UpgradeAlert(
            showIgnore: false,
            showLater: false,
            child: StatefulWrapper(
                onInit: () => Future.delayed(const Duration(milliseconds: 100),
                    () => value.onAnimate(this)),
                child: common.isLoadingDashboard /*  value.isSkeleton */
                    ? const HomeSkeleton()
                    : RefreshIndicator(
                        onRefresh: () async {
                          return dash.onRefresh(context);
                        },
                        child: Scaffold(
                            appBar: AppBar(
                                leadingWidth: MediaQuery.of(context).size.width,
                                leading: HomeAppBar(location: street ?? "")),
                            body: /*  !value.isEmptyLayout(context)
                          ? /* const CommonEmpty() */ Container()
                          :  */
                                const HomeBody()),
                      )),
          );
        });
      });
    });
  }
}
