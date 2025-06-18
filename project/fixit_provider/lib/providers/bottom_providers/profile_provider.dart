import 'dart:developer';

import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/screens/bottom_screens/profile_screen/layouts/logout_alert.dart';

class ProfileProvider with ChangeNotifier {
  List<ProfileModel> profileLists = [];
  SharedPreferences? preferences;
  ServicemanModel? servicemanModel;
  dynamic timeSlot;

  //on page init data fetch
  onReady(context) async {
    preferences = await SharedPreferences.getInstance();

    profileLists = isServiceman
        ? appArray.profileListAsServiceman
            .map((e) => ProfileModel.fromJson(e))
            .toList()
        : isFreelancer
            ? appArray.profileListAsFreelance
                .map((e) => ProfileModel.fromJson(e))
                .toList()
            : appArray.profileList
                .map((e) => ProfileModel.fromJson(e))
                .toList();
    notifyListeners();
    if (isServiceman) {
      getServicemenById(context);
    }
  }

//get serviceman id
  getServicemenById(context) async {
    try {
      await apiServices
          .getApi("${api.serviceman}/${userModel!.id}", [], isData: true)
          .then((value) {
        if (value.isSuccess!) {
          servicemanModel = ServicemanModel.fromJson(value.data);
        }
        notifyListeners();
      });
    } catch (e) {
      log("ERRROEEE11 getServicemenById : $e");

      notifyListeners();
    }
  }

  onTapSettingTap(context) {
    route.pushNamed(context, routeName.appSetting).then((val) {
      log("sss:");
      notifyListeners();
    });
  }

  //on delete account
  onDeleteAccount(context, sync) {
    final value = Provider.of<DeleteDialogProvider>(context, listen: false);
    value.onDeleteAccount(sync, context);
    value.notifyListeners();
  }

  //logout alert confirmation
  onLogout(context) {
    showDialog(
      context: context,
      builder: (context) {
        return LogoutAlert(onTap: () async {
          final dash = Provider.of<DashboardProvider>(context, listen: false);
          dash.selectIndex = 0;
          dash.notifyListeners();
          hideLoading(context);
          preferences!.remove(session.user);
          preferences!.remove(session.accessToken);
          preferences!.remove(session.token);
          preferences!.remove(session.isLogin);
          preferences!.remove(session.isFreelancer);
          preferences!.remove(session.isServiceman);
          preferences!.remove(session.isLogin);
          userModel = null;
          userPrimaryAddress = null;
          provider = null;
          position = null;
          statisticModel = null;
          bankDetailModel = null;
          popularServiceList = [];
          servicePackageList = [];
          providerDocumentList = [];
          notificationList = [];
          notUpdateDocumentList = [];
          addressList = [];
          notifyListeners();
          route.pop(context);

          route.pushNamedAndRemoveUntil(context, routeName.intro);
        });
      },
    );
  }

  //profile list setting tap layout
  onTapOption(data, context, sync) async {
    final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
    final commonApi = Provider.of<CommonApiProvider>(context, listen: false);
    if (data.title == translations!.companyDetails) {
      route.pushNamed(context, routeName.companyDetails);
    } else if (data.title == translations!.bankDetails) {
      userApi.getBankDetails();
      route.pushNamed(context, routeName.bankDetails);
    } else if (data.title == translations!.idVerification) {
      /*  Future.delayed(Duration(milliseconds: 150)).then(
        (value) async {
          await userApi.getDocumentDetails();
          await commonApi.getDocument();
          notifyListeners();
        },
      ); */

      await route.pushNamed(context, routeName.idVerification);
    } else if (data.title == translations!.timeSlots) {
      route.pushNamed(context, routeName.timeSlot);
    } else if (data.title == translations!.myPackages) {
      Future.delayed(DurationsDelay.ms150).then((value) async {
        await userApi.getServicePackageList();
        notifyListeners();
      });
      route.pushNamed(context, routeName.packagesList);
    } else if (data.title == translations!.commissionDetails) {
      Future.delayed(DurationsDelay.ms150).then((value) {
        userApi.commissionHistory(false, context);
        notifyListeners();
      });
      route.pushNamed(context, routeName.commissionHistory);
    } else if (data.title == translations!.myReview) {
      route.pushNamed(context, routeName.serviceReview,
          arg: {"isSetting": true});
    } else if (data.title == translations!.subscriptionPlan) {
      Future.delayed(DurationsDelay.ms150).then((value) async {
        final commonApi =
            Provider.of<CommonApiProvider>(context, listen: false);
        await commonApi.getSubscriptionPlanList(context);
        notifyListeners();
      });
      !isSubscription
          ? route.pushNamed(context, routeName.subscriptionPlan)
          : route.pushNamed(context, routeName.planDetails);
    } else if (data.title == translations!.deleteAccount) {
      onDeleteAccount(context, sync);
      notifyListeners();
    } else if (data.title == translations!.logOut) {
      onLogout(context);
    } else if (data.title == translations!.serviceLocation) {
      route.pushNamed(context, routeName.companyDetails);
    } else if (data.title == translations!.serviceman) {
      route.pushNamed(context, routeName.servicemanList);
    } else if (data.title == translations!.services) {
      route.pushNamed(context, routeName.serviceList);
    }
  }
}
