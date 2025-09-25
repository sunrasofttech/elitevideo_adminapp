// To parse this JSON data, do
//
//     final getAllSubAdminModel = getAllSubAdminModelFromJson(jsonString);

import 'dart:convert';

GetAllSubAdminModel getAllSubAdminModelFromJson(String str) => GetAllSubAdminModel.fromJson(json.decode(str));

String getAllSubAdminModelToJson(GetAllSubAdminModel data) => json.encode(data.toJson());

class GetAllSubAdminModel {
    bool? status;
    String? message;
    List<Datum>? data;
    Pagination? pagination;

    GetAllSubAdminModel({
        this.status,
        this.message,
        this.data,
        this.pagination,
    });

    factory GetAllSubAdminModel.fromJson(Map<String, dynamic> json) => GetAllSubAdminModel(
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
    String? name;
    String? password;
    dynamic profileImg;
    String? email;
    String? role;
    Map<String, bool>? permissions;
    DateTime? createdAt;

    Datum({
        this.id,
        this.name,
        this.password,
        this.profileImg,
        this.email,
        this.role,
        this.permissions,
        this.createdAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        password: json["password"],
        profileImg: json["profile_img"],
        email: json["email"],
        role: json["role"],
        permissions: Map.from(json["permissions"]!).map((k, v) => MapEntry<String, bool>(k, v)),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "password": password,
        "profile_img": profileImg,
        "email": email,
        "role": role,
        "permissions": Map.from(permissions!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "createdAt": createdAt?.toIso8601String(),
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
