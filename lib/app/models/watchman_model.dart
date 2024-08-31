import 'package:cloud_firestore/cloud_firestore.dart';

class WatchManModel {
  String? id;
  bool? active;
  String? ownerId;
  String? parkingId;
  String? name;
  String? image;
  String? email;
  String? dateOfBirth;
  String? fcmToken;
  String? phoneNumber;
  String? countryCode;
  String? password;
  String? salary;
  Timestamp? createdAt;

  WatchManModel(
      {this.id,
      this.ownerId,
      this.active,
      this.parkingId,
      this.image,
      this.phoneNumber,
      this.dateOfBirth,
      this.fcmToken,
      this.countryCode,
      this.name,
      this.email,
      this.password,
      this.createdAt,
      this.salary});

  WatchManModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['ownerId'];
    parkingId = json['parkingId'];
    name = json['name'];
    image = json['image'];
    active = json['active'];
    email = json['email'];
    createdAt = json['createdAt'];
    countryCode = json['countryCode'];
    fcmToken = json['fcmToken'];
    password = json['password'];
    dateOfBirth = json['dateOfBirth'];
    salary = json['salary'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ownerId'] = ownerId;
    data['parkingId'] = parkingId;
    data['name'] = name;
    data['email'] = email;
    data['active'] = active ?? true;
    data['countryCode'] = countryCode;
    data['dateOfBirth'] = dateOfBirth;
    data['image'] = image;
    data['fcmToken'] = fcmToken;
    data['password'] = password;
    data['salary'] = salary;
    data['phoneNumber'] = phoneNumber;
    data['createdAt'] = createdAt;
    return data;
  }
}
