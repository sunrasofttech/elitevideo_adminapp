// To parse this JSON data, do
//
//     final getCastCrewShortFilmModel = getCastCrewShortFilmModelFromJson(jsonString);

import 'dart:convert';

GetCastCrewShortFilmModel getCastCrewShortFilmModelFromJson(String str) => GetCastCrewShortFilmModel.fromJson(json.decode(str));

String getCastCrewShortFilmModelToJson(GetCastCrewShortFilmModel data) => json.encode(data.toJson());

class GetCastCrewShortFilmModel {
    bool? status;
    String? message;
    List<Datum>? data;
    Pagination? pagination;

    GetCastCrewShortFilmModel({
        this.status,
        this.message,
        this.data,
        this.pagination,
    });

    factory GetCastCrewShortFilmModel.fromJson(Map<String, dynamic> json) => GetCastCrewShortFilmModel(
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
    String? profileImg;
    String? name;
    String? description;
    String? role;
    String? shortfilmId;
    DateTime? createdAt;
    DateTime? updatedAt;
    Shortfilm? shortfilm;

    Datum({
        this.id,
        this.profileImg,
        this.name,
        this.description,
        this.role,
        this.shortfilmId,
        this.createdAt,
        this.updatedAt,
        this.shortfilm,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        profileImg: json["profile_img"],
        name: json["name"],
        description: json["description"],
        role: json["role"],
        shortfilmId: json["shortfilm_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        shortfilm: json["shortfilm"] == null ? null : Shortfilm.fromJson(json["shortfilm"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "profile_img": profileImg,
        "name": name,
        "description": description,
        "role": role,
        "shortfilm_id": shortfilmId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "shortfilm": shortfilm?.toJson(),
    };
}

class Shortfilm {
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

    Shortfilm({
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

    factory Shortfilm.fromJson(Map<String, dynamic> json) => Shortfilm(
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

class Pagination {
    int? totalItems;
    int? currentPage;
    int? totalPages;
    int? perPage;

    Pagination({
        this.totalItems,
        this.currentPage,
        this.totalPages,
        this.perPage,
    });

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalItems: json["totalItems"],
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
        perPage: json["perPage"],
    );

    Map<String, dynamic> toJson() => {
        "totalItems": totalItems,
        "currentPage": currentPage,
        "totalPages": totalPages,
        "perPage": perPage,
    };
}
