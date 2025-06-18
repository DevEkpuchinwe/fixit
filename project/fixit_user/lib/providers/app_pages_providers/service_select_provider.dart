import 'dart:convert';
import 'dart:developer';

import 'package:fixit_user/widgets/alert_message_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../config.dart';
import '../../utils/date_time_picker.dart';

class ServiceSelectProvider with ChangeNotifier {
  bool isStep2 = false, isPackage = false, isBottom = true;
  Services? servicesCart;
  PrimaryAddress? address;
  int selectProviderIndex = 0;
  UserModel? userModel;
  final FocusNode noteFocus = FocusNode();
  TextEditingController txtNote = TextEditingController();
  ScrollController scrollController = ScrollController();

  bool isPositionedRight = false;
  bool isAnimateOver = false;
  AnimationController? controller;
  Animation<Offset>? offsetAnimation;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void listen() {
    if (scrollController.position.pixels >= 100) {
      hide();
      log("scrollController.position.pixels${scrollController.position.pixels}");
      notifyListeners();
    } else {
      show();
      log("scrollController.position.pixels${scrollController.position.pixels}");
      notifyListeners();
    }

    notifyListeners();
  }

  void show() {
    if (!isBottom) {
      isBottom = true;
      notifyListeners();
    }
  }

  void hide() {
    if (isBottom) {
      isBottom = false;
      notifyListeners();
    }
  }

  deleteJobRequestConfirmation(context, sync, index) {
    animateDesign(sync);
    showDialog(
        context: context,
        builder: (context1) {
          return StatefulBuilder(builder: (context2, setState) {
            return Consumer<SlotBookingProvider>(
                builder: (context3, value, child) {
              return AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  insetPadding:
                      const EdgeInsets.symmetric(horizontal: Insets.i20),
                  shape: const SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius.all(SmoothRadius(
                          cornerRadius: AppRadius.r14, cornerSmoothing: 1))),
                  backgroundColor: appColor(context).whiteBg,
                  content: Stack(alignment: Alignment.topRight, children: [
                    Column(mainAxisSize: MainAxisSize.min, children: [
                      // Gif
                      Stack(alignment: Alignment.topCenter, children: [
                        Stack(alignment: Alignment.topCenter, children: [
                          SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        SizedBox(
                                            height: Sizes.s208,
                                            width: Sizes.s150,
                                            child: AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                curve: isPositionedRight
                                                    ? Curves.bounceIn
                                                    : Curves.bounceOut,
                                                alignment: isPositionedRight
                                                    ? Alignment.center
                                                    : Alignment.topCenter,
                                                child: AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 200),
                                                    height: 40,
                                                    child: Image.asset(
                                                        eImageAssets
                                                            .removeAddOn)))),
                                        Image.asset(eImageAssets.dustbin,
                                                height: Sizes.s88,
                                                width: Sizes.s88)
                                            .paddingOnly(bottom: Insets.i24)
                                      ]))
                              .decorated(
                                  color: appColor(context).fieldCardBg,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.r10)),
                        ]),
                        if (offsetAnimation != null)
                          SlideTransition(
                              position: offsetAnimation!,
                              child: (offsetAnimation != null &&
                                      isAnimateOver == true)
                                  ? Image.asset(eImageAssets.dustbinCover,
                                      height: 38)
                                  : const SizedBox())
                      ]),
                      // Sub text
                      const VSpace(Sizes.s15),
                      Text(language(context, translations!.removeAddOnsDes),
                              textAlign: TextAlign.center,
                              style: appCss.dmDenseRegular14
                                  .textColor(appColor(context).lightText)
                                  .textHeight(1.6))
                          .paddingSymmetric(horizontal: Sizes.s56),
                      const VSpace(Sizes.s25),
                      Row(children: [
                        Expanded(
                            child: ButtonCommon(
                                onTap: () => route.pop(context),
                                title: translations!.no,
                                borderColor: appColor(context).primary,
                                color: appColor(context).whiteBg,
                                style: appCss.dmDenseSemiBold16
                                    .textColor(appColor(context).primary))),
                        const HSpace(Sizes.s15),
                        Expanded(
                            child: ButtonCommon(
                                color: appColor(context).primary,
                                onTap: () {
                                  servicesCart!.selectedAdditionalServices!
                                      .removeAt(index);
                                  notifyListeners();
                                  route.pop(context);
                                },
                                style: appCss.dmDenseSemiBold16
                                    .textColor(appColor(context).whiteColor),
                                title: translations!.yes))
                      ])
                    ]).padding(
                        horizontal: Insets.i20,
                        top: Insets.i60,
                        bottom: Insets.i20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title
                          Text(language(context, translations!.removeAddOns),
                              style: appCss.dmDenseExtraBold18
                                  .textColor(appColor(context).darkText)),
                          Icon(CupertinoIcons.multiply,
                                  size: Sizes.s20,
                                  color: appColor(context).darkText)
                              .inkWell(onTap: () => route.pop(context))
                        ]).paddingAll(Insets.i20)
                  ]));
            });
          });
        }).then((value) {
      isPositionedRight = false;
      isAnimateOver = false;
      notifyListeners();
    });
  }

  animateDesign(TickerProvider sync) {
    Future.delayed(DurationClass.s1).then((value) {
      isPositionedRight = true;
      notifyListeners();
    }).then((value) {
      Future.delayed(DurationClass.ms150).then((value) {
        isAnimateOver = true;
        notifyListeners();
      }).then((value) {
        controller = AnimationController(
            vsync: sync, duration: const Duration(seconds: 2))
          ..forward();
        offsetAnimation = Tween<Offset>(
                begin: const Offset(0, 0.5), end: const Offset(0, 1.6))
            .animate(
                CurvedAnimation(parent: controller!, curve: Curves.elasticOut));
        notifyListeners();
      });
    });

    notifyListeners();
  }

  addToCart(context) async {
    debugPrint(":::;Serr :${servicesCart!.selectedServiceMan}");
    servicesCart!.primaryAddress = address;
    notifyListeners();
    final cartCtrl = Provider.of<CartProvider>(context, listen: false);

    int index = cartCtrl.cartList.indexWhere((element) =>
        element.isPackage == false &&
        element.serviceList != null &&
        element.serviceList!.id == servicesCart!.id);
    log("ADDD :${servicesCart!.primaryAddress}");
    if (index >= 0) {
      //snackBarMessengers(context, message: "Package Already Added");
      cartCtrl.cartList[index].serviceList = servicesCart;

      cartCtrl.notifyListeners();
    } else {
      CartModel cartModel =
          CartModel(isPackage: false, serviceList: servicesCart);
      cartCtrl.cartList.add(cartModel);
      cartCtrl.notifyListeners();
    }

    log("CART: ${cartCtrl.cartList}");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(session.cart);
    List<String> personsEncoded =
        cartCtrl.cartList.map((person) => jsonEncode(person.toJson())).toList();
    await preferences.setString(session.cart, json.encode(personsEncoded));

    cartCtrl.notifyListeners();
    cartCtrl.checkout(context);
    isStep2 = false;
    notifyListeners();
    route.pushNamed(context, routeName.cartScreen);
  }

  onNext(context) {
    if ((servicesCart!.selectedRequiredServiceMan!) ==
        (servicesCart!.selectedServiceMan != null
            ? servicesCart!.selectedServiceMan!.length
            : 1)) {
      servicesCart!.selectServiceManType = "as_per_my_choice";
      if (address != null) {
        if (servicesCart!.serviceDate != null) {
          if (servicesCart!.selectedServiceMan != null &&
              servicesCart!.selectedServiceMan!.isNotEmpty) {
            if (isPackage) {
              isStep2 = false;
              notifyListeners();
              final packageCtrl =
                  Provider.of<SelectServicemanProvider>(context, listen: false);
              servicePackageList[selectProviderIndex] = servicesCart!;

              route.pop(context, arg: servicesCart);
            } else {
              isStep2 = true;
            }
          } else {
            snackBarMessengers(context,
                message: "Please select Any 1 serviceman",
                color: appColor(context).red);
          }
        } else {
          snackBarMessengers(context,
              message: "Please select Date/Time slot",
              color: appColor(context).red);
        }
      } else {
        snackBarMessengers(context,
            message: "Please select Date/Time slot",
            color: appColor(context).red);
      }
    } else {
      Fluttertoast.showToast(msg: "Please Select 1 more required serviceman");
      //snackBar(context,content: Text( "Please Select 1 more required serviceman"));
    }
    notifyListeners();
  }

  onInit(context) async {
    showLoading(context);

    scrollController.addListener(listen);
    isStep2 = false;
    log("Dsdgfh :$servicesCart");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    notifyListeners();
    /*  dynamic data = ModalRoute.of(context)!.settings.arguments;
    servicesCart = data['selectServicesCart'];
    servicesCart!.selectedRequiredServiceMan =
        servicesCart!.requiredServicemen ?? "1";
    isPackage = data['isPackage'] ?? false;
    selectProviderIndex = data['selectProviderIndex'] ?? 0;*/
    dynamic data = ModalRoute.of(context)!.settings.arguments;

    servicesCart = data['selectServicesCart'];
    log("data : ${servicesCart!.selectServiceManType}");
    servicesCart!.selectedRequiredServiceMan =
        servicesCart!.selectedRequiredServiceMan ?? 1;
    isPackage = data['isPackage'] ?? false;
    selectProviderIndex = data['selectProviderIndex'] ?? 0;
    notifyListeners();
    final locationCtrl = Provider.of<LocationProvider>(context, listen: false);
    if (locationCtrl.addressList.isNotEmpty) {
      int index = locationCtrl.addressList
          .indexWhere((element) => element.isPrimary == 1);
      if (index > 0) {
        address = locationCtrl.addressList[index];
      } else {
        address = locationCtrl.addressList[0];
      }
    }

    if (isPackage) {
      final packageCtrl =
          Provider.of<SelectServicemanProvider>(context, listen: false);
      servicePackageList[selectProviderIndex].primaryAddress = address;
      packageCtrl.notifyListeners();
    } else {
      servicesCart!.primaryAddress = address;
    }
    log("CHECK : #$isPackage");
    hideLoading(context);

    userModel =
        UserModel.fromJson(json.decode(preferences.getString(session.user)!));
    notifyListeners();
  }

  onChangeLocation(context, PrimaryAddress primaryAddress) {
    address = primaryAddress;
    if (isPackage) {
      final packageCtrl =
          Provider.of<SelectServicemanProvider>(context, listen: false);
      servicePackageList[selectProviderIndex].primaryAddress = address;
      packageCtrl.notifyListeners();
    } else {
      servicesCart!.primaryAddress = address;
    }
    notifyListeners();
  }

  Future<bool> checkSlotAvailable(context, id, indexKey) async {
    bool isValid = false;
    if (servicesCart!.serviceDate != null) {
      try {
        var data = {
          "provider_id": 4,
          "dateTime":
              "${DateFormat("dd-MMM-yyy,hh:mm").format(servicesCart!.serviceDate!)} ${DateFormat("aa").format(servicesCart!.serviceDate!).toLowerCase()}"
        };

        log("data : $data");
        await apiServices
            .getApi(api.isValidTimeSlot, data, isData: true, isToken: true)
            .then((value) async {
          if (value.isSuccess!) {
            log("DDAA `:${value.data}");
            if (value.data['isValidTimeSlot'] == true) {
              isValid = true;
              return true;
            }
            notifyListeners();
          } else {
            isValid = false;
            notifyListeners();
            snackBarMessengers(context, message: value.message);
            return false;
          }
        });
      } catch (e) {
        isValid = false;
        notifyListeners();
        return false;
      }
    } else {
      isValid = false;
      notifyListeners();
      snackBarMessengers(context, message: "Please Select Date and Time");
      return false;
    }
    return isValid;
  }

  onTapDate(context) {
    debugPrint("servicesCart :${servicesCart!.selectServiceManType}");
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context3) {
          return DateTimePicker(
            isService: isPackage,
            service: servicesCart,
            selectProviderIndex: selectProviderIndex,
          );
        }).then((value) {
      if (value != null) {
        log("SSSS:$value");
        notifyListeners();
        if (isPackage) {
          final packageCtrl =
              Provider.of<SelectServicemanProvider>(context, listen: false);
          servicesCart = value;
          servicePackageList[selectProviderIndex] = servicesCart!;
          servicePackageList[selectProviderIndex].serviceDate =
              servicesCart!.serviceDate;
          servicePackageList[selectProviderIndex].selectDateTimeOption =
              "custom";
          servicePackageList[selectProviderIndex].selectedDateTimeFormat =
              servicesCart!.selectedDateTimeFormat;
          notifyListeners();
          packageCtrl.notifyListeners();
        } else {
          servicesCart = value;
          notifyListeners();
        }
      }
    });
  }

  String buttonName(context) {
    String name = translations!.next;
    log("isPackage ::$isPackage");
    if (isPackage) {
      final packageCtrl =
          Provider.of<SelectServicemanProvider>(context, listen: false);
      if (servicePackageList.length == 1) {
        name = translations!.submit;
        return name;
      } else {
        log("IMDD:${selectProviderIndex + 1} //$selectProviderIndex");
        if (selectProviderIndex + 1 < servicePackageList.length) {
          name = translations!.submit;
        } else {
          name = translations!.next;
        }

        return name;
      }
    } else {
      return translations!.next;
    }
  }
}
