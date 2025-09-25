// To parse this JSON data, do
//
//     final getUserAnalysisModel = getUserAnalysisModelFromJson(jsonString);

import 'dart:convert';

GetUserAnalysisModel getUserAnalysisModelFromJson(String str) => GetUserAnalysisModel.fromJson(json.decode(str));

String getUserAnalysisModelToJson(GetUserAnalysisModel data) => json.encode(data.toJson());

class GetUserAnalysisModel {
    bool? status;
    String? year;
    List<Datum>? data;

    GetUserAnalysisModel({
        this.status,
        this.year,
        this.data,
    });

    factory GetUserAnalysisModel.fromJson(Map<String, dynamic> json) => GetUserAnalysisModel(
        status: json["status"],
        year: json["year"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "year": year,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? monthNumber;
    String? month;
    int? userCount;

    Datum({
        this.monthNumber,
        this.month,
        this.userCount,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        monthNumber: json["month_number"],
        month: json["month"],
        userCount: json["user_count"],
    );

    Map<String, dynamic> toJson() => {
        "month_number": monthNumber,
        "month": month,
        "user_count": userCount,
    };
}
