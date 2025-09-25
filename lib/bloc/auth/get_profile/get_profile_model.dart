// To parse this JSON data, do
//
//     final getAdminProfileModel = getAdminProfileModelFromJson(jsonString);

import 'dart:convert';

GetAdminProfileModel getAdminProfileModelFromJson(String str) => GetAdminProfileModel.fromJson(json.decode(str));

String getAdminProfileModelToJson(GetAdminProfileModel data) => json.encode(data.toJson());

class GetAdminProfileModel {
  bool? status;
  String? message;
  Admin? admin;

  GetAdminProfileModel({
    this.status,
    this.message,
    this.admin,
  });

  factory GetAdminProfileModel.fromJson(Map<String, dynamic> json) => GetAdminProfileModel(
        status: json["status"],
        message: json["message"],
        admin: json["admin"] == null ? null : Admin.fromJson(json["admin"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "admin": admin?.toJson(),
      };
}

class Admin {
  String? id;
  String? name;
  String? password;
  dynamic profileImg;
  dynamic email;
  String? role;
  Map<String, bool>? permissions;
  DateTime? createdAt;

  Admin({
    this.id,
    this.name,
    this.password,
    this.profileImg,
    this.email,
    this.role,
    this.permissions,
    this.createdAt,
  });

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
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
