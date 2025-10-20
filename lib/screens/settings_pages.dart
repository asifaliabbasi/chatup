import 'package:flutter/material.dart';

/// -------------------- ACCOUNT --------------------
class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account")),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.security),
            title: Text("Security notifications"),
            subtitle: Text("Get notified when your security code changes"),
          ),
          ListTile(
            leading: Icon(Icons.phonelink_setup),
            title: Text("Change number"),
            subtitle: Text("Change your account phone number"),
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Two-step verification"),
            subtitle: Text("Add extra security to your account"),
          ),
          ListTile(
            leading: Icon(Icons.block),
            title: Text("Blocked contacts"),
            subtitle: Text("View or manage blocked users"),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever),
            title: Text("Delete my account"),
            subtitle: Text("Permanently delete your account"),
          ),
        ],
      ),
    );
  }
}

/// -------------------- PRIVACY --------------------
class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool readReceipts = true;
  String lastSeen = "Everyone";
  String profilePhoto = "Everyone";
  bool statusVisibility = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy")),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text("Last seen & online"),
            subtitle: Text(lastSeen),
            onTap: () {
              setState(() {
                lastSeen = lastSeen == "Everyone" ? "Nobody" : "Everyone";
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text("Profile photo"),
            subtitle: Text(profilePhoto),
            onTap: () {
              setState(() {
                profilePhoto = profilePhoto == "Everyone" ? "My Contacts" : "Everyone";
              });
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.done_all),
            title: const Text("Read receipts"),
            subtitle: const Text("If turned off, you won’t send or receive read receipts."),
            value: readReceipts,
            onChanged: (value) {
              setState(() => readReceipts = value);
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.visibility),
            title: const Text("Status visibility"),
            subtitle: const Text("Control who can see your status updates"),
            value: statusVisibility,
            onChanged: (value) {
              setState(() => statusVisibility = value);
            },
          ),
        ],
      ),
    );
  }
}

/// -------------------- CHATS --------------------
class ChatSettingsScreen extends StatefulWidget {
  const ChatSettingsScreen({super.key});

  @override
  State<ChatSettingsScreen> createState() => _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends State<ChatSettingsScreen> {
  bool enterIsSend = false;
  bool mediaVisibility = true;
  String theme = "System default";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chats")),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.keyboard_return),
            title: const Text("Enter is send"),
            subtitle: const Text("Pressing enter will send your message"),
            value: enterIsSend,
            onChanged: (val) => setState(() => enterIsSend = val),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.photo_library),
            title: const Text("Media visibility"),
            subtitle: const Text("Show newly downloaded media in your gallery"),
            value: mediaVisibility,
            onChanged: (val) => setState(() => mediaVisibility = val),
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text("Theme"),
            subtitle: Text(theme),
            onTap: () {
              setState(() {
                theme = theme == "System default"
                    ? "Dark"
                    : theme == "Dark"
                    ? "Light"
                    : "System default";
              });
            },
          ),
          const ListTile(
            leading: Icon(Icons.backup),
            title: Text("Chat backup"),
            subtitle: Text("Backup your chat history to cloud"),
          ),
        ],
      ),
    );
  }
}

/// -------------------- NOTIFICATIONS --------------------
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool messageTones = true;
  bool vibrate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.message),
            title: const Text("Message tones"),
            value: messageTones,
            onChanged: (val) => setState(() => messageTones = val),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.vibration),
            title: const Text("Vibrate"),
            value: vibrate,
            onChanged: (val) => setState(() => vibrate = val),
          ),
          const ListTile(
            leading: Icon(Icons.volume_up),
            title: Text("Ringtone"),
            subtitle: Text("Default (Ping)"),
          ),
          const ListTile(
            leading: Icon(Icons.music_note),
            title: Text("Custom notification tones"),
            subtitle: Text("Set different tones for chats"),
          ),
        ],
      ),
    );
  }
}

/// -------------------- STORAGE --------------------
class StorageSettingsScreen extends StatefulWidget {
  const StorageSettingsScreen({super.key});

  @override
  State<StorageSettingsScreen> createState() => _StorageSettingsScreenState();
}

class _StorageSettingsScreenState extends State<StorageSettingsScreen> {
  bool autoDownload = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Storage and Data")),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.download),
            title: const Text("Media auto-download"),
            subtitle: const Text("Download photos automatically"),
            value: autoDownload,
            onChanged: (val) => setState(() => autoDownload = val),
          ),
          const ListTile(
            leading: Icon(Icons.data_usage),
            title: Text("Network usage"),
            subtitle: Text("View sent & received data"),
          ),
          const ListTile(
            leading: Icon(Icons.cleaning_services),
            title: Text("Storage cleaner"),
            subtitle: Text("Free up space by clearing cache"),
          ),
        ],
      ),
    );
  }
}

/// -------------------- HELP --------------------
class HelpSettingsScreen extends StatelessWidget {
  const HelpSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help")),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Help Center"),
            subtitle: Text("Get answers to your questions"),
          ),
          ListTile(
            leading: Icon(Icons.contact_support),
            title: Text("Contact Us"),
            subtitle: Text("Reach out for support"),
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text("FAQs"),
            subtitle: Text("Frequently asked questions"),
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text("Privacy Policy"),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("About App"),
            subtitle: Text("Version 1.0.0 • Developed by You"),
          ),
        ],
      ),
    );
  }
}

/// -------------------- INVITE --------------------
class InviteFriendScreen extends StatelessWidget {
  const InviteFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Invite a Friend")),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.share),
          label: const Text("Share Invite Link"),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Invite link shared!")),
            );
          },
        ),
      ),
    );
  }
}
