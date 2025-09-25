// To parse this JSON data, do
//
//     final getAllMoviesModel = getAllMoviesModelFromJson(jsonString);

import 'dart:convert';

GetAllMoviesModel getAllMoviesModelFromJson(String str) => GetAllMoviesModel.fromJson(json.decode(str));

String getAllMoviesModelToJson(GetAllMoviesModel data) => json.encode(data.toJson());

class GetAllMoviesModel {
  bool? status;
  String? message;
  Data? data;

  GetAllMoviesModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetAllMoviesModel.fromJson(Map<String, dynamic> json) => GetAllMoviesModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  int? total;
  int? page;
  int? totalPages;
  List<Movie>? movies;

  Data({
    this.total,
    this.page,
    this.totalPages,
    this.movies,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["total"],
        page: json["page"],
        totalPages: json["totalPages"],
        movies: json["movies"] == null ? [] : List<Movie>.from(json["movies"]!.map((x) => Movie.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "totalPages": totalPages,
        "movies": movies == null ? [] : List<dynamic>.from(movies!.map((x) => x.toJson())),
      };
}

class Movie {
  String? id;
  String? movieName;
  bool? status;
  String? coverImg;
  String? posterImg;
  String? movieLanguage;
  String? genreId;
  String? movieCategory;
  int? reportCount;
  String? videoLink;
  String? movieVideo;
  String? trailorVideoLink;
  String? trailorVideo;
  bool? quality;
  bool? subtitle;
  String? description;
  String? movieTime;
  dynamic position;
  String? movieRentPrice;
  bool? isMovieOnRent;
  dynamic rentedTimeDays;
  bool? showSubscription;
  bool? isHighlighted;
  bool? isWatchlist;
  int? viewCount;
  String? releasedBy;
  String? releasedDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  Category? language;
  Category? genre;
  Category? category;
  List<dynamic>? ratings;
  List<CastCrew>? castCrew;
  List<dynamic>? movieAd;
  dynamic averageRating;
  int? totalRatings;
  List<dynamic>? recommendedMovies;

  Movie({
    this.id,
    this.movieName,
    this.status,
    this.coverImg,
    this.posterImg,
    this.movieLanguage,
    this.genreId,
    this.movieCategory,
    this.reportCount,
    this.videoLink,
    this.movieVideo,
    this.position,
    this.trailorVideoLink,
    this.trailorVideo,
    this.quality,
    this.subtitle,
    this.description,
    this.movieTime,
    this.movieRentPrice,
    this.isMovieOnRent,
    this.rentedTimeDays,
    this.isHighlighted,
    this.isWatchlist,
    this.viewCount,
    this.releasedBy,
    this.releasedDate,
    this.createdAt,
    this.showSubscription,
    this.updatedAt,
    this.language,
    this.genre,
    this.category,
    this.ratings,
    this.castCrew,
    this.movieAd,
    this.averageRating,
    this.totalRatings,
    this.recommendedMovies,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json["id"],
        movieName: json["movie_name"],
        status: json["status"],
        coverImg: json["cover_img"],
        posterImg: json["poster_img"],
        movieLanguage: json["movie_language"],
        position: json['position'],
        genreId: json["genre_id"],
        movieCategory: json["movie_category"],
        reportCount: json["report_count"],
        videoLink: json["video_link"],
        movieVideo: json["movie_video"],
        trailorVideoLink: json["trailor_video_link"],
        trailorVideo: json["trailor_video"],
        quality: json["quality"],
        subtitle: json["subtitle"],
        description: json["description"],
        movieTime: json["movie_time"],
        movieRentPrice: json["movie_rent_price"],
        isMovieOnRent: json["is_movie_on_rent"],
        rentedTimeDays: json["rented_time_days"],
        isHighlighted: json["is_highlighted"],
        showSubscription: json["show_subscription"],
        isWatchlist: json["is_watchlist"],
        viewCount: json["view_count"],
        releasedBy: json["released_by"],
        releasedDate: json["released_date"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        language: json["language"] == null ? null : Category.fromJson(json["language"]),
        genre: json["genre"] == null ? null : Category.fromJson(json["genre"]),
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        ratings: json["ratings"] == null ? [] : List<dynamic>.from(json["ratings"]!.map((x) => x)),
        castCrew:
            json["cast_crew"] == null ? [] : List<CastCrew>.from(json["cast_crew"]!.map((x) => CastCrew.fromJson(x))),
        movieAd: json["movie_ad"] == null ? [] : List<dynamic>.from(json["movie_ad"]!.map((x) => x)),
        averageRating: json["average_rating"],
        totalRatings: json["total_ratings"],
        recommendedMovies:
            json["recommended_movies"] == null ? [] : List<dynamic>.from(json["recommended_movies"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "movie_name": movieName,
        "status": status,
        "cover_img": coverImg,
        "poster_img": posterImg,
        "movie_language": movieLanguage,
        "genre_id": genreId,
        "movie_category": movieCategory,
        "report_count": reportCount,
        "video_link": videoLink,
        "movie_video": movieVideo,
        "trailor_video_link": trailorVideoLink,
        "trailor_video": trailorVideo,
        "quality": quality,
        "subtitle": subtitle,
        "description": description,
        "movie_time": movieTime,
        "movie_rent_price": movieRentPrice,
        "is_movie_on_rent": isMovieOnRent,
        "rented_time_days": rentedTimeDays,
        "is_highlighted": isHighlighted,
        "is_watchlist": isWatchlist,
        "position": position,
        "view_count": viewCount,
        "released_by": releasedBy,
        "show_subscription": showSubscription,
        "released_date": releasedDate,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "language": language?.toJson(),
        "genre": genre?.toJson(),
        "category": category?.toJson(),
        "ratings": ratings == null ? [] : List<dynamic>.from(ratings!.map((x) => x)),
        "cast_crew": castCrew == null ? [] : List<dynamic>.from(castCrew!.map((x) => x.toJson())),
        "movie_ad": movieAd == null ? [] : List<dynamic>.from(movieAd!.map((x) => x)),
        "average_rating": averageRating,
        "total_ratings": totalRatings,
        "recommended_movies": recommendedMovies == null ? [] : List<dynamic>.from(recommendedMovies!.map((x) => x)),
      };
}

class CastCrew {
  String? id;
  String? profileImg;
  String? name;
  String? description;
  String? role;
  String? movieId;
  DateTime? createdAt;
  DateTime? updatedAt;

  CastCrew({
    this.id,
    this.profileImg,
    this.name,
    this.description,
    this.role,
    this.movieId,
    this.createdAt,
    this.updatedAt,
  });

  factory CastCrew.fromJson(Map<String, dynamic> json) => CastCrew(
        id: json["id"],
        profileImg: json["profile_img"],
        name: json["name"],
        description: json["description"],
        role: json["role"],
        movieId: json["movie_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_img": profileImg,
        "name": name,
        "description": description,
        "role": role,
        "movie_id": movieId,
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
