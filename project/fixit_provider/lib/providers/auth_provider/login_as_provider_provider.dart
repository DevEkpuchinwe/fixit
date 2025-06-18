import 'dart:convert';
import 'dart:developer';
import 'package:fixit_provider/config.dart';
import '../../firebase/firebase_api.dart';

class LoginAsProvider with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> providerKey =
      GlobalKey<FormState>(debugLabel: 'providerKey');
  SharedPreferences? pref;
  bool isPassword = true;
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  // password see tap
  passwordSeenTap() {
    isPassword = !isPassword;
    notifyListeners();
  }

  demoCreds() {
    emailController.text = "provider@example.com";
    passwordController.text = "123456789";
    notifyListeners();
  }

  //login
  login(context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (formKey.currentState!.validate()) {
      pref = await SharedPreferences.getInstance();
      String token = await getFcmToken();

      showLoading(context);
      notifyListeners();

      var body = {
        "email": emailController.text,
        "password": passwordController.text,
        "fcm_token": token
      };

      try {
        await apiServices
            .postApi(api.login, jsonEncode(body))
            .then((value) async {
          notifyListeners();
          if (value.isSuccess!) {
            pref!.setBool(session.token, true);
            final commonApi =
                Provider.of<CommonApiProvider>(context, listen: false);
            await commonApi.selfApi(context);
            await commonApi.getDashBoardApi(context);
            dynamic userData = pref!.getString(session.user);
            if (userModel!.role!.name != "user") {
              if (userData != null) {
                final commonApi =
                    Provider.of<CommonApiProvider>(context, listen: false);

                final userApi =
                    Provider.of<UserDataApiProvider>(context, listen: false);

                if (!isFreelancer) {
                  await userApi.getServicemenByProviderId();
                }
                final locationCtrl =
                    Provider.of<LocationProvider>(context, listen: false);

                locationCtrl.getUserCurrentLocation(context);
                commonApi.selfApi(context);
                commonApi.getDashBoardApi(context);

                await Future.wait([
                  Future(
                    () {
                      // userApi.homeStatisticApi();
                      commonApi.getBlog();

                      // await userApi.getBankDetails();
                      // await userApi.getDocumentDetails();
                      userApi.getAddressList(context);
                      // userApi.getNotificationList();
                      // await userApi.getPopularServiceList();
                      userApi.getDocumentDetails();
                      commonApi.getDocument();
                      // userApi.getJobRequest();
                      userApi.getServicePackageList();
                      userApi.getAllServiceList();
                      userApi.getBookingHistory(context);
                      // userApi.statisticDetailChart();
                    },
                  )
                ]);

                // await commonApi.getBlog();
                // // await userApi.getBankDetails();
                // // await userApi.getDocumentDetails();
                // await userApi.getAddressList(context);
                // await userApi.getNotificationList();
                // // await userApi.getPopularServiceList();
                // await userApi.getDocumentDetails();
                // await commonApi.getDocument();
                // await userApi.getJobRequest();
                // await userApi.getServicePackageList();
                // await userApi.getAllServiceList();
                // await userApi.getBookingHistory(context);
                // userApi.statisticDetailChart();
                FirebaseApi().onlineActiveStatusChange(false);
              }
              hideLoading(context);

              route.pushReplacementNamed(context, routeName.dashboard);
              emailController.text = "";
              passwordController.text = "";
              notifyListeners();
            } else {
              hideLoading(context);
              snackBarMessengers(context,
                  message: "This action is unauthorized for users.",
                  color: appColor(context).appTheme.red);
            }
          } else {
            hideLoading(context);
            snackBarMessengers(context,
                message: value.message, color: appColor(context).appTheme.red);
          }
        });
      } catch (e, s) {
        hideLoading(context);
        notifyListeners();
        log("EEEE login : $e====> $s");
      }
    }
  }
}
