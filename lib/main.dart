import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Your local imports
import 'firebase_options.dart';
import 'theme.dart';
import 'providers/theme_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/auth_provider.dart' as auth_provider;
import 'screens/splash_screen.dart';
import 'screens/chatup_home.dart';
import 'screens/phone_login_screen.dart';
import 'screens/otp_verification_screen.dart';

/// ===============================
/// ENTRY POINT
/// ===============================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ChatUpApp());
}

/// ===============================
/// MAIN APP WIDGET
/// ===============================
class ChatUpApp extends StatelessWidget {
  const ChatUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => auth_provider.AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'ChatUp',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            // AuthGate will check login state
            home: const AuthGate(),

            // Define routes for navigation
            routes: {
              '/login': (_) => const PhoneLoginScreen(),
              '/verify': (_) => const OTPVerificationScreen(),
              '/home': (_) => const WhatsAppHome(),
            },
          );
        },
      ),
    );
  }
}

/// ===============================
/// AUTH GATE (Check User Status)
/// ===============================
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1️⃣ While Firebase checks the auth state, show splash
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // 2️⃣ If user is logged in → Go to Home
        if (snapshot.hasData) {
          return const WhatsAppHome();
        }

        // 3️⃣ If user not logged in → Show Login screen
        return const PhoneLoginScreen();
      },
    );
  }
}
