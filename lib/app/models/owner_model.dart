import 'package:cloud_firestore/cloud_firestore.dart';

class OwnerModel {
  String? fullName;
  String? id;
  String? email;
  String? loginType;
  String? profilePic;
  String? fcmToken;
  bool? active;
  String? countryCode;
  String? phoneNumber;
  String? walletAmount;
  Timestamp? createdAt;

  OwnerModel(
      {this.fullName,
      this.id,
      this.email,
      this.loginType,
      this.active,
      this.profilePic,
      this.fcmToken,
      this.countryCode,
      this.phoneNumber,
      this.walletAmount,
      this.createdAt});

  OwnerModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    id = json['id'];
    email = json['email'];
    active = json['active'];
    loginType = json['loginType'];
    profilePic = json['profilePic'];
    fcmToken = json['fcmToken'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    walletAmount = json['walletAmount'] ?? "0";
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['id'] = id;
    data['active'] = active ?? true;
    data['email'] = email;
    data['loginType'] = loginType;
    data['profilePic'] = profilePic;
    data['fcmToken'] = fcmToken;
    data['countryCode'] = countryCode;
    data['phoneNumber'] = phoneNumber;
    data['walletAmount'] = walletAmount;
    data['createdAt'] = createdAt;
    return data;
  }
}
