// To parse this JSON data, do
//
//     final getReportModel = getReportModelFromJson(jsonString);

import 'dart:convert';

GetReportModel getReportModelFromJson(String str) => GetReportModel.fromJson(json.decode(str));

String getReportModelToJson(GetReportModel data) => json.encode(data.toJson());

class GetReportModel {
    bool? status;
    String? message;
    List<ReportModel>? data;

    GetReportModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetReportModel.fromJson(Map<String, dynamic> json) => GetReportModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<ReportModel>.from(json["data"]!.map((x) => ReportModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class ReportModel {
    String? id;
    String? userId;
    String? contentId;
    String? reason;
    String? contentType;
    DateTime? createdAt;
    DateTime? updatedAt;
    ContentDetails? contentDetails;

    ReportModel({
        this.id,
        this.userId,
        this.contentId,
        this.reason,
        this.contentType,
        this.createdAt,
        this.updatedAt,
        this.contentDetails,
    });

    factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        id: json["id"],
        userId: json["user_id"],
        contentId: json["content_id"],
        reason: json["reason"],
        contentType: json["content_type"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        contentDetails: json["content_details"] == null ? null : ContentDetails.fromJson(json["content_details"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "content_id": contentId,
        "reason": reason,
        "content_type": contentType,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "content_details": contentDetails?.toJson(),
    };
}

class ContentDetails {
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
    int? reportCount;
    DateTime? releasedDate;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? movieName;
    String? movieVideo;
    String? trailorVideoLink;
    String? trailorVideo;
    String? seriesName;

    ContentDetails({
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
        this.reportCount,
        this.releasedDate,
        this.createdAt,
        this.updatedAt,
        this.movieName,
        this.movieVideo,
        this.trailorVideoLink,
        this.trailorVideo,
        this.seriesName,
    });

    factory ContentDetails.fromJson(Map<String, dynamic> json) => ContentDetails(
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
        reportCount: json["report_count"],
        releasedDate: json["released_date"] == null ? null : DateTime.parse(json["released_date"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        movieName: json["movie_name"],
        movieVideo: json["movie_video"],
        trailorVideoLink: json["trailor_video_link"],
        trailorVideo: json["trailor_video"],
        seriesName: json["series_name"],
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
        "report_count": reportCount,
        "released_date": releasedDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "movie_name": movieName,
        "movie_video": movieVideo,
        "trailor_video_link": trailorVideoLink,
        "trailor_video": trailorVideo,
        "series_name": seriesName,
    };
}
