import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixit_user/config.dart';
import 'package:dio/dio.dart' as dio;
import 'package:fixit_user/widgets/alert_message_common.dart';

class LoginWithPhoneProvider with ChangeNotifier {
  TextEditingController numberController = TextEditingController();
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool isCodeSent = false;
  String dialCode = "+91";
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FocusNode phoneFocus = FocusNode();
  String? verificationCode;

  onTapOtp(context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (globalKey.currentState!.validate()) {
      showLoading(context);
      notifyListeners();
      sendOtp(context);
    }
  }


  //send Otp api
  sendOtp(context) async {
    showLoading(context);
    notifyListeners();

    try {
      dynamic mimeTypeData;

      var body = {
        "dial_code": dialCode.replaceAll("+", ""),
        "phone": numberController.text
      };
      dio.FormData formData = dio.FormData.fromMap(body);

      log("BODU :$body");

      await apiServices
          .postApi(api.sendOtp, formData, isToken: true)
          .then((value) async {
        hideLoading(context);
        notifyListeners();
        if (value.isSuccess!) {
          route.pushNamed(context, routeName.verifyOtp, arg: {
            "phone": numberController.text,
            "dialCode": dialCode,
            "verificationCode": verificationCode
          });

          notifyListeners();
        } else {
          snackBarMessengers(context, message: value.message);
        }
      });
    } catch (e) {
      hideLoading(context);
      notifyListeners();

      log("EEEE sendOTP : $e");
    }
  }

  changeDialCode(CountryCodeCustom country) {
    dialCode = country.dialCode!;
    notifyListeners();
  }
}
