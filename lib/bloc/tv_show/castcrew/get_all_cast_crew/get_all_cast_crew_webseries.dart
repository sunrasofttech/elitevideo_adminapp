// To parse this JSON data, do
//
//     final getCastCrewWebSeriesModel = getCastCrewWebSeriesModelFromJson(jsonString);

import 'dart:convert';

GetCastCrewWebSeriesModel getCastCrewWebSeriesModelFromJson(String str) => GetCastCrewWebSeriesModel.fromJson(json.decode(str));

String getCastCrewWebSeriesModelToJson(GetCastCrewWebSeriesModel data) => json.encode(data.toJson());

class GetCastCrewWebSeriesModel {
    bool? status;
    String? message;
    List<Datum>? data;
    Pagination? pagination;

    GetCastCrewWebSeriesModel({
        this.status,
        this.message,
        this.data,
        this.pagination,
    });

    factory GetCastCrewWebSeriesModel.fromJson(Map<String, dynamic> json) => GetCastCrewWebSeriesModel(
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
    String? seriesId;
    DateTime? createdAt;
    DateTime? updatedAt;
    Series? series;

    Datum({
        this.id,
        this.profileImg,
        this.name,
        this.description,
        this.role,
        this.seriesId,
        this.createdAt,
        this.updatedAt,
        this.series,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        profileImg: json["profile_img"],
        name: json["name"],
        description: json["description"],
        role: json["role"],
        seriesId: json["series_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        series: json["series"] == null ? null : Series.fromJson(json["series"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "profile_img": profileImg,
        "name": name,
        "description": description,
        "role": role,
        "series_id": seriesId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "series": series?.toJson(),
    };
}

class Series {
    String? id;
    String? seriesName;
    bool? status;
    String? coverImg;
    String? posterImg;
    String? movieLanguage;
    String? genreId;
    String? movieCategory;
    String? description;
    String? releasedBy;
    DateTime? releasedDate;
    int? reportCount;
    DateTime? createdAt;
    DateTime? updatedAt;

    Series({
        this.id,
        this.seriesName,
        this.status,
        this.coverImg,
        this.posterImg,
        this.movieLanguage,
        this.genreId,
        this.movieCategory,
        this.description,
        this.releasedBy,
        this.releasedDate,
        this.reportCount,
        this.createdAt,
        this.updatedAt,
    });

    factory Series.fromJson(Map<String, dynamic> json) => Series(
        id: json["id"],
        seriesName: json["series_name"],
        status: json["status"],
        coverImg: json["cover_img"],
        posterImg: json["poster_img"],
        movieLanguage: json["movie_language"],
        genreId: json["genre_id"],
        movieCategory: json["movie_category"],
        description: json["description"],
        releasedBy: json["released_by"],
        releasedDate: json["released_date"] == null ? null : DateTime.parse(json["released_date"]),
        reportCount: json["report_count"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "series_name": seriesName,
        "status": status,
        "cover_img": coverImg,
        "poster_img": posterImg,
        "movie_language": movieLanguage,
        "genre_id": genreId,
        "movie_category": movieCategory,
        "description": description,
        "released_by": releasedBy,
        "released_date": releasedDate?.toIso8601String(),
        "report_count": reportCount,
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
