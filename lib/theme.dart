import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors
  static const Color primaryGreen = Color(0xFF3CDBA3);
  static const Color lightBackground = Colors.white;
  static const Color darkBackground = Colors.black;
  static const Color lightMessageReceived = Colors.white;
  static const Color darkMessageReceived = Color(0xFF1E1E1E);

  // Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      primaryColor: primaryGreen,
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        secondary: primaryGreen,
        surface: lightBackground,
        onSurface: Colors.black,
        onPrimary: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
        titleLarge: TextStyle(color: Colors.black),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }

  // Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: primaryGreen,
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: primaryGreen,
        secondary: primaryGreen,
        surface: darkBackground,
        onSurface: Colors.white,
        onPrimary: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  // Message bubble colors
  static Color getSentMessageColor(bool isDark) {
    return primaryGreen;
  }

  static Color getReceivedMessageColor(bool isDark) {
    return isDark ? darkMessageReceived : lightMessageReceived;
  }

  static Color getMessageTextColor(bool isDark, bool isSent) {
    return isSent ? Colors.white : (isDark ? Colors.white : Colors.black);
  }

  // Action button colors
  static Color getActionButtonColor() {
    return primaryGreen;
  }
}

// Theme extension for custom colors
class ChatUpColors extends ThemeExtension<ChatUpColors> {
  final Color sentMessage;
  final Color receivedMessage;
  final Color actionButton;

  const ChatUpColors({
    required this.sentMessage,
    required this.receivedMessage,
    required this.actionButton,
  });

  @override
  ChatUpColors copyWith({
    Color? sentMessage,
    Color? receivedMessage,
    Color? actionButton,
  }) {
    return ChatUpColors(
      sentMessage: sentMessage ?? this.sentMessage,
      receivedMessage: receivedMessage ?? this.receivedMessage,
      actionButton: actionButton ?? this.actionButton,
    );
  }

  @override
  ChatUpColors lerp(ThemeExtension<ChatUpColors>? other, double t) {
    if (other is! ChatUpColors) {
      return this;
    }
    return ChatUpColors(
      sentMessage: Color.lerp(sentMessage, other.sentMessage, t)!,
      receivedMessage: Color.lerp(receivedMessage, other.receivedMessage, t)!,
      actionButton: Color.lerp(actionButton, other.actionButton, t)!,
    );
  }
}
