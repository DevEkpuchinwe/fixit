// // To parse this JSON data, do
// //
// //     final dashboardModel = dashboardModelFromJson(jsonString);

// import 'dart:convert';

// DashboardModel dashboardModelFromJson(String str) =>
//     DashboardModel.fromJson(json.decode(str));

// String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

// class DashboardModel {
//   List<AdBanner>? banners;
//   List<Coupon>? coupons;
//   List<AdBanner>? categories;
//   List<ServicePackage>? servicePackages;
//   List<FeaturedService>? featuredServices;
//   List<HighestRatedProvider>? highestRatedProviders;
//   List<Blog>? blogs;

//   DashboardModel({
//     this.banners,
//     this.coupons,
//     this.categories,
//     this.servicePackages,
//     this.featuredServices,
//     this.highestRatedProviders,
//     this.blogs,
//   });

//   factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
//         banners: json["banners"] == null
//             ? []
//             : List<AdBanner>.from(
//                 json["banners"]!.map((x) => AdBanner.fromJson(x))),
//         coupons: json["coupons"] == null
//             ? []
//             : List<Coupon>.from(
//                 json["coupons"]!.map((x) => Coupon.fromJson(x))),
//         categories: json["categories"] == null
//             ? []
//             : List<AdBanner>.from(
//                 json["categories"]!.map((x) => AdBanner.fromJson(x))),
//         servicePackages: json["servicePackages"] == null
//             ? []
//             : List<ServicePackage>.from(json["servicePackages"]!
//                 .map((x) => ServicePackage.fromJson(x))),
//         featuredServices: json["featuredServices"] == null
//             ? []
//             : List<FeaturedService>.from(json["featuredServices"]!
//                 .map((x) => FeaturedService.fromJson(x))),
//         highestRatedProviders: json["highestRatedProviders"] == null
//             ? []
//             : List<HighestRatedProvider>.from(json["highestRatedProviders"]!
//                 .map((x) => HighestRatedProvider.fromJson(x))),
//         blogs: json["blogs"] == null
//             ? []
//             : List<Blog>.from(json["blogs"]!.map((x) => Blog.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "banners": banners == null
//             ? []
//             : List<dynamic>.from(banners!.map((x) => x.toJson())),
//         "coupons": coupons == null
//             ? []
//             : List<dynamic>.from(coupons!.map((x) => x.toJson())),
//         "categories": categories == null
//             ? []
//             : List<dynamic>.from(categories!.map((x) => x.toJson())),
//         "servicePackages": servicePackages == null
//             ? []
//             : List<dynamic>.from(servicePackages!.map((x) => x.toJson())),
//         "featuredServices": featuredServices == null
//             ? []
//             : List<dynamic>.from(featuredServices!.map((x) => x.toJson())),
//         "highestRatedProviders": highestRatedProviders == null
//             ? []
//             : List<dynamic>.from(highestRatedProviders!.map((x) => x.toJson())),
//         "blogs": blogs == null
//             ? []
//             : List<dynamic>.from(blogs!.map((x) => x.toJson())),
//       };
// }

// class AdBanner {
//   int? id;
//   String? title;
//   List<BannerMedia>? media;

//   AdBanner({
//     this.id,
//     this.title,
//     this.media,
//   });

//   factory AdBanner.fromJson(Map<String, dynamic> json) => AdBanner(
//         id: json["id"],
//         title: json["title"],
//         media: json["media"] == null
//             ? []
//             : List<BannerMedia>.from(
//                 json["media"]!.map((x) => BannerMedia.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//         "media": media == null
//             ? []
//             : List<dynamic>.from(media!.map((x) => x.toJson())),
//       };
// }

// class BannerMedia {
//   int? id;
//   String? originalUrl;

//   BannerMedia({
//     this.id,
//     this.originalUrl,
//   });

//   factory BannerMedia.fromJson(Map<String, dynamic> json) => BannerMedia(
//         id: json["id"],
//         originalUrl: json["original_url"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "original_url": originalUrl,
//       };
// }

// class Blog {
//   int? id;
//   String? title;
//   String? description;
//   dynamic createdAt;
//   dynamic createdBy;
//   Map<String, String>? tags;
//   List<BannerMedia>? media;

//   Blog({
//     this.id,
//     this.title,
//     this.description,
//     this.createdAt,
//     this.createdBy,
//     this.tags,
//     this.media,
//   });

//   factory Blog.fromJson(Map<String, dynamic> json) => Blog(
//         id: json["id"],
//         title: json["title"],
//         description: json["description"],
//         createdAt: json["created_at"],
//         createdBy: json["created_by"],
//         tags: Map.from(json["tags"]!)
//             .map((k, v) => MapEntry<String, String>(k, v)),
//         media: json["media"] == null
//             ? []
//             : List<BannerMedia>.from(
//                 json["media"]!.map((x) => BannerMedia.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//         "description": description,
//         "created_at": createdAt,
//         "created_by": createdBy,
//         "tags": Map.from(tags!).map((k, v) => MapEntry<String, dynamic>(k, v)),
//         "media": media == null
//             ? []
//             : List<dynamic>.from(media!.map((x) => x.toJson())),
//       };
// }

// class Coupon {
//   int? id;
//   String? code;
//   int? minSpend;
//   String? type;
//   int? amount;

//   Coupon({
//     this.id,
//     this.code,
//     this.minSpend,
//     this.type,
//     this.amount,
//   });

//   factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
//         id: json["id"],
//         code: json["code"],
//         minSpend: json["min_spend"],
//         type: json["type"],
//         amount: json["amount"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "code": code,
//         "min_spend": minSpend,
//         "type": type,
//         "amount": amount,
//       };
// }

// class FeaturedService {
//   int? id;
//   String? title;
//   int? discount;
//   int? requiredServicemen;
//   int? price;
//   double? serviceRate;
//   String? description;
//   List<FeaturedServiceMedia>? media;

//   FeaturedService({
//     this.id,
//     this.title,
//     this.discount,
//     this.requiredServicemen,
//     this.price,
//     this.serviceRate,
//     this.description,
//     this.media,
//   });

//   factory FeaturedService.fromJson(Map<String, dynamic> json) =>
//       FeaturedService(
//         id: json["id"],
//         title: json["title"],
//         discount: json["discount"],
//         requiredServicemen: json["required_servicemen"],
//         price: json["price"],
//         serviceRate: json["service_rate"]?.toDouble(),
//         description: json["description"],
//         media: json["media"] == null
//             ? []
//             : List<FeaturedServiceMedia>.from(
//                 json["media"]!.map((x) => FeaturedServiceMedia.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//         "discount": discount,
//         "required_servicemen": requiredServicemen,
//         "price": price,
//         "service_rate": serviceRate,
//         "description": description,
//         "media": media == null
//             ? []
//             : List<dynamic>.from(media!.map((x) => x.toJson())),
//       };
// }

// class FeaturedServiceMedia {
//   int? id;
//   CollectionName? collectionName;
//   String? originalUrl;

//   FeaturedServiceMedia({
//     this.id,
//     this.collectionName,
//     this.originalUrl,
//   });

//   factory FeaturedServiceMedia.fromJson(Map<String, dynamic> json) =>
//       FeaturedServiceMedia(
//         id: json["id"],
//         collectionName: collectionNameValues.map[json["collection_name"]]!,
//         originalUrl: json["original_url"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "collection_name": collectionNameValues.reverse[collectionName],
//         "original_url": originalUrl,
//       };
// }

// enum CollectionName { IMAGE, THUMBNAIL, WEB_IMAGES, WEB_THUMBNAIL }

// final collectionNameValues = EnumValues({
//   "image": CollectionName.IMAGE,
//   "thumbnail": CollectionName.THUMBNAIL,
//   "web_images": CollectionName.WEB_IMAGES,
//   "web_thumbnail": CollectionName.WEB_THUMBNAIL
// });

// class HighestRatedProvider {
//   int? id;
//   String? name;
//   List<dynamic>? expertise;
//   int? reviewRatings;
//   List<String>? media;
//   PrimaryAddress? primaryAddress;

//   HighestRatedProvider({
//     this.id,
//     this.name,
//     this.expertise,
//     this.reviewRatings,
//     this.media,
//     this.primaryAddress,
//   });

//   factory HighestRatedProvider.fromJson(Map<String, dynamic> json) =>
//       HighestRatedProvider(
//         id: json["id"],
//         name: json["name"],
//         expertise: json["expertise"] == null
//             ? []
//             : List<dynamic>.from(json["expertise"]!.map((x) => x)),
//         reviewRatings: json["review_ratings"],
//         media: json["media"] == null
//             ? []
//             : List<String>.from(json["media"]!.map((x) => x)),
//         primaryAddress: json["primary_address"] == null
//             ? null
//             : PrimaryAddress.fromJson(json["primary_address"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "expertise": expertise == null
//             ? []
//             : List<dynamic>.from(expertise!.map((x) => x)),
//         "review_ratings": reviewRatings,
//         "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x)),
//         "primary_address": primaryAddress?.toJson(),
//       };
// }

// class PrimaryAddress {
//   int? id;
//   String? address;
//   String? area;
//   String? city;

//   PrimaryAddress({
//     this.id,
//     this.address,
//     this.area,
//     this.city,
//   });

//   factory PrimaryAddress.fromJson(Map<String, dynamic> json) => PrimaryAddress(
//         id: json["id"],
//         address: json["address"],
//         area: json["area"],
//         city: json["city"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "address": address,
//         "area": area,
//         "city": city,
//       };
// }

// class ServicePackage {
//   int? id;
//   String? hexaCode;
//   String? title;
//   int? price;
//   List<FeaturedServiceMedia>? media;

//   ServicePackage({
//     this.id,
//     this.hexaCode,
//     this.title,
//     this.price,
//     this.media,
//   });

//   factory ServicePackage.fromJson(Map<String, dynamic> json) => ServicePackage(
//         id: json["id"],
//         hexaCode: json["hexa_code"],
//         title: json["title"],
//         price: json["price"],
//         media: json["media"] == null
//             ? []
//             : List<FeaturedServiceMedia>.from(
//                 json["media"]!.map((x) => FeaturedServiceMedia.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "hexa_code": hexaCode,
//         "title": title,
//         "price": price,
//         "media": media == null
//             ? []
//             : List<dynamic>.from(media!.map((x) => x.toJson())),
//       };
// }

// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }

// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  List<AdBanner>? banners;
  List<Coupon>? coupons;
  List<DashboardModelCategory>? categories;
  List<ServicePackage>? servicePackages;
  List<FeaturedService>? featuredServices;
  List<HighestRatedProvider>? highestRatedProviders;
  List<Blog>? blogs;

  DashboardModel({
    this.banners,
    this.coupons,
    this.categories,
    this.servicePackages,
    this.featuredServices,
    this.highestRatedProviders,
    this.blogs,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        banners: json["banners"] == null
            ? []
            : List<AdBanner>.from(
                json["banners"]!.map((x) => AdBanner.fromJson(x))),
        coupons: json["coupons"] == null
            ? []
            : List<Coupon>.from(
                json["coupons"]!.map((x) => Coupon.fromJson(x))),
        categories: json["categories"] == null
            ? []
            : List<DashboardModelCategory>.from(json["categories"]!
                .map((x) => DashboardModelCategory.fromJson(x))),
        servicePackages: json["servicePackages"] == null
            ? []
            : List<ServicePackage>.from(json["servicePackages"]!
                .map((x) => ServicePackage.fromJson(x))),
        featuredServices: json["featuredServices"] == null
            ? []
            : List<FeaturedService>.from(json["featuredServices"]!
                .map((x) => FeaturedService.fromJson(x))),
        highestRatedProviders: json["highestRatedProviders"] == null
            ? []
            : List<HighestRatedProvider>.from(json["highestRatedProviders"]!
                .map((x) => HighestRatedProvider.fromJson(x))),
        blogs: json["blogs"] == null
            ? []
            : List<Blog>.from(json["blogs"]!.map((x) => Blog.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "banners": banners == null
            ? []
            : List<dynamic>.from(banners!.map((x) => x.toJson())),
        "coupons": coupons == null
            ? []
            : List<dynamic>.from(coupons!.map((x) => x.toJson())),
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "servicePackages": servicePackages == null
            ? []
            : List<dynamic>.from(servicePackages!.map((x) => x.toJson())),
        "featuredServices": featuredServices == null
            ? []
            : List<dynamic>.from(featuredServices!.map((x) => x.toJson())),
        "highestRatedProviders": highestRatedProviders == null
            ? []
            : List<dynamic>.from(highestRatedProviders!.map((x) => x.toJson())),
        "blogs": blogs == null
            ? []
            : List<dynamic>.from(blogs!.map((x) => x.toJson())),
      };
}

class AdBanner {
  int? id;
  String? type;
  int? relatedId;
  String? title;
  List<BannerMedia>? media;

  AdBanner({
    this.id,
    this.type,
    this.relatedId,
    this.title,
    this.media,
  });

  factory AdBanner.fromJson(Map<String, dynamic> json) => AdBanner(
        id: json["id"],
        type: json["type"],
        relatedId: json["related_id"],
        title: json["title"],
        media: json["media"] == null
            ? []
            : List<BannerMedia>.from(
                json["media"]!.map((x) => BannerMedia.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "related_id": relatedId,
        "title": title,
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
      };
}

class BannerMedia {
  int? id;
  String? originalUrl;

  BannerMedia({
    this.id,
    this.originalUrl,
  });

  factory BannerMedia.fromJson(Map<String, dynamic> json) => BannerMedia(
        id: json["id"],
        originalUrl: json["original_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "original_url": originalUrl,
      };
}

/* class Blog {
  int? id;
  String? title;
  String? description;
  dynamic createdAt;
  HighestRatedProvider? createdBy;
  List<Tag>? tags;
  List<BannerMedia>? media;
  dynamic hasSubCategories;

  Blog({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.createdBy,
    this.tags,
    this.media,
    this.hasSubCategories,
  });

  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        createdAt: json["created_at"],
        createdBy: json["created_by"] == null
            ? null
            : HighestRatedProvider.fromJson(json["created_by"]),
        tags: json["tags"] == null
            ? []
            : List<Tag>.from(json["tags"]!.map((x) => Tag.fromJson(x))),
        media: json["media"] == null
            ? []
            : List<BannerMedia>.from(
                json["media"]!.map((x) => BannerMedia.fromJson(x))),
        hasSubCategories: json["hasSubCategories"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "created_at": createdAt,
        "created_by": createdBy?.toJson(),
        "tags": tags == null
            ? []
            : List<dynamic>.from(tags!.map((x) => x.toJson())),
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "hasSubCategories": hasSubCategories,
      };
} */

/* class Blog {
  int? id;
  String? title;
  String? description;
  String? content;
  DateTime? createdAt;
  HighestRatedProvider? createdBy;
  List<Tag>? tags;
  List<BannerMedia>? media;
  Map<String, String>? categories;

  Blog({
    this.id,
    this.title,
    this.description,
    this.content,
    this.createdAt,
    this.createdBy,
    this.tags,
    this.media,
    this.categories,
  });

  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        content: json["content"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        createdBy: json["created_by"] == null
            ? null
            : HighestRatedProvider.fromJson(json["created_by"]),
        tags: json["tags"] == null
            ? []
            : List<Tag>.from(json["tags"]!.map((x) => Tag.fromJson(x))),
        media: json["media"] == null
            ? []
            : List<BannerMedia>.from(
                json["media"]!.map((x) => BannerMedia.fromJson(x))),
        categories: Map.from(json["categories"])
            .map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "content": content,
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy?.toJson(),
        "tags": tags == null
            ? []
            : List<dynamic>.from(tags!.map((x) => x.toJson())),
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "categories": Map.from(categories!)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
} */

class Blog {
  int? id;
  String? title;
  String? description;
  String? content;
  DateTime? createdAt;
  HighestRatedProvider? createdBy;
  List<Tag>? tags;
  List<BannerMedia>? media;
  List<BlogCategory>? categories;

  Blog({
    this.id,
    this.title,
    this.description,
    this.content,
    this.createdAt,
    this.createdBy,
    this.tags,
    this.media,
    this.categories,
  });

  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        content: json["content"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        createdBy: json["created_by"] == null
            ? null
            : HighestRatedProvider.fromJson(json["created_by"]),
        tags: json["tags"] == null
            ? []
            : List<Tag>.from(json["tags"]!.map((x) => Tag.fromJson(x))),
        media: json["media"] == null
            ? []
            : List<BannerMedia>.from(
                json["media"]!.map((x) => BannerMedia.fromJson(x))),
        categories: json["categories"] == null
            ? []
            : List<BlogCategory>.from(
                json["categories"]!.map((x) => BlogCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "content": content,
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy?.toJson(),
        "tags": tags == null
            ? []
            : List<dynamic>.from(tags!.map((x) => x.toJson())),
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
      };
}

class BlogCategory {
  int? id;
  String? title;

  BlogCategory({
    this.id,
    this.title,
  });

  factory BlogCategory.fromJson(Map<String, dynamic> json) => BlogCategory(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}

class Review {
  int? id;
  int? serviceId;
  dynamic servicemanId;
  int? consumerId;
  int? providerId;
  int? rating;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  List<dynamic>? media;
  HighestRatedProvider? consumer;

  Review({
    this.id,
    this.serviceId,
    this.servicemanId,
    this.consumerId,
    this.providerId,
    this.rating,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.media,
    this.consumer,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        serviceId: json["service_id"],
        servicemanId: json["serviceman_id"],
        consumerId: json["consumer_id"],
        providerId: json["provider_id"],
        rating: json["rating"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        media: json["media"] == null
            ? []
            : List<dynamic>.from(json["media"]!.map((x) => x)),
        consumer: json["consumer"] == null
            ? null
            : HighestRatedProvider.fromJson(json["consumer"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "serviceman_id": servicemanId,
        "consumer_id": consumerId,
        "provider_id": providerId,
        "rating": rating,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x)),
        "consumer": consumer?.toJson(),
      };
}

class HighestRatedProvider {
  int? id;
  HighestRatedProviderName? name;
  Slug? slug;
  Email? email;
  int? systemReserve;
  int? served;
  int? phone;
  int? code;
  dynamic providerId;
  int? status;
  int? isFeatured;
  int? isVerified;
  String? type;
  DateTime? emailVerifiedAt;
  String? fcmToken;
  String? experienceInterval;
  int? experienceDuration;
  dynamic description;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? companyId;
  String? locationCordinates;
  int? bookingsCount;
  int? reviewsCount;
  Role? role;
  dynamic? reviewRatings;
  List<int>? providerRatingList;
  List<int>? serviceManRatingList;
  PrimaryAddress? primaryAddress;
  int? totalDaysExperience;
  int? servicemanReviewRatings;
  List<HighestRatedProviderMedia>? media;
  Wallet? wallet;
  ProviderWallet? providerWallet;
  dynamic servicemanWallet;
  List<KnownLanguage>? knownLanguages;
  List<dynamic>? expertise;
  List<HighestRatedProviderZone>? zones;
  dynamic provider;
  List<Role>? roles;
  List<Review>? reviews;
  List<dynamic>? servicemanreviews;

  HighestRatedProvider({
    this.id,
    this.name,
    this.slug,
    this.email,
    this.systemReserve,
    this.served,
    this.phone,
    this.code,
    this.providerId,
    this.status,
    this.isFeatured,
    this.isVerified,
    this.type,
    this.emailVerifiedAt,
    this.fcmToken,
    this.experienceInterval,
    this.experienceDuration,
    this.description,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.companyId,
    this.locationCordinates,
    this.bookingsCount,
    this.reviewsCount,
    this.role,
    this.reviewRatings,
    this.providerRatingList,
    this.serviceManRatingList,
    this.primaryAddress,
    this.totalDaysExperience,
    this.servicemanReviewRatings,
    this.media,
    this.wallet,
    this.providerWallet,
    this.servicemanWallet,
    this.knownLanguages,
    this.expertise,
    this.zones,
    this.provider,
    this.roles,
    this.reviews,
    this.servicemanreviews,
  });

  factory HighestRatedProvider.fromJson(Map<String, dynamic> json) =>
      HighestRatedProvider(
        id: json["id"],
        name: highestRatedProviderNameValues.map[json["name"]]!,
        slug: slugValues.map[json["slug"]]!,
        email: emailValues.map[json["email"]]!,
        systemReserve: json["system_reserve"],
        served: json["served"],
        phone: json["phone"],
        code: json["code"],
        providerId: json["provider_id"],
        status: json["status"],
        isFeatured: json["is_featured"],
        isVerified: json["is_verified"],
        type: json["type"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        fcmToken: json["fcm_token"],
        experienceInterval: json["experience_interval"],
        experienceDuration: json["experience_duration"],
        description: json["description"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        companyId: json["company_id"],
        locationCordinates: json["location_cordinates"],
        bookingsCount: json["bookings_count"],
        reviewsCount: json["reviews_count"],
        role: json["role"] == null ? null : Role.fromJson(json["role"]),
        reviewRatings: json["review_ratings"],
        providerRatingList: json["provider_rating_list"] == null
            ? []
            : List<int>.from(json["provider_rating_list"]!.map((x) => x)),
        serviceManRatingList: json["service_man_rating_list"] == null
            ? []
            : List<int>.from(json["service_man_rating_list"]!.map((x) => x)),
        primaryAddress: json["primary_address"] != null
            ? PrimaryAddress.fromJson(json["primary_address"])
            : null,
        totalDaysExperience: json["total_days_experience"],
        servicemanReviewRatings: json["ServicemanReviewRatings"],
        media: json["media"] == null
            ? []
            : List<HighestRatedProviderMedia>.from(json["media"]!
                .map((x) => HighestRatedProviderMedia.fromJson(x))),
        wallet: json["wallet"] == null ? null : Wallet.fromJson(json["wallet"]),
        providerWallet: json["provider_wallet"] == null
            ? null
            : ProviderWallet.fromJson(json["provider_wallet"]),
        servicemanWallet: json["serviceman_wallet"],
        knownLanguages: json["known_languages"] == null
            ? []
            : List<KnownLanguage>.from(
                json["known_languages"]!.map((x) => KnownLanguage.fromJson(x))),
        expertise: json["expertise"] == null
            ? []
            : List<dynamic>.from(json["expertise"]!.map((x) => x)),
        zones: json["zones"] == null
            ? []
            : List<HighestRatedProviderZone>.from(json["zones"]!
                .map((x) => HighestRatedProviderZone.fromJson(x))),
        provider: json["provider"],
        roles: json["roles"] == null
            ? []
            : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
        reviews: json["reviews"] == null
            ? []
            : List<Review>.from(
                json["reviews"]!.map((x) => Review.fromJson(x))),
        servicemanreviews: json["servicemanreviews"] == null
            ? []
            : List<dynamic>.from(json["servicemanreviews"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": highestRatedProviderNameValues.reverse[name],
        "slug": slugValues.reverse[slug],
        "email": emailValues.reverse[email],
        "system_reserve": systemReserve,
        "served": served,
        "phone": phone,
        "code": code,
        "provider_id": providerId,
        "status": status,
        "is_featured": isFeatured,
        "is_verified": isVerified,
        "type": type,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "fcm_token": fcmToken,
        "experience_interval": experienceInterval,
        "experience_duration": experienceDuration,
        "description": description,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "company_id": companyId,
        "location_cordinates": locationCordinates,
        "bookings_count": bookingsCount,
        "reviews_count": reviewsCount,
        "role": role?.toJson(),
        "review_ratings": reviewRatings,
        "provider_rating_list": providerRatingList == null
            ? []
            : List<dynamic>.from(providerRatingList!.map((x) => x)),
        "service_man_rating_list": serviceManRatingList == null
            ? []
            : List<dynamic>.from(serviceManRatingList!.map((x) => x)),
        "primary_address": primaryAddress?.toJson(),
        "total_days_experience": totalDaysExperience,
        "ServicemanReviewRatings": servicemanReviewRatings,
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "wallet": wallet?.toJson(),
        "provider_wallet": providerWallet?.toJson(),
        "serviceman_wallet": servicemanWallet,
        "known_languages": knownLanguages == null
            ? []
            : List<dynamic>.from(knownLanguages!.map((x) => x.toJson())),
        "expertise": expertise == null
            ? []
            : List<dynamic>.from(expertise!.map((x) => x)),
        "zones": zones == null
            ? []
            : List<dynamic>.from(zones!.map((x) => x.toJson())),
        "provider": provider,
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
        "reviews": reviews == null
            ? []
            : List<dynamic>.from(reviews!.map((x) => x.toJson())),
        "servicemanreviews": servicemanreviews == null
            ? []
            : List<dynamic>.from(servicemanreviews!.map((x) => x)),
      };
}

enum Email {
  ADMIN_EXAMPLE_COM,
  CARLOS_RAMIREZ_EXAMPLE_COM,
  JACK_WILSON_EXAMPLE_COM,
  PROVIDER_EXAMPLE_COM,
  USER_EXAMPLE_COM
}

final emailValues = EnumValues({
  "admin@example.com": Email.ADMIN_EXAMPLE_COM,
  "carlos.ramirez@example.com": Email.CARLOS_RAMIREZ_EXAMPLE_COM,
  "jack.wilson@example.com": Email.JACK_WILSON_EXAMPLE_COM,
  "provider@example.com": Email.PROVIDER_EXAMPLE_COM,
  "user@example.com": Email.USER_EXAMPLE_COM
});

class KnownLanguage {
  String? key;
  int? id;
  KnownLanguagePivot? pivot;

  KnownLanguage({
    this.key,
    this.id,
    this.pivot,
  });

  factory KnownLanguage.fromJson(Map<String, dynamic> json) => KnownLanguage(
        key: json["key"],
        id: json["id"],
        pivot: json["pivot"] == null
            ? null
            : KnownLanguagePivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "id": id,
        "pivot": pivot?.toJson(),
      };
}

class KnownLanguagePivot {
  int? userId;
  int? languageId;

  KnownLanguagePivot({
    this.userId,
    this.languageId,
  });

  factory KnownLanguagePivot.fromJson(Map<String, dynamic> json) =>
      KnownLanguagePivot(
        userId: json["user_id"],
        languageId: json["language_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "language_id": languageId,
      };
}

class HighestRatedProviderMedia {
  int? id;
  PivotModelType? modelType;
  int? modelId;
  String? uuid;
  PurpleCollectionName? collectionName;
  String? name;
  String? fileName;
  MimeType? mimeType;
  Disk? disk;
  Disk? conversionsDisk;
  int? size;
  List<dynamic>? manipulations;
  dynamic customProperties;
  List<dynamic>? generatedConversions;
  List<dynamic>? responsiveImages;
  int? orderColumn;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? originalUrl;
  String? previewUrl;

  HighestRatedProviderMedia({
    this.id,
    this.modelType,
    this.modelId,
    this.uuid,
    this.collectionName,
    this.name,
    this.fileName,
    this.mimeType,
    this.disk,
    this.conversionsDisk,
    this.size,
    this.manipulations,
    this.customProperties,
    this.generatedConversions,
    this.responsiveImages,
    this.orderColumn,
    this.createdAt,
    this.updatedAt,
    this.originalUrl,
    this.previewUrl,
  });

  factory HighestRatedProviderMedia.fromJson(Map<String, dynamic> json) =>
      HighestRatedProviderMedia(
        id: json["id"],
        modelType: pivotModelTypeValues.map[json["model_type"]]!,
        modelId: json["model_id"],
        uuid: json["uuid"],
        collectionName:
            purpleCollectionNameValues.map[json["collection_name"]]!,
        name: json["name"],
        fileName: json["file_name"],
        mimeType: mimeTypeValues.map[json["mime_type"]]!,
        disk: diskValues.map[json["disk"]]!,
        conversionsDisk: diskValues.map[json["conversions_disk"]]!,
        size: json["size"],
        manipulations: json["manipulations"] == null
            ? []
            : List<dynamic>.from(json["manipulations"]!.map((x) => x)),
        customProperties: json["custom_properties"],
        generatedConversions: json["generated_conversions"] == null
            ? []
            : List<dynamic>.from(json["generated_conversions"]!.map((x) => x)),
        responsiveImages: json["responsive_images"] == null
            ? []
            : List<dynamic>.from(json["responsive_images"]!.map((x) => x)),
        orderColumn: json["order_column"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        originalUrl: json["original_url"],
        previewUrl: json["preview_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "model_type": pivotModelTypeValues.reverse[modelType],
        "model_id": modelId,
        "uuid": uuid,
        "collection_name": purpleCollectionNameValues.reverse[collectionName],
        "name": name,
        "file_name": fileName,
        "mime_type": mimeTypeValues.reverse[mimeType],
        "disk": diskValues.reverse[disk],
        "conversions_disk": diskValues.reverse[conversionsDisk],
        "size": size,
        "manipulations": manipulations == null
            ? []
            : List<dynamic>.from(manipulations!.map((x) => x)),
        "custom_properties": customProperties,
        "generated_conversions": generatedConversions == null
            ? []
            : List<dynamic>.from(generatedConversions!.map((x) => x)),
        "responsive_images": responsiveImages == null
            ? []
            : List<dynamic>.from(responsiveImages!.map((x) => x)),
        "order_column": orderColumn,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "original_url": originalUrl,
        "preview_url": previewUrl,
      };
}

enum PurpleCollectionName { IMAGE, PROFILE_IMAGE }

final purpleCollectionNameValues = EnumValues({
  "image": PurpleCollectionName.IMAGE,
  "profile_image": PurpleCollectionName.PROFILE_IMAGE
});

enum Disk { PUBLIC }

final diskValues = EnumValues({"public": Disk.PUBLIC});

class CustomPropertiesClass {
  Language? language;

  CustomPropertiesClass({
    this.language,
  });

  factory CustomPropertiesClass.fromJson(Map<String, dynamic> json) =>
      CustomPropertiesClass(
        language: languageValues.map[json["language"]]!,
      );

  Map<String, dynamic> toJson() => {
        "language": languageValues.reverse[language],
      };
}

enum Language { EN }

final languageValues = EnumValues({"en": Language.EN});

enum MimeType { IMAGE_JPEG, IMAGE_PNG }

final mimeTypeValues = EnumValues(
    {"image/jpeg": MimeType.IMAGE_JPEG, "image/png": MimeType.IMAGE_PNG});

enum PivotModelType { APP_MODELS_USER }

final pivotModelTypeValues =
    EnumValues({"App\\Models\\User": PivotModelType.APP_MODELS_USER});

enum HighestRatedProviderName {
  ADMIN,
  CARLOS_RAMIREZ,
  JACK_WILSON,
  ROBERT_DAVIS,
  THOMAS_TAYLOR
}

final highestRatedProviderNameValues = EnumValues({
  "admin": HighestRatedProviderName.ADMIN,
  "Carlos Ramirez": HighestRatedProviderName.CARLOS_RAMIREZ,
  "Jack Wilson": HighestRatedProviderName.JACK_WILSON,
  "Robert Davis": HighestRatedProviderName.ROBERT_DAVIS,
  "Thomas Taylor": HighestRatedProviderName.THOMAS_TAYLOR
});

class PrimaryAddress {
  int? id;
  int? userId;
  dynamic serviceId;
  int? isPrimary;
  String? latitude;
  String? longitude;
  String? area;
  String? postalCode;
  int? countryId;
  int? stateId;
  String? city;
  String? address;
  PrimaryAddressType? type;
  String? alternativeName;
  int? code;
  int? alternativePhone;
  int? status;
  dynamic companyId;
  dynamic availabilityRadius;
  Country? country;
  Country? state;

  PrimaryAddress({
    this.id,
    this.userId,
    this.serviceId,
    this.isPrimary,
    this.latitude,
    this.longitude,
    this.area,
    this.postalCode,
    this.countryId,
    this.stateId,
    this.city,
    this.address,
    this.type,
    this.alternativeName,
    this.code,
    this.alternativePhone,
    this.status,
    this.companyId,
    this.availabilityRadius,
    this.country,
    this.state,
  });

  factory PrimaryAddress.fromJson(Map<String, dynamic> json) => PrimaryAddress(
        id: json["id"],
        userId: json["user_id"],
        serviceId: json["service_id"],
        isPrimary: json["is_primary"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        area: json["area"],
        postalCode: json["postal_code"],
        countryId: json["country_id"],
        stateId: json["state_id"],
        city: json["city"],
        address: json["address"],
        type: primaryAddressTypeValues.map[json["type"]],
        alternativeName: json["alternative_name"],
        code: json["code"],
        alternativePhone: json["alternative_phone"],
        status: json["status"],
        companyId: json["company_id"],
        availabilityRadius: json["availability_radius"],
        country:
            json["country"] == null ? null : Country.fromJson(json["country"]),
        state: json["state"] == null ? null : Country.fromJson(json["state"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "service_id": serviceId,
        "is_primary": isPrimary,
        "latitude": latitude,
        "longitude": longitude,
        "area": area,
        "postal_code": postalCode,
        "country_id": countryId,
        "state_id": stateId,
        "city": city,
        "address": address,
        "type": primaryAddressTypeValues.reverse[type],
        "alternative_name": alternativeName,
        "code": code,
        "alternative_phone": alternativePhone,
        "status": status,
        "company_id": companyId,
        "availability_radius": availabilityRadius,
        "country": country?.toJson(),
        "state": state?.toJson(),
      };
}

class Country {
  int? id;
  String? name;

  Country({
    this.id,
    this.name,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

enum PrimaryAddressType { HOME, WORK }

final primaryAddressTypeValues = EnumValues(
    {"home": PrimaryAddressType.HOME, "work": PrimaryAddressType.WORK});

class ProviderWallet {
  int? id;
  int? providerId;
  double? balance;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  ProviderWallet({
    this.id,
    this.providerId,
    this.balance,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ProviderWallet.fromJson(Map<String, dynamic> json) => ProviderWallet(
        id: json["id"],
        providerId: json["provider_id"],
        balance: json["balance"]?.toDouble(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "provider_id": providerId,
        "balance": balance,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class Role {
  int? id;
  RoleName? name;
  GuardName? guardName;
  int? systemReserve;
  DateTime? createdAt;
  DateTime? updatedAt;
  RolePivot? pivot;

  Role({
    this.id,
    this.name,
    this.guardName,
    this.systemReserve,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: roleNameValues.map[json["name"]]!,
        guardName: guardNameValues.map[json["guard_name"]]!,
        systemReserve: json["system_reserve"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        pivot: json["pivot"] == null ? null : RolePivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": roleNameValues.reverse[name],
        "guard_name": guardNameValues.reverse[guardName],
        "system_reserve": systemReserve,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "pivot": pivot?.toJson(),
      };
}

enum GuardName { WEB }

final guardNameValues = EnumValues({"web": GuardName.WEB});

enum RoleName { ADMIN, PROVIDER, USER }

final roleNameValues = EnumValues({
  "admin": RoleName.ADMIN,
  "provider": RoleName.PROVIDER,
  "user": RoleName.USER
});

class RolePivot {
  PivotModelType? modelType;
  int? modelId;
  int? roleId;

  RolePivot({
    this.modelType,
    this.modelId,
    this.roleId,
  });

  factory RolePivot.fromJson(Map<String, dynamic> json) => RolePivot(
        modelType: pivotModelTypeValues.map[json["model_type"]]!,
        modelId: json["model_id"],
        roleId: json["role_id"],
      );

  Map<String, dynamic> toJson() => {
        "model_type": pivotModelTypeValues.reverse[modelType],
        "model_id": modelId,
        "role_id": roleId,
      };
}

enum Slug { ADMIN, CARLOS_RAMIREZ, JACK_WILSON, ROBERT_DAVIS, THOMAS_TAYLOAR }

final slugValues = EnumValues({
  "admin": Slug.ADMIN,
  "carlos-ramirez": Slug.CARLOS_RAMIREZ,
  "jack-wilson": Slug.JACK_WILSON,
  "robert-davis": Slug.ROBERT_DAVIS,
  "thomas-tayloar": Slug.THOMAS_TAYLOAR
});

class Wallet {
  int? id;
  int? consumerId;
  double? balance;

  Wallet({
    this.id,
    this.consumerId,
    this.balance,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        id: json["id"],
        consumerId: json["consumer_id"],
        balance: json["balance"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "consumer_id": consumerId,
        "balance": balance,
      };
}

class HighestRatedProviderZone {
  int? id;
  ZoneName? name;
  PlacePoints? placePoints;
  List<Location>? locations;
  String? status;
  int? createdById;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  PurplePivot? pivot;

  HighestRatedProviderZone({
    this.id,
    this.name,
    this.placePoints,
    this.locations,
    this.status,
    this.createdById,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.pivot,
  });

  factory HighestRatedProviderZone.fromJson(Map<String, dynamic> json) =>
      HighestRatedProviderZone(
        id: json["id"],
        name: zoneNameValues.map[json["name"]]!,
        placePoints: json["place_points"] == null
            ? null
            : PlacePoints.fromJson(json["place_points"]),
        locations: json["locations"] == null
            ? []
            : List<Location>.from(
                json["locations"]!.map((x) => Location.fromJson(x))),
        status: json["status"],
        createdById: json["created_by_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        pivot:
            json["pivot"] == null ? null : PurplePivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": zoneNameValues.reverse[name],
        "place_points": placePoints?.toJson(),
        "locations": locations == null
            ? []
            : List<dynamic>.from(locations!.map((x) => x.toJson())),
        "status": status,
        "created_by_id": createdById,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "pivot": pivot?.toJson(),
      };
}

class Location {
  double? lat;
  double? lng;

  Location({
    this.lat,
    this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

enum ZoneName { ALL, AUSTRALIA, CANADA }

final zoneNameValues = EnumValues({
  "All": ZoneName.ALL,
  "Australia": ZoneName.AUSTRALIA,
  "Canada": ZoneName.CANADA
});

class PurplePivot {
  int? providerId;
  int? zoneId;

  PurplePivot({
    this.providerId,
    this.zoneId,
  });

  factory PurplePivot.fromJson(Map<String, dynamic> json) => PurplePivot(
        providerId: json["provider_id"],
        zoneId: json["zone_id"],
      );

  Map<String, dynamic> toJson() => {
        "provider_id": providerId,
        "zone_id": zoneId,
      };
}

class PlacePoints {
  PlacePointsType? type;
  List<List<List<double>>>? coordinates;

  PlacePoints({
    this.type,
    this.coordinates,
  });

  factory PlacePoints.fromJson(Map<String, dynamic> json) => PlacePoints(
        type: placePointsTypeValues.map[json["type"]]!,
        coordinates: json["coordinates"] == null
            ? []
            : List<List<List<double>>>.from(json["coordinates"]!.map((x) =>
                List<List<double>>.from(x.map(
                    (x) => List<double>.from(x.map((x) => x?.toDouble())))))),
      );

  Map<String, dynamic> toJson() => {
        "type": placePointsTypeValues.reverse[type],
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => List<dynamic>.from(
                x.map((x) => List<dynamic>.from(x.map((x) => x)))))),
      };
}

enum PlacePointsType { POLYGON }

final placePointsTypeValues = EnumValues({"Polygon": PlacePointsType.POLYGON});

class Tag {
  int? id;
  String? name;
  String? slug;
  TagType? type;
  String? description;
  int? createdById;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  TagPivot? pivot;

  Tag({
    this.id,
    this.name,
    this.slug,
    this.type,
    this.description,
    this.createdById,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.pivot,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        type: tagTypeValues.map[json["type"]]!,
        description: json["description"],
        createdById: json["created_by_id"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        pivot: json["pivot"] == null ? null : TagPivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "type": tagTypeValues.reverse[type],
        "description": description,
        "created_by_id": createdById,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "pivot": pivot?.toJson(),
      };
}

class TagPivot {
  int? blogId;
  int? tagId;

  TagPivot({
    this.blogId,
    this.tagId,
  });

  factory TagPivot.fromJson(Map<String, dynamic> json) => TagPivot(
        blogId: json["blog_id"],
        tagId: json["tag_id"],
      );

  Map<String, dynamic> toJson() => {
        "blog_id": blogId,
        "tag_id": tagId,
      };
}

enum TagType { BLOG }

final tagTypeValues = EnumValues({"blog": TagType.BLOG});

class DashboardModelCategory {
  int? id;
  String? title;
  dynamic parentId;
  List<BannerMedia>? media;
  List<HasSubCategoryElement>? hasSubCategories;

  DashboardModelCategory({
    this.id,
    this.title,
    this.parentId,
    this.media,
    this.hasSubCategories,
  });

  factory DashboardModelCategory.fromJson(Map<String, dynamic> json) =>
      DashboardModelCategory(
        id: json["id"],
        title: json["title"],
        parentId: json["parent_id"],
        media: json["media"] == null
            ? []
            : List<BannerMedia>.from(
                json["media"]!.map((x) => BannerMedia.fromJson(x))),
        hasSubCategories: json["hasSubCategories"] == null
            ? []
            : List<HasSubCategoryElement>.from(json["hasSubCategories"]!
                .map((x) => HasSubCategoryElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "parent_id": parentId,
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "hasSubCategories": hasSubCategories == null
            ? []
            : List<dynamic>.from(hasSubCategories!.map((x) => x.toJson())),
      };
}

class HasSubCategoryElement {
  int? id;
  String? title;
  String? slug;
  String? description;
  int? parentId;
  dynamic metaTitle;
  dynamic metaDescription;
  int? commission;
  int? status;
  int? isFeatured;
  CategoryType? categoryType;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? servicesCount;
  List<HasSubCategoryMedia>? media;
  List<HasSubCategoryZone>? zones;
  HasSubCategoryPivot? pivot;

  HasSubCategoryElement({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.parentId,
    this.metaTitle,
    this.metaDescription,
    this.commission,
    this.status,
    this.isFeatured,
    this.categoryType,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.servicesCount,
    this.media,
    this.zones,
    this.pivot,
  });

  factory HasSubCategoryElement.fromJson(Map<String, dynamic> json) =>
      HasSubCategoryElement(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        description: json["description"],
        parentId: json["parent_id"],
        metaTitle: json["meta_title"],
        metaDescription: json["meta_description"],
        commission: json["commission"],
        status: json["status"],
        isFeatured: json["is_featured"],
        categoryType: categoryTypeValues.map[json["category_type"]]!,
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        servicesCount: json["services_count"],
        media: json["media"] == null
            ? []
            : List<HasSubCategoryMedia>.from(
                json["media"]!.map((x) => HasSubCategoryMedia.fromJson(x))),
        zones: json["zones"] == null
            ? []
            : List<HasSubCategoryZone>.from(
                json["zones"]!.map((x) => HasSubCategoryZone.fromJson(x))),
        pivot: json["pivot"] == null
            ? null
            : HasSubCategoryPivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "description": description,
        "parent_id": parentId,
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "commission": commission,
        "status": status,
        "is_featured": isFeatured,
        "category_type": categoryTypeValues.reverse[categoryType],
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "services_count": servicesCount,
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "zones": zones == null
            ? []
            : List<dynamic>.from(zones!.map((x) => x.toJson())),
        "pivot": pivot?.toJson(),
      };
}

enum CategoryType { SERVICE }

final categoryTypeValues = EnumValues({"service": CategoryType.SERVICE});

class HasSubCategoryMedia {
  int? id;
  PurpleModelType? modelType;
  int? modelId;
  String? uuid;
  FluffyCollectionName? collectionName;
  String? name;
  String? fileName;
  MimeType? mimeType;
  Disk? disk;
  Disk? conversionsDisk;
  int? size;
  List<dynamic>? manipulations;
  CustomPropertiesClass? customProperties;
  List<dynamic>? generatedConversions;
  List<dynamic>? responsiveImages;
  int? orderColumn;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? originalUrl;
  String? previewUrl;

  HasSubCategoryMedia({
    this.id,
    this.modelType,
    this.modelId,
    this.uuid,
    this.collectionName,
    this.name,
    this.fileName,
    this.mimeType,
    this.disk,
    this.conversionsDisk,
    this.size,
    this.manipulations,
    this.customProperties,
    this.generatedConversions,
    this.responsiveImages,
    this.orderColumn,
    this.createdAt,
    this.updatedAt,
    this.originalUrl,
    this.previewUrl,
  });

  factory HasSubCategoryMedia.fromJson(Map<String, dynamic> json) =>
      HasSubCategoryMedia(
        id: json["id"],
        modelType: purpleModelTypeValues.map[json["model_type"]]!,
        modelId: json["model_id"],
        uuid: json["uuid"],
        collectionName:
            fluffyCollectionNameValues.map[json["collection_name"]]!,
        name: json["name"],
        fileName: json["file_name"],
        mimeType: mimeTypeValues.map[json["mime_type"]]!,
        disk: diskValues.map[json["disk"]]!,
        conversionsDisk: diskValues.map[json["conversions_disk"]]!,
        size: json["size"],
        manipulations: json["manipulations"] == null
            ? []
            : List<dynamic>.from(json["manipulations"]!.map((x) => x)),
        customProperties: json["custom_properties"] == null
            ? null
            : CustomPropertiesClass.fromJson(json["custom_properties"]),
        generatedConversions: json["generated_conversions"] == null
            ? []
            : List<dynamic>.from(json["generated_conversions"]!.map((x) => x)),
        responsiveImages: json["responsive_images"] == null
            ? []
            : List<dynamic>.from(json["responsive_images"]!.map((x) => x)),
        orderColumn: json["order_column"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        originalUrl: json["original_url"],
        previewUrl: json["preview_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "model_type": purpleModelTypeValues.reverse[modelType],
        "model_id": modelId,
        "uuid": uuid,
        "collection_name": fluffyCollectionNameValues.reverse[collectionName],
        "name": name,
        "file_name": fileName,
        "mime_type": mimeTypeValues.reverse[mimeType],
        "disk": diskValues.reverse[disk],
        "conversions_disk": diskValues.reverse[conversionsDisk],
        "size": size,
        "manipulations": manipulations == null
            ? []
            : List<dynamic>.from(manipulations!.map((x) => x)),
        "custom_properties": customProperties?.toJson(),
        "generated_conversions": generatedConversions == null
            ? []
            : List<dynamic>.from(generatedConversions!.map((x) => x)),
        "responsive_images": responsiveImages == null
            ? []
            : List<dynamic>.from(responsiveImages!.map((x) => x)),
        "order_column": orderColumn,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "original_url": originalUrl,
        "preview_url": previewUrl,
      };
}

enum FluffyCollectionName { IMAGE, THUMBNAIL, WEB_IMAGES, WEB_THUMBNAIL }

final fluffyCollectionNameValues = EnumValues({
  "image": FluffyCollectionName.IMAGE,
  "thumbnail": FluffyCollectionName.THUMBNAIL,
  "web_images": FluffyCollectionName.WEB_IMAGES,
  "web_thumbnail": FluffyCollectionName.WEB_THUMBNAIL
});

enum PurpleModelType { APP_MODELS_CATEGORY, APP_MODELS_SERVICE }

final purpleModelTypeValues = EnumValues({
  "App\\Models\\Category": PurpleModelType.APP_MODELS_CATEGORY,
  "App\\Models\\Service": PurpleModelType.APP_MODELS_SERVICE
});

class HasSubCategoryPivot {
  int? serviceId;
  int? categoryId;

  HasSubCategoryPivot({
    this.serviceId,
    this.categoryId,
  });

  factory HasSubCategoryPivot.fromJson(Map<String, dynamic> json) =>
      HasSubCategoryPivot(
        serviceId: json["service_id"],
        categoryId: json["category_id"],
      );

  Map<String, dynamic> toJson() => {
        "service_id": serviceId,
        "category_id": categoryId,
      };
}

class HasSubCategoryZone {
  int? id;
  ZoneName? name;
  PlacePoints? placePoints;
  List<Location>? locations;
  String? status;
  int? createdById;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  FluffyPivot? pivot;

  HasSubCategoryZone({
    this.id,
    this.name,
    this.placePoints,
    this.locations,
    this.status,
    this.createdById,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.pivot,
  });

  factory HasSubCategoryZone.fromJson(Map<String, dynamic> json) =>
      HasSubCategoryZone(
        id: json["id"],
        name: zoneNameValues.map[json["name"]]!,
        placePoints: json["place_points"] == null
            ? null
            : PlacePoints.fromJson(json["place_points"]),
        locations: json["locations"] == null
            ? []
            : List<Location>.from(
                json["locations"]!.map((x) => Location.fromJson(x))),
        status: json["status"],
        createdById: json["created_by_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        pivot:
            json["pivot"] == null ? null : FluffyPivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": zoneNameValues.reverse[name],
        "place_points": placePoints?.toJson(),
        "locations": locations == null
            ? []
            : List<dynamic>.from(locations!.map((x) => x.toJson())),
        "status": status,
        "created_by_id": createdById,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "pivot": pivot?.toJson(),
      };
}

class FluffyPivot {
  int? categoryId;
  int? zoneId;

  FluffyPivot({
    this.categoryId,
    this.zoneId,
  });

  factory FluffyPivot.fromJson(Map<String, dynamic> json) => FluffyPivot(
        categoryId: json["category_id"],
        zoneId: json["zone_id"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "zone_id": zoneId,
      };
}

class Coupon {
  int? id;
  String? code;
  int? minSpend;
  String? type;
  int? amount;

  Coupon({
    this.id,
    this.code,
    this.minSpend,
    this.type,
    this.amount,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json["id"],
        code: json["code"],
        minSpend: json["min_spend"],
        type: json["type"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "min_spend": minSpend,
        "type": type,
        "amount": amount,
      };
}

class FeaturedService {
  int? id;
  String? duration;
  DurationUnit? durationUnit;
  int? requiredServicemen;
  String? title;
  int? discount;
  int? price;
  double? serviceRate;
  String? description;
  List<FeaturedServiceMedia>? media;

  FeaturedService({
    this.id,
    this.duration,
    this.durationUnit,
    this.requiredServicemen,
    this.title,
    this.discount,
    this.price,
    this.serviceRate,
    this.description,
    this.media,
  });

  factory FeaturedService.fromJson(Map<String, dynamic> json) =>
      FeaturedService(
        id: json["id"],
        duration: json["duration"],
        durationUnit: durationUnitValues.map[json["duration_unit"]]!,
        requiredServicemen: json["required_servicemen"],
        title: json["title"],
        discount: json["discount"],
        price: json["price"],
        serviceRate: json["service_rate"]?.toDouble(),
        description: json["description"],
        media: json["media"] == null
            ? []
            : List<FeaturedServiceMedia>.from(
                json["media"]!.map((x) => FeaturedServiceMedia.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "duration": duration,
        "duration_unit": durationUnitValues.reverse[durationUnit],
        "required_servicemen": requiredServicemen,
        "title": title,
        "discount": discount,
        "price": price,
        "service_rate": serviceRate,
        "description": description,
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
      };
}

enum DurationUnit { HOURS, MINUTES }

final durationUnitValues =
    EnumValues({"hours": DurationUnit.HOURS, "minutes": DurationUnit.MINUTES});

class FeaturedServiceMedia {
  int? id;
  FluffyCollectionName? collectionName;
  String? originalUrl;

  FeaturedServiceMedia({
    this.id,
    this.collectionName,
    this.originalUrl,
  });

  factory FeaturedServiceMedia.fromJson(Map<String, dynamic> json) =>
      FeaturedServiceMedia(
        id: json["id"],
        collectionName:
            fluffyCollectionNameValues.map[json["collection_name"]]!,
        originalUrl: json["original_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "collection_name": fluffyCollectionNameValues.reverse[collectionName],
        "original_url": originalUrl,
      };
}

class ServicePackage {
  int? id;
  String? hexaCode;
  String? title;
  int? price;
  String? description;
  HighestRatedProvider? user;
  List<Service>? services;
  List<FeaturedServiceMedia>? media;

  ServicePackage({
    this.id,
    this.hexaCode,
    this.title,
    this.price,
    this.description,
    this.user,
    this.services,
    this.media,
  });

  factory ServicePackage.fromJson(Map<String, dynamic> json) => ServicePackage(
        id: json["id"],
        hexaCode: json["hexa_code"],
        title: json["title"],
        price: json["price"],
        description: json["description"],
        user: json["user"] == null
            ? null
            : HighestRatedProvider.fromJson(json["user"]),
        services: json["services"] == null
            ? []
            : List<Service>.from(
                json["services"]!.map((x) => Service.fromJson(x))),
        media: json["media"] == null
            ? []
            : List<FeaturedServiceMedia>.from(
                json["media"]!.map((x) => FeaturedServiceMedia.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "hexa_code": hexaCode,
        "title": title,
        "price": price,
        "description": description,
        "user": user?.toJson(),
        "services": services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
      };
}

class Service {
  int? id;
  String? title;
  int? price;
  int? status;
  String? duration;
  DurationUnit? durationUnit;
  double? serviceRate;
  int? discount;
  int? perServicemanCommission;
  String? description;
  String? content;
  dynamic specialityDescription;
  int? userId;
  dynamic parentId;
  ServiceType? type;
  int? isFeatured;
  int? requiredServicemen;
  dynamic metaTitle;
  String? slug;
  dynamic metaDescription;
  int? createdById;
  int? isRandomRelatedServices;
  int? taxId;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic destinationLocation;
  int? bookingsCount;
  int? reviewsCount;
  List<int>? reviewRatings;
  int? ratingCount;
  String? webImgThumbUrl;
  List<String>? webImgGalleriesUrl;
  int? highestCommission;
  ServicePivot? pivot;
  List<HasSubCategoryElement>? categories;
  List<HasSubCategoryMedia>? media;
  List<Review>? reviews;

  Service({
    this.id,
    this.title,
    this.price,
    this.status,
    this.duration,
    this.durationUnit,
    this.serviceRate,
    this.discount,
    this.perServicemanCommission,
    this.description,
    this.content,
    this.specialityDescription,
    this.userId,
    this.parentId,
    this.type,
    this.isFeatured,
    this.requiredServicemen,
    this.metaTitle,
    this.slug,
    this.metaDescription,
    this.createdById,
    this.isRandomRelatedServices,
    this.taxId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.destinationLocation,
    this.bookingsCount,
    this.reviewsCount,
    this.reviewRatings,
    this.ratingCount,
    this.webImgThumbUrl,
    this.webImgGalleriesUrl,
    this.highestCommission,
    this.pivot,
    this.categories,
    this.media,
    this.reviews,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        status: json["status"],
        duration: json["duration"],
        durationUnit: durationUnitValues.map[json["duration_unit"]]!,
        serviceRate: json["service_rate"]?.toDouble(),
        discount: json["discount"],
        perServicemanCommission: json["per_serviceman_commission"],
        description: json["description"],
        content: json["content"],
        specialityDescription: json["speciality_description"],
        userId: json["user_id"],
        parentId: json["parent_id"],
        type: serviceTypeValues.map[json["type"]]!,
        isFeatured: json["is_featured"],
        requiredServicemen: json["required_servicemen"],
        metaTitle: json["meta_title"],
        slug: json["slug"],
        metaDescription: json["meta_description"],
        createdById: json["created_by_id"],
        isRandomRelatedServices: json["is_random_related_services"],
        taxId: json["tax_id"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        destinationLocation: json["destination_location"],
        bookingsCount: json["bookings_count"],
        reviewsCount: json["reviews_count"],
        reviewRatings: json["review_ratings"] == null
            ? []
            : List<int>.from(json["review_ratings"]!.map((x) => x)),
        ratingCount: json["rating_count"],
        webImgThumbUrl: json["web_img_thumb_url"],
        webImgGalleriesUrl: json["web_img_galleries_url"] == null
            ? []
            : List<String>.from(json["web_img_galleries_url"]!.map((x) => x)),
        highestCommission: json["highest_commission"],
        pivot:
            json["pivot"] == null ? null : ServicePivot.fromJson(json["pivot"]),
        categories: json["categories"] == null
            ? []
            : List<HasSubCategoryElement>.from(json["categories"]!
                .map((x) => HasSubCategoryElement.fromJson(x))),
        media: json["media"] == null
            ? []
            : List<HasSubCategoryMedia>.from(
                json["media"]!.map((x) => HasSubCategoryMedia.fromJson(x))),
        reviews: json["reviews"] == null
            ? []
            : List<Review>.from(
                json["reviews"]!.map((x) => Review.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "status": status,
        "duration": duration,
        "duration_unit": durationUnitValues.reverse[durationUnit],
        "service_rate": serviceRate,
        "discount": discount,
        "per_serviceman_commission": perServicemanCommission,
        "description": description,
        "content": content,
        "speciality_description": specialityDescription,
        "user_id": userId,
        "parent_id": parentId,
        "type": serviceTypeValues.reverse[type],
        "is_featured": isFeatured,
        "required_servicemen": requiredServicemen,
        "meta_title": metaTitle,
        "slug": slug,
        "meta_description": metaDescription,
        "created_by_id": createdById,
        "is_random_related_services": isRandomRelatedServices,
        "tax_id": taxId,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "destination_location": destinationLocation,
        "bookings_count": bookingsCount,
        "reviews_count": reviewsCount,
        "review_ratings": reviewRatings == null
            ? []
            : List<dynamic>.from(reviewRatings!.map((x) => x)),
        "rating_count": ratingCount,
        "web_img_thumb_url": webImgThumbUrl,
        "web_img_galleries_url": webImgGalleriesUrl == null
            ? []
            : List<dynamic>.from(webImgGalleriesUrl!.map((x) => x)),
        "highest_commission": highestCommission,
        "pivot": pivot?.toJson(),
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "reviews": reviews == null
            ? []
            : List<dynamic>.from(reviews!.map((x) => x.toJson())),
      };
}

class ServicePivot {
  int? servicePackageId;
  int? serviceId;

  ServicePivot({
    this.servicePackageId,
    this.serviceId,
  });

  factory ServicePivot.fromJson(Map<String, dynamic> json) => ServicePivot(
        servicePackageId: json["service_package_id"],
        serviceId: json["service_id"],
      );

  Map<String, dynamic> toJson() => {
        "service_package_id": servicePackageId,
        "service_id": serviceId,
      };
}

enum ServiceType { FIXED }

final serviceTypeValues = EnumValues({"fixed": ServiceType.FIXED});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
