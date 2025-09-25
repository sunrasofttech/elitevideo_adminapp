// To parse this JSON data, do
//
//     final getLiveTvAdsModel = getLiveTvAdsModelFromJson(jsonString);

import 'dart:convert';

GetLiveTvAdsModel getLiveTvAdsModelFromJson(String str) => GetLiveTvAdsModel.fromJson(json.decode(str));

String getLiveTvAdsModelToJson(GetLiveTvAdsModel data) => json.encode(data.toJson());

class GetLiveTvAdsModel {
    bool? status;
    String? message;
    List<Datum>? data;
    Pagination? pagination;

    GetLiveTvAdsModel({
        this.status,
        this.message,
        this.data,
        this.pagination,
    });

    factory GetLiveTvAdsModel.fromJson(Map<String, dynamic> json) => GetLiveTvAdsModel(
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
    String? livetvChannelId;
    String? videoAdId;
    DateTime? createdAt;
    DateTime? updatedAt;
    LivetvChannel? livetvChannel;
    VideoAd? videoAd;

    Datum({
        this.id,
        this.livetvChannelId,
        this.videoAdId,
        this.createdAt,
        this.updatedAt,
        this.livetvChannel,
        this.videoAd,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        livetvChannelId: json["livetv_channel_id"],
        videoAdId: json["video_ad_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        livetvChannel: json["livetv_channel"] == null ? null : LivetvChannel.fromJson(json["livetv_channel"]),
        videoAd: json["video_ad"] == null ? null : VideoAd.fromJson(json["video_ad"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "livetv_channel_id": livetvChannelId,
        "video_ad_id": videoAdId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "livetv_channel": livetvChannel?.toJson(),
        "video_ad": videoAd?.toJson(),
    };
}

class LivetvChannel {
    String? id;
    String? coverImg;
    String? posterImg;
    String? liveCategoryId;
    String? name;
    String? androidChannelUrl;
    String? iosChannelUrl;
    bool? status;
    String? description;
    int? reportCount;
    DateTime? createdAt;
    DateTime? updatedAt;

    LivetvChannel({
        this.id,
        this.coverImg,
        this.posterImg,
        this.liveCategoryId,
        this.name,
        this.androidChannelUrl,
        this.iosChannelUrl,
        this.status,
        this.description,
        this.reportCount,
        this.createdAt,
        this.updatedAt,
    });

    factory LivetvChannel.fromJson(Map<String, dynamic> json) => LivetvChannel(
        id: json["id"],
        coverImg: json["cover_img"],
        posterImg: json["poster_img"],
        liveCategoryId: json["live_category_id"],
        name: json["name"],
        androidChannelUrl: json["android_channel_url"],
        iosChannelUrl: json["ios_channel_url"],
        status: json["status"],
        description: json["description"],
        reportCount: json["report_count"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "cover_img": coverImg,
        "poster_img": posterImg,
        "live_category_id": liveCategoryId,
        "name": name,
        "android_channel_url": androidChannelUrl,
        "ios_channel_url": iosChannelUrl,
        "status": status,
        "description": description,
        "report_count": reportCount,
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
