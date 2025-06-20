import 'dart:developer';

import 'package:fixit_provider/config.dart';

import '../../model/dash_board_model.dart' show Booking;
import '../../widgets/withdraw_amount_bottom_sheet.dart';

class HomeProvider with ChangeNotifier {
  List<String> wmy = <String>['W', 'M', 'Y'];
  ScrollController scrollController = ScrollController();
  bool isSwitch = true, isToolTip = false;
  int selectedIndex = 0;
  bool isSkeleton = true;
  AnimationStatus status = AnimationStatus.dismissed;

  FocusNode amountFocus = FocusNode();
  FocusNode messageFocus = FocusNode();

  int touchedIndex = -1;

  bool isPlaying = false;
  bool isTouchBar = false;

  final double width = 12;
  String? withdrawValue;

  List<BarChartGroupData>? rawBarGroups;
  List<BarChartGroupData>? showingBarGroups;

  int touchedGroupIndex = -1;

  //total weekly revenue count
  double get totalWeeklyRevenue =>
      appArray.weekData.fold(0, (i, j) => i + (j.y ?? 0.0));

  //total monthly revenue count
  double get totalMonthlyRevenue =>
      appArray.monthData.fold(0, (i, j) => i + (j.y ?? 0.0));

  //total yearly revenue count
  double get totalYearlyRevenue =>
      appArray.yearData.fold(0, (i, j) => i + (j.y ?? 0.0));

  // select week, month or year option for graph
  onTapWmy(index) {
    selectedIndex = index;
    isToolTip = false;
    notifyListeners();
  }
  var selectIndex=0;
  onTapIndexOne(value) {
    selectIndex = 1;
    notifyListeners();
  }

  onTapHomeBookings(
    Booking data,
    context,
  ) {
    final dash = Provider.of<UserDataApiProvider>(context, listen: false);

    // log("data.bookingStatus!.slug :${data.bookingStatus!.slug}");

    if (data.bookingStatus != null) {
      if (data.bookingStatus!.slug == appFonts.pending) {
        // log("data.bookingStatus!.slug :${appFonts.pending}");
        //route.pushNamed(context, routeName.packageBookingScreen);
        route
            .pushNamed(context, routeName.pendingBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.accepted) {
        if (isFreelancer) {
          log("message");
          route.pushNamed(context, routeName.assignBooking, arg: data.id);
        } else {
          route
              .pushNamed(context, routeName.acceptedBooking, arg: data.id)
              .then((e) {
            dash.loadBookingsFromLocal(context);
          });
        }
      } else if (data.bookingStatus!.slug == appFonts.pendingApproval) {
        route
            .pushNamed(context, routeName.pendingApprovalBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.hold) {
        route.pushNamed(context, routeName.holdBooking, arg: data.id).then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.onHold) {
        route.pushNamed(context, routeName.holdBooking, arg: data.id).then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.onGoing.toLowerCase() ||
          data.bookingStatus!.slug == appFonts.ontheway ||
          data.bookingStatus!.slug == appFonts.ontheway1 ||
          data.bookingStatus!.slug == appFonts.startAgain) {
        log("Sh");
        route
            .pushNamed(context, routeName.ongoingBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.completed) {
        route
            .pushNamed(context, routeName.completedBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.assigned) {
        route
            .pushNamed(context, routeName.assignBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.cancel ||
          data.bookingStatus!.slug == appFonts.decline) {
        route
            .pushNamed(context, routeName.cancelledBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      }
    } else {
      route
          .pushNamed(context, routeName.pendingBooking, arg: data.id)
          .then((e) {
        dash.getBookingHistory(context);
      });
    }
  }

// on booking tap redirect to page as per booking status
  onTapBookings(
    BookingModel data,
    context,
  ) {
    final dash = Provider.of<UserDataApiProvider>(context, listen: false);

    // log("data.bookingStatus!.slug :${data.bookingStatus!.slug}");

    if (data.bookingStatus != null) {
      if (data.bookingStatus!.slug == appFonts.pending) {
        // log("data.bookingStatus!.slug :${appFonts.pending}");
        //route.pushNamed(context, routeName.packageBookingScreen);
        route
            .pushNamed(context, routeName.pendingBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.accepted) {
        if (isFreelancer) {
          log("message");
          route.pushNamed(context, routeName.assignBooking, arg: data.id);
        } else {
          route
              .pushNamed(context, routeName.acceptedBooking, arg: data.id)
              .then((e) {
            dash.loadBookingsFromLocal(context);
          });
        }
      } else if (data.bookingStatus!.slug == appFonts.pendingApproval) {
        route
            .pushNamed(context, routeName.pendingApprovalBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.hold) {
        route.pushNamed(context, routeName.holdBooking, arg: data.id).then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.onHold) {
        route.pushNamed(context, routeName.holdBooking, arg: data.id).then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.onGoing.toLowerCase() ||
          data.bookingStatus!.slug == appFonts.ontheway ||
          data.bookingStatus!.slug == appFonts.ontheway1 ||
          data.bookingStatus!.slug == appFonts.startAgain) {
        log("Sh");
        route
            .pushNamed(context, routeName.ongoingBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.completed) {
        route
            .pushNamed(context, routeName.completedBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.assigned) {
        route
            .pushNamed(context, routeName.assignBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      } else if (data.bookingStatus!.slug == appFonts.cancel ||
          data.bookingStatus!.slug == appFonts.decline) {
        route
            .pushNamed(context, routeName.cancelledBooking, arg: data.id)
            .then((e) {
          dash.loadBookingsFromLocal(context);
        });
      }
    } else {
      route
          .pushNamed(context, routeName.pendingBooking, arg: data.id)
          .then((e) {
        dash.getBookingHistory(context);
      });
    }
  }

  //gridview tap
  onTapOption(index, context, title, data) {
    final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
    final value = Provider.of<DashboardProvider>(context, listen: false);
    if (title == translations!.totalService) {
      route.pushNamed(context, routeName.serviceList);
    } else if (title == translations!.totalCategory) {
      route.pushNamed(context, routeName.categories);
    } else if (title == translations!.totalEarning) {
      Future.delayed(DurationsDelay.ms150).then((value) {
        // userApi.commissionHistory(false, context);
        var userdata = Provider.of<UserDataApiProvider>(context, listen: false);
        userApi.getTotalEarningByCategory();
        notifyListeners();
      });
      route.pushNamed(context, routeName.earnings);
    } else if (title == translations!.totalServiceman) {
      route.pushNamed(context, routeName.servicemanList);
    } else if (title == translations!.totalBooking) {
      value.selectIndex = 1;
      value.notifyListeners();
    }
  }

  //statistic tap function
  onStatisticTapOption(index, context) {
    final value = Provider.of<DashboardProvider>(context, listen: false);
    if (index == 2) {
      route.pushNamed(context, routeName.serviceList);
    } else if (index == 0) {
      route.pushNamed(context, routeName.earnings);
    } else {
      value.selectIndex = 1;
      value.notifyListeners();
    }
  }

  onReady(context, sync) async {
    Future.wait([
      Future(
        () {
          final commonApi =
              Provider.of<CommonApiProvider>(context, listen: false);
          commonApi.getBlog();
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          userApi.loadBookingsFromLocal(context);
        },
      )
    ]);
    messageFocus.addListener(() {
      notifyListeners();
    });

    await Future.delayed(const Duration(milliseconds: 150));
    isSkeleton = false;
    notifyListeners();
    notifyListeners();
  }

  //on with bottom sheet open
  onWithdraw(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      builder: (context1) {
        return const WithdrawAmountBottomSheet();
      },
    ).then((value) {
      log("SSSS");
      final wallet = Provider.of<WalletProvider>(context, listen: false);
      wallet.amountCtrl.text = "";
      wallet.withDrawAmountCtrl.text = "";
      wallet.messageCtrl.text = "";
    });
  }
}
