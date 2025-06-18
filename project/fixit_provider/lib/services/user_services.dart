import 'package:camera/camera.dart';
import 'package:fixit_provider/model/dash_board_model.dart';

import '../config.dart';

bool isFreelancer = false,
    isLogin = false,
    isServiceman = false,
    isSubscription = false;

List<CameraDescription> cameras = [];
UserModel? userModel;

PrimaryAddress? userPrimaryAddress;

ProviderModel? provider;

String? currentAddress, street;

LatLng? position;

int? setPrimaryAddress;

SubscriptionModel? userSubscribe;

ActiveSubscription? activeSubscription;

StatisticModel? statisticModel;
DashboardModel? dashBoardModel;
List<dynamic> booking = [];
// LatestServiceRequest? latestServiceRequest;

BankDetailModel? bankDetailModel;

List<Services> popularServiceList = [];
List<PopularService> popularServiceHome = [];

List<Services> allServices = [];

List<ServicePackageModel> servicePackageList = [];

List<ProviderDocumentModel> providerDocumentList = [];

List<NotificationModel> notificationList = [];

List<DocumentModel> notUpdateDocumentList = [];

List<PrimaryAddress> addressList = [];

List<Services> allServiceList = [];
List<LatestBlog> latestBlogs = [];

List<Reviews> reviewList = [];

List<JobRequestModel> jobRequestList = [];
List<LatestServiceRequest> latestServiceRequest = [];

Chart? chart;

CommissionHistoryModel? commissionList;

TotalEarningModel? totalEarningModel;
