// To parse this JSON data, do
//
//     final getRevenueModel = getRevenueModelFromJson(jsonString);

import 'dart:convert';

GetRevenueModel getRevenueModelFromJson(String str) => GetRevenueModel.fromJson(json.decode(str));

String getRevenueModelToJson(GetRevenueModel data) => json.encode(data.toJson());

class GetRevenueModel {
    bool? status;
    String? message;
    List<Datum>? data;

    GetRevenueModel({
        this.status,
        this.message,
        this.data,
    });

    factory GetRevenueModel.fromJson(Map<String, dynamic> json) => GetRevenueModel(
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
    String? month;
    String? year;
    int? totalRevenue;

    Datum({
        this.month,
        this.year,
        this.totalRevenue,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        month: json["month"],
        year: json["year"],
        totalRevenue: json["total_revenue"],
    );

    Map<String, dynamic> toJson() => {
        "month": month,
        "year": year,
        "total_revenue": totalRevenue,
    };
}
