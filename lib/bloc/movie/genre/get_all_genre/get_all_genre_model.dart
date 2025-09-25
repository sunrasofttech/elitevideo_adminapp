// To parse this JSON data, do
//
//     final getGenreModel = getGenreModelFromJson(jsonString);

import 'dart:convert';

GetGenreModel getGenreModelFromJson(String str) => GetGenreModel.fromJson(json.decode(str));

String getGenreModelToJson(GetGenreModel data) => json.encode(data.toJson());

class GetGenreModel {
  bool? status;
  String? message;
  List<Datum>? data;

  GetGenreModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetGenreModel.fromJson(Map<String, dynamic> json) => GetGenreModel(
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
  dynamic coverImg;
  String? name;
  bool? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.coverImg,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        coverImg: json["cover_img"],
        name: json["name"],
        status: json["status"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cover_img": coverImg,
        "name": name,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
