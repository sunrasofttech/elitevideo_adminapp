// To parse this JSON data, do
//
//     final getSeasonAdsModel = getSeasonAdsModelFromJson(jsonString);

import 'dart:convert';

GetSeasonAdsModel getSeasonAdsModelFromJson(String str) => GetSeasonAdsModel.fromJson(json.decode(str));

String getSeasonAdsModelToJson(GetSeasonAdsModel data) => json.encode(data.toJson());

class GetSeasonAdsModel {
    bool? status;
    String? message;
    List<Datum>? data;
    Pagination? pagination;

    GetSeasonAdsModel({
        this.status,
        this.message,
        this.data,
        this.pagination,
    });

    factory GetSeasonAdsModel.fromJson(Map<String, dynamic> json) => GetSeasonAdsModel(
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
    String? seasonEpisodeId;
    String? videoAdId;
    DateTime? createdAt;
    DateTime? updatedAt;
    SeasonEpisode? seasonEpisode;
    VideoAd? videoAd;

    Datum({
        this.id,
        this.seasonEpisodeId,
        this.videoAdId,
        this.createdAt,
        this.updatedAt,
        this.seasonEpisode,
        this.videoAd,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        seasonEpisodeId: json["season_episode_id"],
        videoAdId: json["video_ad_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        seasonEpisode: json["season_episode"] == null ? null : SeasonEpisode.fromJson(json["season_episode"]),
        videoAd: json["video_ad"] == null ? null : VideoAd.fromJson(json["video_ad"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "season_episode_id": seasonEpisodeId,
        "video_ad_id": videoAdId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "season_episode": seasonEpisode?.toJson(),
        "video_ad": videoAd?.toJson(),
    };
}

class SeasonEpisode {
    String? id;
    String? coverImg;
    bool? status;
    String? seriesId;
    String? seasonId;
    String? episodeName;
    String? episodeNo;
    dynamic videoLink;
    String? video;
    DateTime? releasedDate;
    DateTime? createdAt;
    DateTime? updatedAt;

    SeasonEpisode({
        this.id,
        this.coverImg,
        this.status,
        this.seriesId,
        this.seasonId,
        this.episodeName,
        this.episodeNo,
        this.videoLink,
        this.video,
        this.releasedDate,
        this.createdAt,
        this.updatedAt,
    });

    factory SeasonEpisode.fromJson(Map<String, dynamic> json) => SeasonEpisode(
        id: json["id"],
        coverImg: json["cover_img"],
        status: json["status"],
        seriesId: json["series_id"],
        seasonId: json["season_id"],
        episodeName: json["episode_name"],
        episodeNo: json["episode_no"],
        videoLink: json["video_link"],
        video: json["video"],
        releasedDate: json["released_date"] == null ? null : DateTime.parse(json["released_date"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "cover_img": coverImg,
        "status": status,
        "series_id": seriesId,
        "season_id": seasonId,
        "episode_name": episodeName,
        "episode_no": episodeNo,
        "video_link": videoLink,
        "video": video,
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
