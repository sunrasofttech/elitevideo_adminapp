// To parse this JSON data, do
//
//     final getAllUserModel = getAllUserModelFromJson(jsonString);

import 'dart:convert';

GetAllUserModel getAllUserModelFromJson(String str) => GetAllUserModel.fromJson(json.decode(str));

String getAllUserModelToJson(GetAllUserModel data) => json.encode(data.toJson());

class GetAllUserModel {
    bool? status;
    String? message;
    int? total;
    int? page;
    int? pages;
    List<User>? users;

    GetAllUserModel({
        this.status,
        this.message,
        this.total,
        this.page,
        this.pages,
        this.users,
    });

    factory GetAllUserModel.fromJson(Map<String, dynamic> json) => GetAllUserModel(
        status: json["status"],
        message: json["message"],
        total: json["total"],
        page: json["page"],
        pages: json["pages"],
        users: json["users"] == null ? [] : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "total": total,
        "page": page,
        "pages": pages,
        "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x.toJson())),
    };
}

class User {
    String? id;
    dynamic profilePicture;
    String? name;
    String? email;
    bool? isFirstTimeUser;
    dynamic deviceId;
    String? deviceToken;
    String? mobileNo;
    String? password;
    dynamic appVersion;
    bool? isPaidMember;
    bool? isActive;
    dynamic subscriptionId;
    bool? isSubscription;
    dynamic subscriptionEndDate;
    bool? isBlock;
    dynamic activeDate;
    String? jwtApiToken;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic subscription;

    User({
        this.id,
        this.profilePicture,
        this.name,
        this.email,
        this.isFirstTimeUser,
        this.deviceId,
        this.deviceToken,
        this.mobileNo,
        this.password,
        this.appVersion,
        this.isPaidMember,
        this.isActive,
        this.subscriptionId,
        this.isSubscription,
        this.subscriptionEndDate,
        this.isBlock,
        this.activeDate,
        this.jwtApiToken,
        this.createdAt,
        this.updatedAt,
        this.subscription,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        profilePicture: json["profile_picture"],
        name: json["name"],
        email: json["email"],
        isFirstTimeUser: json["is_first_time_user"],
        deviceId: json["deviceId"],
        deviceToken: json["deviceToken"],
        mobileNo: json["mobile_no"],
        password: json["password"],
        appVersion: json["app_version"],
        isPaidMember: json["is_paid_member"],
        isActive: json["is_active"],
        subscriptionId: json["subscription_id"],
        isSubscription: json["is_subscription"],
        subscriptionEndDate: json["subscription_end_date"],
        isBlock: json["is_block"],
        activeDate: json["active_date"],
        jwtApiToken: json["jwt_api_token"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        subscription: json["subscription"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "profile_picture": profilePicture,
        "name": name,
        "email": email,
        "is_first_time_user": isFirstTimeUser,
        "deviceId": deviceId,
        "deviceToken": deviceToken,
        "mobile_no": mobileNo,
        "password": password,
        "app_version": appVersion,
        "is_paid_member": isPaidMember,
        "is_active": isActive,
        "subscription_id": subscriptionId,
        "is_subscription": isSubscription,
        "subscription_end_date": subscriptionEndDate,
        "is_block": isBlock,
        "active_date": activeDate,
        "jwt_api_token": jwtApiToken,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "subscription": subscription,
    };
}
