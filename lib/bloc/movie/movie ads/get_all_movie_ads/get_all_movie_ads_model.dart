// To parse this JSON data, do
//
//     final movieAdsModel = movieAdsModelFromJson(jsonString);

import 'dart:convert';

MovieAdsModel movieAdsModelFromJson(String str) => MovieAdsModel.fromJson(json.decode(str));

String movieAdsModelToJson(MovieAdsModel data) => json.encode(data.toJson());

class MovieAdsModel {
    bool? status;
    String? message;
    List<Datum>? data;
    Pagination? pagination;

    MovieAdsModel({
        this.status,
        this.message,
        this.data,
        this.pagination,
    });

    factory MovieAdsModel.fromJson(Map<String, dynamic> json) => MovieAdsModel(
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

class Datum {
    String? id;
    String? movieId;
    String? videoAdId;
    DateTime? createdAt;
    DateTime? updatedAt;
    Movie? movie;
    VideoAd? videoAd;

    Datum({
        this.id,
        this.movieId,
        this.videoAdId,
        this.createdAt,
        this.updatedAt,
        this.movie,
        this.videoAd,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        movieId: json["movie_id"],
        videoAdId: json["video_ad_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        movie: json["movie"] == null ? null : Movie.fromJson(json["movie"]),
        videoAd: json["video_ad"] == null ? null : VideoAd.fromJson(json["video_ad"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "movie_id": movieId,
        "video_ad_id": videoAdId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "movie": movie?.toJson(),
        "video_ad": videoAd?.toJson(),
    };
}

class Movie {
    String? id;
    String? movieName;
    bool? status;
    String? coverImg;
    String? posterImg;
    String? movieLanguage;
    dynamic genreId;
    dynamic movieCategory;
    int? reportCount;
    dynamic videoLink;
    String? movieVideo;
    dynamic trailorVideoLink;
    dynamic trailorVideo;
    bool? quality;
    bool? subtitle;
    String? description;
    String? movieTime;
    String? movieRentPrice;
    bool? isMovieOnRent;
    bool? isHighlighted;
    bool? isWatchlist;
    int? viewCount;
    String? releasedBy;
    DateTime? releasedDate;
    DateTime? createdAt;
    DateTime? updatedAt;

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
        this.trailorVideoLink,
        this.trailorVideo,
        this.quality,
        this.subtitle,
        this.description,
        this.movieTime,
        this.movieRentPrice,
        this.isMovieOnRent,
        this.isHighlighted,
        this.isWatchlist,
        this.viewCount,
        this.releasedBy,
        this.releasedDate,
        this.createdAt,
        this.updatedAt,
    });

    factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json["id"],
        movieName: json["movie_name"],
        status: json["status"],
        coverImg: json["cover_img"],
        posterImg: json["poster_img"],
        movieLanguage: json["movie_language"],
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
        isHighlighted: json["is_highlighted"],
        isWatchlist: json["is_watchlist"],
        viewCount: json["view_count"],
        releasedBy: json["released_by"],
        releasedDate: json["released_date"] == null ? null : DateTime.parse(json["released_date"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
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
        "is_highlighted": isHighlighted,
        "is_watchlist": isWatchlist,
        "view_count": viewCount,
        "released_by": releasedBy,
        "released_date": releasedDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
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

class Pagination {
    int? total;
    int? page;
    int? limit;
    int? totalPages;

    Pagination({
        this.total,
        this.page,
        this.limit,
        this.totalPages,
    });

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"],
        page: json["page"],
        limit: json["limit"],
        totalPages: json["totalPages"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "limit": limit,
        "totalPages": totalPages,
    };
}
