import 'package:flutter/material.dart';

class User {
  final String name;
  final String email;
  final String? profilePictureUrl;
  final String? organization;
  final String? bio;

  User({
    required this.name,
    required this.email,
    this.profilePictureUrl,
    this.organization,
    this.bio,
  });

  User copyWith({
    String? name,
    String? email,
    String? profilePictureUrl,
    String? organization,
    String? bio,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      organization: organization ?? this.organization,
      bio: bio ?? this.bio,
    );
  }
}
