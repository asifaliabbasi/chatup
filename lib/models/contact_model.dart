import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart'; // ✅ YEH LINE ADD KI GAYI HAI

/// Contact model for managing user contacts
class ContactModel {
  final String id;
  final String name;
  final String phone;
  final String profileImageUrl;
  final String status;
  final bool isOnline;
  final DateTime lastSeen;
  final bool isBlocked;
  final bool isFavorite;
  final DateTime addedAt;
  final String? email;
  final String? bio;

  ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    this.profileImageUrl = '',
    this.status = '',
    this.isOnline = false,
    required this.lastSeen,
    this.isBlocked = false,
    this.isFavorite = false,
    required this.addedAt,
    this.email,
    this.bio,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'status': status,
      'isOnline': isOnline,
      'lastSeen': Timestamp.fromDate(lastSeen),
      'isBlocked': isBlocked,
      'isFavorite': isFavorite,
      'addedAt': Timestamp.fromDate(addedAt),
      'email': email,
      'bio': bio,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      status: map['status'] ?? '',
      isOnline: map['isOnline'] ?? false,
      lastSeen: (map['lastSeen'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isBlocked: map['isBlocked'] ?? false,
      isFavorite: map['isFavorite'] ?? false,
      addedAt: (map['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      email: map['email'],
      bio: map['bio'],
    );
  }

  factory ContactModel.fromUserModel(UserModel user) {
    return ContactModel(
      id: user.uid,
      name: user.name,
      phone: user.phone,
      profileImageUrl: user.profileImageUrl,
      status: user.status,
      isOnline: user.isOnline,
      lastSeen: user.lastSeen,
      addedAt: DateTime.now(), // Jab contact banaya jaye
      email: user.email,
      bio: user.bio,
    );
  }

  ContactModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? profileImageUrl,
    String? status,
    bool? isOnline,
    DateTime? lastSeen,
    bool? isBlocked,
    bool? isFavorite,
    DateTime? addedAt,
    String? email,
    String? bio,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      status: status ?? this.status,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      isBlocked: isBlocked ?? this.isBlocked,
      isFavorite: isFavorite ?? this.isFavorite,
      addedAt: addedAt ?? this.addedAt,
      email: email ?? this.email,
      bio: bio ?? this.bio,
    );
  }

  @override
  String toString() {
    return 'ContactModel(id: $id, name: $name, phone: $phone, isOnline: $isOnline)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContactModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
