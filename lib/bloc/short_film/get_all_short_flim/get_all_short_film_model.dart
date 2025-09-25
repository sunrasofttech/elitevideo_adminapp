// To parse this JSON data, do
//
//     final getAllShortFilmModel = getAllShortFilmModelFromJson(jsonString);

import 'dart:convert';

GetAllShortFilmModel getAllShortFilmModelFromJson(String str) => GetAllShortFilmModel.fromJson(json.decode(str));

String getAllShortFilmModelToJson(GetAllShortFilmModel data) => json.encode(data.toJson());

class GetAllShortFilmModel {
  bool? status;
  String? message;
  List<Datum>? data;
  Pagination? pagination;

  GetAllShortFilmModel({
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  factory GetAllShortFilmModel.fromJson(Map<String, dynamic> json) => GetAllShortFilmModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class ShortfilmAd {
  String? id;
  String? shortfilmId;
  String? videoAdId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Datum? shortfilm;
  VideoAd? videoAd;

  ShortfilmAd({
    this.id,
    this.shortfilmId,
    this.videoAdId,
    this.createdAt,
    this.updatedAt,
    this.shortfilm,
    this.videoAd,
  });

  factory ShortfilmAd.fromJson(Map<String, dynamic> json) => ShortfilmAd(
        id: json["id"],
        shortfilmId: json["shortfilm_id"],
        videoAdId: json["video_ad_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        shortfilm: json["shortfilm"] == null ? null : Datum.fromJson(json["shortfilm"]),
        videoAd: json["video_ad"] == null ? null : VideoAd.fromJson(json["video_ad"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shortfilm_id": shortfilmId,
        "video_ad_id": videoAdId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "shortfilm": shortfilm?.toJson(),
        "video_ad": videoAd?.toJson(),
      };
}

class Datum {
  String? id;
  String? shortFilmTitle;
  bool? status;
  String? coverImg;
  String? posterImg;
  String? movieLanguage;
  String? genreId;
  String? movieCategory;
  String? videoLink;
  String? shortVideo;
  bool? quality;
  bool? showSubscription;
  bool? subtitle;
  String? description;
  String? movieTime;
  String? movieRentPrice;
  bool? isMovieOnRent;
  bool? isHighlighted;
  bool? isWatchlist;
  dynamic rentedTimeDays;
  int? viewCount;
  String? releasedBy;
  String? releasedDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  Category? language;
  Category? genre;
  Category? category;
  List<dynamic>? ratings;
  dynamic averageRating;
  int? totalRatings;
  List<ShortfilmAd>? shortfilmAds;

  Datum({
    this.id,
    this.shortFilmTitle,
    this.status,
    this.coverImg,
    this.posterImg,
    this.movieLanguage,
    this.genreId,
    this.movieCategory,
    this.videoLink,
    this.shortVideo,
    this.quality,
    this.subtitle,
    this.description,
    this.movieTime,
    this.showSubscription,
    this.movieRentPrice,
    this.isMovieOnRent,
    this.rentedTimeDays,
    this.isHighlighted,
    this.isWatchlist,
    this.viewCount,
    this.releasedBy,
    this.releasedDate,
    this.createdAt,
    this.updatedAt,
    this.language,
    this.genre,
    this.category,
    this.ratings,
    this.averageRating,
    this.totalRatings,
    this.shortfilmAds,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        shortFilmTitle: json["short_film_title"],
        status: json["status"],
        coverImg: json["cover_img"],
        posterImg: json["poster_img"],
        movieLanguage: json["movie_language"],
        genreId: json["genre_id"],
        movieCategory: json["movie_category"],
        videoLink: json["video_link"],
        shortVideo: json["short_video"],
        quality: json["quality"],
        subtitle: json["subtitle"],
        description: json["description"],
        movieTime: json["movie_time"],
        movieRentPrice: json["movie_rent_price"],
        isMovieOnRent: json["is_movie_on_rent"],
        showSubscription: json["show_subscription"],
        isHighlighted: json["is_highlighted"],
        isWatchlist: json["is_watchlist"],
        viewCount: json["view_count"],
        releasedBy: json["released_by"],
        rentedTimeDays: json["rented_time_days"],
        releasedDate: json["released_date"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        language: json["language"] == null ? null : Category.fromJson(json["language"]),
        genre: json["genre"] == null ? null : Category.fromJson(json["genre"]),
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        ratings: json["ratings"] == null ? [] : List<dynamic>.from(json["ratings"]!.map((x) => x)),
        averageRating: json["average_rating"],
        totalRatings: json["total_ratings"],
        shortfilmAds: json["shortfilm_ads"] == null
            ? []
            : List<ShortfilmAd>.from(json["shortfilm_ads"]!.map((x) => ShortfilmAd.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "short_film_title": shortFilmTitle,
        "status": status,
        "cover_img": coverImg,
        "poster_img": posterImg,
        "movie_language": movieLanguage,
        "genre_id": genreId,
        "movie_category": movieCategory,
        "video_link": videoLink,
        "short_video": shortVideo,
        "quality": quality,
        "subtitle": subtitle,
        "description": description,
        "movie_time": movieTime,
        "show_subscription": showSubscription,
        "movie_rent_price": movieRentPrice,
        "is_movie_on_rent": isMovieOnRent,
        "is_highlighted": isHighlighted,
        "is_watchlist": isWatchlist,
        "view_count": viewCount,
        "released_by": releasedBy,
        "rented_time_days": rentedTimeDays,
        "released_date": releasedDate,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "language": language?.toJson(),
        "genre": genre?.toJson(),
        "category": category?.toJson(),
        "ratings": ratings == null ? [] : List<dynamic>.from(ratings!.map((x) => x)),
        "average_rating": averageRating,
        "total_ratings": totalRatings,
        "shortfilm_ads": shortfilmAds == null ? [] : List<dynamic>.from(shortfilmAds!.map((x) => x.toJson())),
      };
}

class VideoAd {
  String? id;
  String? adVideo;
  dynamic adUrl;
  String? videoTime;
  String? skipTime;
  String? title;
  DateTime? createdAt;
  DateTime? updatedAt;

  VideoAd({
    this.id,
    this.adVideo,
    this.adUrl,
    this.videoTime,
    this.skipTime,
    this.title,
    this.createdAt,
    this.updatedAt,
  });

  factory VideoAd.fromJson(Map<String, dynamic> json) => VideoAd(
        id: json["id"],
        adVideo: json["ad_video"],
        adUrl: json["ad_url"],
        videoTime: json["video_time"],
        skipTime: json["skip_time"],
        title: json["title"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ad_video": adVideo,
        "ad_url": adUrl,
        "video_time": videoTime,
        "skip_time": skipTime,
        "title": title,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class Category {
  String? id;
  String? name;
  bool? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? coverImg;

  Category({
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.coverImg,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        coverImg: json["cover_img"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "cover_img": coverImg,
      };
}

class Pagination {
  int? totalItems;
  int? currentPage;
  int? totalPages;

  Pagination({
    this.totalItems,
    this.currentPage,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalItems: json["totalItems"],
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "currentPage": currentPage,
        "totalPages": totalPages,
      };
}
