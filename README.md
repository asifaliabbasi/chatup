# ChatUp - Firebase Integrated Chat App

A complete Flutter chat application with Firebase backend integration, featuring real-time messaging, phone authentication, media sharing, and push notifications.

## Features

### 🔐 Authentication
- **Phone Number Authentication**: OTP-based login using Firebase Auth
- **Profile Setup**: Complete user profile with name, status, and profile picture
- **Secure Authentication**: Firebase security rules for data protection

### 💬 Real-time Chat
- **Text Messages**: Send and receive text messages in real-time
- **Media Sharing**: Share images, videos, documents, and audio messages
- **Message Status**: Read/unread status tracking
- **Offline Support**: Messages cached for offline viewing

### 📱 Push Notifications
- **Firebase Cloud Messaging**: Real-time notifications for new messages
- **Background Handling**: Notifications work when app is closed
- **Custom Notifications**: Different notification types for different message types

### 🎨 Modern UI
- **Dark/Light Theme**: Toggle between themes
- **Responsive Design**: Works on all screen sizes
- **Smooth Animations**: Fluid user experience
- **Material Design**: Following Material Design guidelines

## Firebase Services Used

- **Firebase Auth**: Phone number authentication
- **Cloud Firestore**: Real-time database for messages and user profiles
- **Firebase Storage**: File storage for media and profile pictures
- **Firebase Cloud Messaging**: Push notifications
- **Firebase Security Rules**: Data protection and access control

## Setup Instructions

### 1. Firebase Project Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use an existing one
3. Enable the following services:
   - Authentication (Phone provider)
   - Firestore Database
   - Storage
   - Cloud Messaging

### 2. Android Configuration

1. Add your Android app to Firebase project
2. Download `google-services.json` file
3. Place it in `android/app/` directory
4. Update `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```
5. Update `android/build.gradle`:
   ```gradle
   dependencies {
       classpath 'com.google.gms:google-services:4.3.15'
   }
   ```

### 3. Update Firebase Configuration

1. Open `lib/firebase_options.dart`
2. Replace placeholder values with your actual Firebase project configuration:
   ```dart
   static const FirebaseOptions android = FirebaseOptions(
     apiKey: 'your-android-api-key',
     appId: 'your-android-app-id',
     messagingSenderId: 'your-sender-id',
     projectId: 'your-project-id',
     storageBucket: 'your-project-id.appspot.com',
   );
   ```

### 4. Install Dependencies

```bash
flutter pub get
```

### 5. Deploy Security Rules

1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```

2. Login to Firebase:
   ```bash
   firebase login
   ```

3. Initialize Firebase in your project:
   ```bash
   firebase init
   ```

4. Deploy Firestore rules:
   ```bash
   firebase deploy --only firestore:rules
   ```

5. Deploy Storage rules:
   ```bash
   firebase deploy --only storage
   ```

### 6. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point with Firebase initialization
├── firebase_options.dart     # Firebase configuration
├── models/                   # Data models
│   ├── message.dart         # Message model
│   └── chat.dart           # Chat model
├── services/               # Firebase services
│   ├── firebase_service.dart    # Main Firebase service
│   ├── auth_service.dart        # Authentication service
│   ├── firestore_service.dart   # Firestore operations
│   ├── storage_service.dart     # Storage operations
│   └── fcm_service.dart         # Push notifications
├── providers/              # State management
│   ├── auth_provider.dart      # Authentication state
│   ├── chat_provider.dart      # Chat state
│   └── theme_provider.dart     # Theme state
└── screens/                # UI screens
    ├── splash_screen.dart      # App splash screen
    ├── phone_login_screen.dart  # Phone login
    ├── otp_verification_screen.dart # OTP verification
    ├── profile_setup_screen.dart    # Profile setup
    └── chatup_home.dart        # Main app screen
```

## Key Features Implementation

### Authentication Flow
1. User enters phone number
2. Firebase sends OTP
3. User verifies OTP
4. Profile setup for new users
5. Redirect to main app

### Real-time Messaging
- Firestore listeners for real-time updates
- Message types: text, image, video, document, audio
- Offline message caching
- Read status tracking

### Media Sharing
- Firebase Storage for file uploads
- Image compression and optimization
- File type validation
- Progress indicators for uploads

### Push Notifications
- FCM token management
- Background message handling
- Custom notification types
- Deep linking to specific chats

## Security Features

- **Firestore Rules**: Users can only access their own data and chats they participate in
- **Storage Rules**: Secure file uploads with authentication
- **Authentication**: Phone number verification required
- **Data Validation**: Input validation on all forms

## Performance Optimizations

- **Offline Support**: Firestore offline persistence
- **Image Caching**: Cached network images
- **Lazy Loading**: Efficient data loading
- **Query Optimization**: Indexed Firestore queries

## Testing

The app includes comprehensive error handling and validation:
- Phone number validation
- OTP verification
- Network error handling
- File upload error handling
- Authentication state management

## Troubleshooting

### Common Issues

1. **Firebase not initialized**: Check `firebase_options.dart` configuration
2. **Authentication errors**: Verify phone number format and Firebase Auth setup
3. **Storage upload fails**: Check Firebase Storage rules and permissions
4. **Push notifications not working**: Verify FCM setup and device permissions

### Debug Mode

Enable debug logging by setting `kDebugMode` to true in development.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the repository or contact the development team.

---

**Note**: Remember to replace all placeholder values in `firebase_options.dart` with your actual Firebase project configuration before running the app.