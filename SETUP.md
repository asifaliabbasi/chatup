# ChatUp Firebase Setup Script

## Prerequisites
1. Flutter SDK installed
2. Firebase CLI installed
3. Android Studio or VS Code with Flutter extensions

## Setup Steps

### 1. Firebase Project Setup
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named "chatup" (or your preferred name)
3. Enable the following services:
   - Authentication (Phone provider)
   - Firestore Database
   - Storage
   - Cloud Messaging

### 2. Android App Configuration
1. In Firebase Console, click "Add app" and select Android
2. Package name: `com.example.chatup`
3. Download `google-services.json`
4. Place it in `android/app/` directory (replace the template file)

### 3. Update Firebase Configuration
1. Open `lib/firebase_options.dart`
2. Replace all placeholder values with your actual Firebase project configuration
3. You can get these values from Firebase Console > Project Settings > General

### 4. Install Dependencies
```bash
flutter clean
flutter pub get
```

### 5. Deploy Security Rules
```bash
# Install Firebase CLI if not already installed
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in your project
firebase init

# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Storage rules
firebase deploy --only storage
```

### 6. Test the App
```bash
flutter run
```

## Troubleshooting

### Common Issues:
1. **Firebase not initialized**: Check `firebase_options.dart` configuration
2. **Authentication errors**: Verify phone number format and Firebase Auth setup
3. **Storage upload fails**: Check Firebase Storage rules and permissions
4. **Push notifications not working**: Verify FCM setup and device permissions

### Debug Steps:
1. Check Firebase Console for any error logs
2. Verify all services are enabled in Firebase Console
3. Ensure `google-services.json` is in the correct location
4. Check that all dependencies are properly installed

## Features Implemented

✅ **Firebase Authentication**: Phone number OTP verification
✅ **Cloud Firestore**: Real-time database for messages and profiles
✅ **Firebase Storage**: File storage for media and profile pictures
✅ **Firebase Cloud Messaging**: Push notifications
✅ **Security Rules**: Secure data access control
✅ **Offline Support**: Firestore offline persistence
✅ **State Management**: Provider pattern for app state
✅ **Modern UI**: Material Design with dark/light themes

## Next Steps

1. Replace placeholder values in `firebase_options.dart`
2. Add your `google-services.json` file
3. Deploy security rules to Firebase
4. Test the app with real Firebase project
5. Customize UI and add additional features as needed

## Support

If you encounter any issues:
1. Check the README.md for detailed instructions
2. Verify Firebase Console configuration
3. Check Flutter and Firebase documentation
4. Open an issue in the repository
