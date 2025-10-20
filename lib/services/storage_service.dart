import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

/// Comprehensive Firebase Storage service for handling file uploads and downloads
class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Storage references
  static Reference get _profileImages => _storage.ref().child('profile_images');
  static Reference get _chatImages => _storage.ref().child('chat_images');
  static Reference get _chatVideos => _storage.ref().child('chat_videos');
  static Reference get _chatDocuments => _storage.ref().child('chat_documents');
  static Reference get _chatAudio => _storage.ref().child('chat_audio');
  static Reference get _statusImages => _storage.ref().child('status_images');
  static Reference get _statusVideos => _storage.ref().child('status_videos');
  static Reference get _groupImages => _storage.ref().child('group_images');

  // ==================== PROFILE IMAGES ====================

  /// Upload profile image
  static Future<String> uploadProfileImage({
    required String uid,
    required String imagePath,
  }) async {
    try {
      final file = File(imagePath);
      final fileName = '${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _profileImages.child(fileName);
      
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      if (kDebugMode) {
        print('Profile image uploaded: $downloadUrl');
      }
      
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading profile image: $e');
      }
      rethrow;
    }
  }

  /// Upload profile image from XFile
  static Future<String> uploadProfileImageFromXFile({
    required String uid,
    required XFile imageFile,
  }) async {
    try {
      final fileName = '${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _profileImages.child(fileName);
      
      final uploadTask = ref.putFile(File(imageFile.path));
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      if (kDebugMode) {
        print('Profile image uploaded: $downloadUrl');
      }
      
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading profile image: $e');
      }
      rethrow;
    }
  }

  /// Upload profile picture (legacy method for compatibility)
  static Future<String> uploadProfilePicture({
    required String userId,
    required XFile imageFile,
  }) async {
    return uploadProfileImageFromXFile(uid: userId, imageFile: imageFile);
  }

  /// Delete profile image
  static Future<void> deleteProfileImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      
      if (kDebugMode) {
        print('Profile image deleted: $imageUrl');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting profile image: $e');
      }
      rethrow;
    }
  }

  // ==================== CHAT MEDIA ====================

  /// Upload chat image
  static Future<String> uploadChatImage({
    required String chatId,
    required String messageId,
    required XFile imageFile,
  }) async {
    try {
      final fileName = '${chatId}_${messageId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _chatImages.child(fileName);
      
      final uploadTask = ref.putFile(File(imageFile.path));
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      if (kDebugMode) {
        print('Chat image uploaded: $downloadUrl');
      }
      
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading chat image: $e');
      }
      rethrow;
    }
  }

  /// Upload chat video
  static Future<String> uploadChatVideo({
    required String chatId,
    required String messageId,
    required XFile videoFile,
  }) async {
    try {
      final fileName = '${chatId}_${messageId}_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final ref = _chatVideos.child(fileName);
      
      final uploadTask = ref.putFile(File(videoFile.path));
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      if (kDebugMode) {
        print('Chat video uploaded: $downloadUrl');
      }
      
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading chat video: $e');
      }
      rethrow;
    }
  }

  /// Upload chat document
  static Future<String> uploadChatDocument({
    required String chatId,
    required String messageId,
    required File documentFile,
    required String fileName,
  }) async {
    try {
      final fileExtension = fileName.split('.').last;
      final newFileName = '${chatId}_${messageId}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final ref = _chatDocuments.child(newFileName);
      
      final uploadTask = ref.putFile(documentFile);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      if (kDebugMode) {
        print('Chat document uploaded: $downloadUrl');
      }
      
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading chat document: $e');
      }
      rethrow;
    }
  }

  /// Upload audio message
  static Future<String> uploadAudioMessage({
    required String chatId,
    required String messageId,
    required File audioFile,
  }) async {
    try {
      final fileName = '${chatId}_${messageId}_${DateTime.now().millisecondsSinceEpoch}.m4a';
      final ref = _chatAudio.child(fileName);
      
      final uploadTask = ref.putFile(audioFile);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      if (kDebugMode) {
        print('Audio message uploaded: $downloadUrl');
      }
      
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading audio message: $e');
      }
      rethrow;
    }
  }

  // ==================== STATUS MEDIA ====================

  /// Upload status image
  static Future<String> uploadStatusImage({
    required String userId,
    required String statusId,
    required XFile imageFile,
  }) async {
    try {
      final fileName = '${userId}_${statusId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _statusImages.child(fileName);
      
      final uploadTask = ref.putFile(File(imageFile.path));
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      if (kDebugMode) {
        print('Status image uploaded: $downloadUrl');
      }
      
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading status image: $e');
      }
      rethrow;
    }
  }

  /// Upload status video
  static Future<String> uploadStatusVideo({
    required String userId,
    required String statusId,
    required XFile videoFile,
  }) async {
    try {
      final fileName = '${userId}_${statusId}_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final ref = _statusVideos.child(fileName);
      
      final uploadTask = ref.putFile(File(videoFile.path));
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      if (kDebugMode) {
        print('Status video uploaded: $downloadUrl');
      }
      
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading status video: $e');
      }
      rethrow;
    }
  }

  // ==================== GROUP MEDIA ====================

  /// Upload group image
  static Future<String> uploadGroupImage({
    required String groupId,
    required XFile imageFile,
  }) async {
    try {
      final fileName = '${groupId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _groupImages.child(fileName);
      
      final uploadTask = ref.putFile(File(imageFile.path));
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      if (kDebugMode) {
        print('Group image uploaded: $downloadUrl');
      }
      
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading group image: $e');
      }
      rethrow;
    }
  }

  // ==================== UTILITY METHODS ====================

  /// Get file size in bytes
  static Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      return await file.length();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting file size: $e');
      }
      return 0;
    }
  }

  /// Check if file size is within limits
  static bool isFileSizeValid(int fileSizeBytes, {int maxSizeMB = 10}) {
    final maxSizeBytes = maxSizeMB * 1024 * 1024;
    return fileSizeBytes <= maxSizeBytes;
  }

  /// Get file extension
  static String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  /// Check if file type is supported for images
  static bool isImageFile(String fileName) {
    final extension = getFileExtension(fileName);
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension);
  }

  /// Check if file type is supported for videos
  static bool isVideoFile(String fileName) {
    final extension = getFileExtension(fileName);
    return ['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm'].contains(extension);
  }

  /// Check if file type is supported for documents
  static bool isDocumentFile(String fileName) {
    final extension = getFileExtension(fileName);
    return ['pdf', 'doc', 'docx', 'txt', 'rtf', 'xls', 'xlsx', 'ppt', 'pptx'].contains(extension);
  }

  /// Check if file type is supported for audio
  static bool isAudioFile(String fileName) {
    final extension = getFileExtension(fileName);
    return ['mp3', 'wav', 'm4a', 'aac', 'ogg', 'flac'].contains(extension);
  }

  /// Delete file from storage
  static Future<void> deleteFile(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
      
      if (kDebugMode) {
        print('File deleted: $downloadUrl');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting file: $e');
      }
      rethrow;
    }
  }

  /// Get file metadata
  static Future<FullMetadata?> getFileMetadata(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      return await ref.getMetadata();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting file metadata: $e');
      }
      return null;
    }
  }

  /// Get download URL for a file
  static Future<String> getDownloadUrl(String filePath) async {
    try {
      final ref = _storage.ref().child(filePath);
      return await ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting download URL: $e');
      }
      rethrow;
    }
  }

  /// Upload file with progress tracking
  static Future<String> uploadFileWithProgress({
    required Reference ref,
    required File file,
    required Function(double progress) onProgress,
  }) async {
    try {
      final uploadTask = ref.putFile(file);
      
      uploadTask.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress(progress);
      });
      
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading file with progress: $e');
      }
      rethrow;
    }
  }
}
