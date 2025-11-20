import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_role.dart';

class AppUser {
  final String uid;
  final String email;
  final String username;
  final UserRole role;
  final DateTime createdAt;
  final String? profileImageUrl;

  AppUser({
    required this.uid,
    required this.email,
    required this.username,
    required this.role,
    required this.createdAt,
    this.profileImageUrl,
  });

  //convert user to json for firestore
  Map<String, dynamic> toJson(){
    return{
      'uid': uid,
      'email': email,
      'username': username,
      'role': role.toJson(),
      'createdAt': Timestamp.fromDate(createdAt),
      'profileImageUrl': profileImageUrl,
    };
  }

  //create user from firestore
  factory AppUser.fromJson(Map<String, dynamic> json){
    return AppUser(
      uid: json['uid'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      role: UserRole.fromJson(json['role'] as String),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  AppUser copyWith({
    String? uid,
    String? email,
    String? username,
    UserRole? role,
    DateTime? createdAt,
    String? profileImageUrl,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}