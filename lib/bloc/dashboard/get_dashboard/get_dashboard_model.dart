// To parse this JSON data, do
//
//     final getDashboardModel = getDashboardModelFromJson(jsonString);

import 'dart:convert';

GetDashboardModel getDashboardModelFromJson(String str) => GetDashboardModel.fromJson(json.decode(str));

String getDashboardModelToJson(GetDashboardModel data) => json.encode(data.toJson());

class GetDashboardModel {
    bool? status;
    String? message;
    Data? data;

    GetDashboardModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetDashboardModel.fromJson(Map<String, dynamic> json) => GetDashboardModel(
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
    int? totalUsers;
    int? activeUsers;
    int? subscriberActiveUsers;
    int? totalMovies;
    int? totalSongs;
    List<dynamic>? recentActivity;

    Data({
        this.totalUsers,
        this.activeUsers,
        this.subscriberActiveUsers,
        this.totalMovies,
        this.totalSongs,
        this.recentActivity,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalUsers: json["totalUsers"],
        activeUsers: json["activeUsers"],
        subscriberActiveUsers: json["subscriberActiveUsers"],
        totalMovies: json["totalMovies"],
        totalSongs: json["totalSongs"],
        recentActivity: json["recentActivity"] == null ? [] : List<dynamic>.from(json["recentActivity"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "totalUsers": totalUsers,
        "activeUsers": activeUsers,
        "subscriberActiveUsers": subscriberActiveUsers,
        "totalMovies": totalMovies,
        "totalSongs": totalSongs,
        "recentActivity": recentActivity == null ? [] : List<dynamic>.from(recentActivity!.map((x) => x)),
    };
}
