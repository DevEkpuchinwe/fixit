import 'package:fixit_user/config.dart';
import 'package:fixit_user/models/translation_model.dart';

UserModel? userModel;

PrimaryAddress? userPrimaryAddress;

String? currentAddress, street;

LatLng? position;

String zoneIds = "";

int? setPrimaryAddress;

List<Services> servicePackageList = [];

List<CategoryModel> allCategoryList = [];

List<CategoryModel> homeCategoryList = [];
List<CategoryModel> homeHasSubCategoryList = [];
List<ServicePackageModel> homeServicePackagesList = [];
List<ProviderModel> homeProvider = [];
List<BlogModel> homeBlog = [];
List<Services> homeFeaturedService = [];

bool? isGuest;
