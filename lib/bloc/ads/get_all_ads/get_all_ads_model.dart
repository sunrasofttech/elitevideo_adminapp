// To parse this JSON data, do
//
//     final getAllAdsModel = getAllAdsModelFromJson(jsonString);

import 'dart:convert';

GetAllAdsModel getAllAdsModelFromJson(String str) => GetAllAdsModel.fromJson(json.decode(str));

String getAllAdsModelToJson(GetAllAdsModel data) => json.encode(data.toJson());

class GetAllAdsModel {
    bool? status;
    String? message;
    List<Datum>? data;

    GetAllAdsModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetAllAdsModel.fromJson(Map<String, dynamic> json) => GetAllAdsModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    String? id;
    String? adVideo;
    String? adUrl;
    String? videoTime;
    String? skipTime;
    String? title;
    DateTime? createdAt;
    DateTime? updatedAt;

    Datum({
        this.id,
        this.adVideo,
        this.adUrl,
        this.videoTime,
        this.skipTime,
        this.title,
        this.createdAt,
        this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
