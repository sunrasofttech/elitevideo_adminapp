// To parse this JSON data, do
//
//     final getSeasonModel = getSeasonModelFromJson(jsonString);

import 'dart:convert';

GetSeasonModel getSeasonModelFromJson(String str) => GetSeasonModel.fromJson(json.decode(str));

String getSeasonModelToJson(GetSeasonModel data) => json.encode(data.toJson());

class GetSeasonModel {
  bool? status;
  String? message;
  List<Datum>? data;
  Pagination? pagination;

  GetSeasonModel({
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  factory GetSeasonModel.fromJson(Map<String, dynamic> json) => GetSeasonModel(
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
  String? seasonName;
  bool? status;
  String? seriesId;
  String? releasedDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  Series? series;
  List<dynamic>? episodes;

  Datum({
    this.id,
    this.seasonName,
    this.status,
    this.seriesId,
    this.releasedDate,
    this.createdAt,
    this.updatedAt,
    this.series,
    this.episodes,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        seasonName: json["season_name"],
        status: json["status"],
        seriesId: json["series_id"],
        releasedDate: json["released_date"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        series: json["series"] == null ? null : Series.fromJson(json["series"]),
        episodes: json["episodes"] == null ? [] : List<dynamic>.from(json["episodes"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "season_name": seasonName,
        "status": status,
        "series_id": seriesId,
        "released_date": releasedDate,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "series": series?.toJson(),
        "episodes": episodes == null ? [] : List<dynamic>.from(episodes!.map((x) => x)),
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
