import 'package:cloud_firestore/cloud_firestore.dart';

// Message ki types ko define karne ke liye enum
enum MessageType { text, image, video, audio, document }

class Message {
  final String id;
  final String senderId;
  final String text;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;
  final String? filePath;
  final String? fileName;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.filePath,
    this.fileName,
  });

  // Firestore se data le kar Message object banayein
  factory Message.fromMap(Map<String, dynamic> map, String id) {
    return Message(
      id: id,
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      // String se MessageType enum mein convert karein
      type: MessageType.values.firstWhere(
            (e) => e.toString() == 'MessageType.${map['type'] ?? 'text'}',
        orElse: () => MessageType.text, // Default value
      ),
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: map['isRead'] ?? false,
      filePath: map['fileUrl'],
      fileName: map['fileName'],
    );
  }

  // Message object ko Firestore mein save karne ke liye Map mein convert karein
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'type': type.toString().split('.').last, // Enum ko string mein save karein
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      'fileUrl': filePath,
      'fileName': fileName,
    };
  }
}

