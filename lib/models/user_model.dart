import 'package:cloud_firestore/cloud_firestore.dart';

/// User model for Firebase Firestore
class UserModel {
  final String uid;
  final String name;
  final String phone;
  final String email;
  final String profileImageUrl;
  final String status;
  final bool isOnline;
  final DateTime lastSeen;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String fcmToken;
  final List<String> blockedUsers;
  final List<String> contacts;
  final Map<String, dynamic> settings;
  final bool isVerified;
  final String? bio;
  final String? location;

  UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    this.email = '',
    this.profileImageUrl = '',
    this.status = 'Hey there! I am using ChatUp',
    this.isOnline = false,
    required this.lastSeen,
    required this.createdAt,
    required this.updatedAt,
    this.fcmToken = '',
    this.blockedUsers = const [],
    this.contacts = const [],
    this.settings = const {},
    this.isVerified = false,
    this.bio,
    this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'status': status,
      'isOnline': isOnline,
      'lastSeen': Timestamp.fromDate(lastSeen),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'fcmToken': fcmToken,
      'blockedUsers': blockedUsers,
      'contacts': contacts,
      'settings': settings,
      'isVerified': isVerified,
      'bio': bio,
      'location': location,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      status: map['status'] ?? 'Hey there! I am using ChatUp',
      isOnline: map['isOnline'] ?? false,
      lastSeen: (map['lastSeen'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      fcmToken: map['fcmToken'] ?? '',
      blockedUsers: List<String>.from(map['blockedUsers'] ?? []),
      contacts: List<String>.from(map['contacts'] ?? []),
      settings: Map<String, dynamic>.from(map['settings'] ?? {}),
      isVerified: map['isVerified'] ?? false,
      bio: map['bio'],
      location: map['location'],
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? phone,
    String? email,
    String? profileImageUrl,
    String? status,
    bool? isOnline,
    DateTime? lastSeen,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? fcmToken,
    List<String>? blockedUsers,
    List<String>? contacts,
    Map<String, dynamic>? settings,
    bool? isVerified,
    String? bio,
    String? location,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      status: status ?? this.status,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fcmToken: fcmToken ?? this.fcmToken,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      contacts: contacts ?? this.contacts,
      settings: settings ?? this.settings,
      isVerified: isVerified ?? this.isVerified,
      bio: bio ?? this.bio,
      location: location ?? this.location,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, phone: $phone, email: $email, status: $status, isOnline: $isOnline)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
