import 'dart:developer';
import 'dart:io';
import 'package:fixit_user/helper/notification.dart';
import 'package:fixit_user/providers/app_pages_providers/audio_call_provider.dart';
import 'package:fixit_user/providers/app_pages_providers/job_request_providers/add_job_request_provider.dart';
import 'package:fixit_user/providers/app_pages_providers/job_request_providers/job_request_details_provider.dart';
import 'package:fixit_user/providers/app_pages_providers/video_call_provider.dart';
import 'package:fixit_user/services/environment.dart';
import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:upgrader/upgrader.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'common/theme/app_theme.dart';
import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (Platform.isAndroid) {
    log("app android ");
    await Firebase.initializeApp(
        name: "Fixit",
        options: const FirebaseOptions(
            apiKey: "YOUR API KEY",
            appId: "YOUR APP ID",
            messagingSenderId: "YOUR MESSAGINGSENDER ID",
            projectId: "YOUR PROJECT ID"));
  } else {
    log("app IOS");
    await Firebase.initializeApp(
        name: "Fixit",
        options: const FirebaseOptions(
            apiKey: "YOUR API KEY",
            appId: "1:YOUR MESSAGINGSENDER ID:ios:d820cae61cc7463f740ab3",
            messagingSenderId: "YOUR MESSAGINGSENDER ID",
            projectId: "YOUR PROJECT ID"));
  }
  await initializeAppSettings();

  String? jsonString = sharedPreferences.getString("apiJsonData");
  log("selectedLocale:::$jsonString");
  sharedPreferences.getString("selectedLocale");
  log("=-=-=-=-=-=-=-=-=- ${sharedPreferences.getString("selectedLocale")}");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    lockScreenPortrait();
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context1, AsyncSnapshot<SharedPreferences> snapData) {
          if (snapData.hasData) {
            return MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                      create: (_) => ThemeService(snapData.data!, context)),
                  ChangeNotifierProvider(create: (_) => SplashProvider()),
                  ChangeNotifierProvider(
                      create: (_) => LanguageProvider(snapData.data!)
                        ..getLanguageTranslate()),
                  ChangeNotifierProvider(create: (_) => CommonApiProvider()),
                  ChangeNotifierProvider(create: (_) => OnBoardingProvider()),
                  ChangeNotifierProvider(create: (_) => LoginProvider()),
                  ChangeNotifierProvider(
                      create: (_) => LoginWithPhoneProvider()),
                  ChangeNotifierProvider(create: (_) => VerifyOtpProvider()),
                  ChangeNotifierProvider(
                      create: (_) => ForgetPasswordProvider()),
                  ChangeNotifierProvider(create: (_) => RegisterProvider()),
                  ChangeNotifierProvider(
                      create: (_) => ResetPasswordProvider()),
                  ChangeNotifierProvider(create: (_) => LoadingProvider()),
                  ChangeNotifierProvider(create: (_) => DashboardProvider()),
                  ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
                  ChangeNotifierProvider(create: (_) => ProfileProvider()),
                  ChangeNotifierProvider(
                      create: (_) => AppSettingProvider(snapData.data!)),
                  ChangeNotifierProvider(create: (_) => CurrencyProvider()),
                  ChangeNotifierProvider(
                      create: (_) => ProfileDetailProvider()),
                  ChangeNotifierProvider(
                      create: (_) => FavouriteListProvider()),
                  ChangeNotifierProvider(
                      create: (_) => CommonPermissionProvider()),
                  ChangeNotifierProvider(create: (_) => LocationProvider()),
                  ChangeNotifierProvider(
                      create: (_) => ChangePasswordProvider()),
                  ChangeNotifierProvider(create: (_) => MyReviewProvider()),
                  ChangeNotifierProvider(create: (_) => EditReviewProvider()),
                  ChangeNotifierProvider(create: (_) => AppDetailsProvider()),
                  ChangeNotifierProvider(create: (_) => RateAppProvider()),
                  ChangeNotifierProvider(create: (_) => ContactUsProvider()),
                  ChangeNotifierProvider(create: (_) => NotificationProvider()),
                  ChangeNotifierProvider(create: (_) => NewLocationProvider()),
                  ChangeNotifierProvider(create: (_) => SearchProvider()),
                  ChangeNotifierProvider(
                      create: (_) => LatestBLogDetailsProvider()),
                  ChangeNotifierProvider(create: (_) => NoInternetProvider()),
                  ChangeNotifierProvider(
                      create: (_) => CategoriesListProvider()),
                  ChangeNotifierProvider(
                      create: (_) => CategoriesDetailsProvider()),
                  ChangeNotifierProvider(
                      create: (_) => ServicesDetailsProvider()),
                  ChangeNotifierProvider(
                      create: (_) => ServiceReviewProvider()),
                  ChangeNotifierProvider(
                      create: (_) => ProviderDetailsProvider()),
                  ChangeNotifierProvider(create: (_) => SlotBookingProvider()),
                  ChangeNotifierProvider(create: (_) => CartProvider()),
                  ChangeNotifierProvider(create: (_) => PaymentProvider()),
                  ChangeNotifierProvider(create: (_) => WalletProvider()),
                  ChangeNotifierProvider(
                      create: (_) => ServicemanListProvider()),
                  ChangeNotifierProvider(
                      create: (_) => ServiceSelectProvider()),
                  ChangeNotifierProvider(
                      create: (_) => SelectServicemanProvider()),
                  ChangeNotifierProvider(create: (_) => BookingProvider()),
                  ChangeNotifierProvider(
                      create: (_) => PendingBookingProvider()),
                  ChangeNotifierProvider(
                      create: (_) => AcceptedBookingProvider()),
                  ChangeNotifierProvider(create: (_) => ChatProvider()),
                  ChangeNotifierProvider(
                      create: (_) => OngoingBookingProvider()),
                  ChangeNotifierProvider(
                      create: (_) => CompletedServiceProvider()),
                  ChangeNotifierProvider(
                      create: (_) => ServicesPackageDetailsProvider()),
                  ChangeNotifierProvider(
                      create: (_) => CheckoutWebViewProvider()),
                  ChangeNotifierProvider(
                      create: (_) => CancelledBookingProvider()),
                  ChangeNotifierProvider(
                      create: (_) => PackageBookingProvider()),
                  ChangeNotifierProvider(
                      create: (_) => ServicemanDetailProvider()),
                  ChangeNotifierProvider(
                      create: (_) => FeaturedServiceProvider()),
                  ChangeNotifierProvider(
                      create: (_) => ExpertServiceProvider()),
                  ChangeNotifierProvider(create: (_) => ChatHistoryProvider()),
                  ChangeNotifierProvider(create: (_) => DeleteDialogProvider()),
                  ChangeNotifierProvider(
                      create: (_) => JobRequestListProvider()),
                  ChangeNotifierProvider(
                      create: (_) => AddJobRequestProvider()),
                  ChangeNotifierProvider(create: (_) => AudioCallProvider()),
                  ChangeNotifierProvider(create: (_) => VideoCallProvider()),
                  ChangeNotifierProvider(
                      create: (_) => JobRequestDetailsProvider()),
                  ChangeNotifierProvider(
                      create: (_) => ServicePackageAllListProvider()),
                ],
                child: UpgradeAlert(
                    dialogStyle: UpgradeDialogStyle.cupertino,
                    showIgnore: false,
                    showLater: false,
                    barrierDismissible: false,
                    child: const RouteToPage(),
                    upgrader: Upgrader(
                      storeController: UpgraderStoreController(
                        onAndroid: () => UpgraderPlayStore(),
                      ),
                    )));
          } else {
            return MaterialApp(
                theme: AppTheme.fromType(ThemeType.light).themeData,
                darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
                themeMode: ThemeMode.light,
                debugShowCheckedModeBanner: false,
                home: UpgradeAlert(
                    showIgnore: false,
                    showLater: false,
                    barrierDismissible: false,
                    dialogStyle: UpgradeDialogStyle.cupertino,
                    child: const SplashLayout(),
                    upgrader: Upgrader(
                      storeController: UpgraderStoreController(
                        onAndroid: () => UpgraderPlayStore(),
                      ),
                    )));
          }
        });
  }

  lockScreenPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}

class RouteToPage extends StatefulWidget {
  const RouteToPage({super.key});

  @override
  State<RouteToPage> createState() => _RouteToPageState();
}

class _RouteToPageState extends State<RouteToPage> {
  @override
  void initState() {
    // TODO: implement initState
    CustomNotificationController().initNotification(context);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(builder: (context, theme, child) {
      return Consumer<LanguageProvider>(builder: (context, lang, child) {
        return Consumer<CurrencyProvider>(builder: (context, currency, child) {
          // Check if currency is null, and handle it gracefully.
          if (currency.currency == null) {
            // Provide a fallback value or handle the null state
            currency.setVal(); // Initialize or set default value if needed.
          }
          final provider = Provider.of<LanguageProvider>(context, listen: true);

          return MaterialApp(
            title: 'Fixit User',
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.fromType(ThemeType.light).themeData,
            darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
            locale: provider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              AppLocalizationDelagate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            // Add the supported locales if needed
            themeMode: theme.theme,
            initialRoute: "/",
            routes: appRoute.route,
            // Wrap MaterialApp with Directionality
            builder: (context, child) {
              return Directionality(
                textDirection: lang.locale?.languageCode == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: child!,
              );
            },
          );
        });
      });
    });
  }
}
