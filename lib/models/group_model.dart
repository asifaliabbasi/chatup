import 'package:cloud_firestore/cloud_firestore.dart';

/// Group model for group chat functionality
class GroupModel {
  final String id;
  final String name;
  final String description;
  final String profileImageUrl;
  final List<String> participants;
  final List<String> admins;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> settings;
  final bool isActive;
  final String? inviteLink;
  final Map<String, DateTime> joinDates;

  GroupModel({
    required this.id,
    required this.name,
    this.description = '',
    this.profileImageUrl = '',
    required this.participants,
    required this.admins,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.settings = const {},
    this.isActive = true,
    this.inviteLink,
    this.joinDates = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'profileImageUrl': profileImageUrl,
      'participants': participants,
      'admins': admins,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'settings': settings,
      'isActive': isActive,
      'inviteLink': inviteLink,
      'joinDates': joinDates.map((key, value) => MapEntry(key, Timestamp.fromDate(value))),
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      participants: List<String>.from(map['participants'] ?? []),
      admins: List<String>.from(map['admins'] ?? []),
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      settings: Map<String, dynamic>.from(map['settings'] ?? {}),
      isActive: map['isActive'] ?? true,
      inviteLink: map['inviteLink'],
      joinDates: (map['joinDates'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, (value as Timestamp).toDate()),
      ) ?? {},
    );
  }

  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroupModel.fromMap(data);
  }

  GroupModel copyWith({
    String? id,
    String? name,
    String? description,
    String? profileImageUrl,
    List<String>? participants,
    List<String>? admins,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? settings,
    bool? isActive,
    String? inviteLink,
    Map<String, DateTime>? joinDates,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      participants: participants ?? this.participants,
      admins: admins ?? this.admins,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      settings: settings ?? this.settings,
      isActive: isActive ?? this.isActive,
      inviteLink: inviteLink ?? this.inviteLink,
      joinDates: joinDates ?? this.joinDates,
    );
  }

  bool isAdmin(String userId) => admins.contains(userId);
  bool isParticipant(String userId) => participants.contains(userId);
  bool canSendMessages(String userId) => isParticipant(userId) && isActive;

  @override
  String toString() {
    return 'GroupModel(id: $id, name: $name, participants: ${participants.length}, admins: ${admins.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GroupModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
