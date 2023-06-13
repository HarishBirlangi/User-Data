import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user_data.g.dart';

@HiveType(typeId: 1)
class UserData extends Equatable {
  final String userName;
  final String phoneNumber;
  final String dateOfBirth;
  final String emailId;
  final String image;
  const UserData({
    required this.userName,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.emailId,
    required this.image,
  });

  UserData copyWith({
    String? userName,
    String? phoneNumber,
    String? dateOfBirth,
    String? emailId,
    String? image,
  }) {
    return UserData(
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      emailId: emailId ?? this.emailId,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'emailId': emailId,
      'image': image,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      userName: map['userName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      emailId: map['emailId'] ?? '',
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserData(userName: $userName, phoneNumber: $phoneNumber, dateOfBirth: $dateOfBirth, emailId: $emailId, image: $image)';
  }

  @override
  List<Object?> get props =>
      [userName, phoneNumber, dateOfBirth, emailId, image];
}
