import 'package:fixit_user/services/environment.dart';

class ApiMethods {
  String login = '$apiUrl/login';
  String register = '$apiUrl/register';
  String socialLogin = '$apiUrl/social/login';
  String self = '$apiUrl/self';
  String forgotPassword = '$apiUrl/forgot-password';
  String verifyOtp = '$apiUrl/verifyOtp';
  String updatePassword = '$apiUrl/update-password';
  String banner = '$apiUrl/banner';
  String category = '$apiUrl/category';
  String servicePackages = '$apiUrl/servicePackages';
  String servicePackagesDetails = '$apiUrl/service-package';
  String featuredServices = '$apiUrl/featuredServices';
  String blog = '$apiUrl/blog';
  String favoriteList = '$apiUrl/favourite-list';
  String address = '$apiUrl/address';
  String setAddressPrimary = '$apiUrl/address/isPrimary';
  String page = '$apiUrl/page';
  String review = '$apiUrl/review';
  String rateApp = '$apiUrl/rate-app';
  String country = '$apiUrl/country';
  String updateProfile = '$apiUrl/updateProfile';
  String service = '$apiUrl/service';
  String coupon = '$apiUrl/coupon';
  String provider = '$apiUrl/provider';
  String currency = '$apiUrl/currency';
  String settings = '$apiUrl/settings';
  String highestRating = '$apiUrl/providers/highest-ratings';
  String providerTimeSlot = '$apiUrl/provider-time-slot';
  String isValidTimeSlot = '$apiUrl/isValidTimeSlot';
  String checkout = '$apiUrl/checkout';
  String notifications = '$apiUrl/notifications';
  String markAsRead = '$apiUrl/notifications/markAsRead';
  String serviceman = '$apiUrl/serviceman';
  String booking = '$apiUrl/booking';
  String wallet = '$apiUrl/wallet/consumer';
  String verifyPayment = '$apiUrl/verifyPayment';
  String bookingStatus = '$apiUrl/bookingStatus';
  String deleteNotification = '$apiUrl/clear-notifications';
  String deleteAccount = '$apiUrl/deleteAccount';
  String addMoneyToWallet = '$apiUrl/consumer/top-up';
  String extraPaymentCharge = '$apiUrl/booking/payment';
  String serviceFaq = '$apiUrl/service-faqs';
  String paymentMethod = '$apiUrl/payment-methods';
  String repayment = '$apiUrl/re-payment';
  String zoneByPoint = '$apiUrl/zone-by-point';
  String categoryList = '$apiUrl/categoryList';
  String serviceRequest = '$apiUrl/serviceRequest';
  String bid = '$apiUrl/bid';
  String sendOtp = '$apiUrl/sendOtp';
  String verifySendOtp = '$apiUrl/verifySendOtp';
  String zoneUpdate = '$apiUrl/zone-update';
  String systemLanguage = '$apiUrl/systemLang';
  String translate = '$apiUrl/systemLang/translate';
  String dashboardHome = '$apiUrl/dashboard/user';
}
