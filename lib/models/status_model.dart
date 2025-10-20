import 'package:cloud_firestore/cloud_firestore.dart';

/// Status model for status updates (like WhatsApp stories)
class StatusModel {
  final String id;
  final String userId;
  final String userName;
  final String userProfileImageUrl;
  final String content;
  final StatusType type;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final DateTime createdAt;
  final DateTime expiresAt;
  final List<String> viewers;
  final Map<String, DateTime> viewTimes;
  final bool isActive;
  final String? caption;
  final String? location;

  StatusModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userProfileImageUrl = '',
    required this.content,
    required this.type,
    this.mediaUrl,
    this.thumbnailUrl,
    required this.createdAt,
    required this.expiresAt,
    this.viewers = const [],
    this.viewTimes = const {},
    this.isActive = true,
    this.caption,
    this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userProfileImageUrl': userProfileImageUrl,
      'content': content,
      'type': type.index,
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'viewers': viewers,
      'viewTimes': viewTimes.map((key, value) => MapEntry(key, Timestamp.fromDate(value))),
      'isActive': isActive,
      'caption': caption,
      'location': location,
    };
  }

  factory StatusModel.fromMap(Map<String, dynamic> map) {
    return StatusModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userProfileImageUrl: map['userProfileImageUrl'] ?? '',
      content: map['content'] ?? '',
      type: StatusType.values[map['type'] ?? 0],
      mediaUrl: map['mediaUrl'],
      thumbnailUrl: map['thumbnailUrl'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiresAt: (map['expiresAt'] as Timestamp?)?.toDate() ?? DateTime.now().add(const Duration(hours: 24)),
      viewers: List<String>.from(map['viewers'] ?? []),
      viewTimes: (map['viewTimes'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, (value as Timestamp).toDate()),
      ) ?? {},
      isActive: map['isActive'] ?? true,
      caption: map['caption'],
      location: map['location'],
    );
  }

  factory StatusModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StatusModel.fromMap(data);
  }

  StatusModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userProfileImageUrl,
    String? content,
    StatusType? type,
    String? mediaUrl,
    String? thumbnailUrl,
    DateTime? createdAt,
    DateTime? expiresAt,
    List<String>? viewers,
    Map<String, DateTime>? viewTimes,
    bool? isActive,
    String? caption,
    String? location,
  }) {
    return StatusModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfileImageUrl: userProfileImageUrl ?? this.userProfileImageUrl,
      content: content ?? this.content,
      type: type ?? this.type,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      viewers: viewers ?? this.viewers,
      viewTimes: viewTimes ?? this.viewTimes,
      isActive: isActive ?? this.isActive,
      caption: caption ?? this.caption,
      location: location ?? this.location,
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isViewed => viewers.isNotEmpty;
  int get viewCount => viewers.length;

  @override
  String toString() {
    return 'StatusModel(id: $id, userId: $userId, type: $type, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StatusModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

enum StatusType {
  text,
  image,
  video,
}
