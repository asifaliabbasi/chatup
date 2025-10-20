import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_detail_screen.dart';
import 'chat_profile_screen.dart'; // ChatProfileScreen ko import karein
import '../providers/theme_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';

class ChatScreen extends StatefulWidget {
  final String searchText;
  const ChatScreen({super.key, required this.searchText});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final chatProvider = Provider.of<ChatProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return StreamBuilder<List<UserModel>>(
      stream: chatProvider.getUsersStream(authProvider.user?.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey)));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              "No contacts found",
              style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey),
            ),
          );
        }

        final users = snapshot.data!;
        final filteredUsers = users.where((user) {
          final query = widget.searchText.toLowerCase();
          return user.name.toLowerCase().contains(query) || user.phone.contains(query);
        }).toList();

        if (filteredUsers.isEmpty) {
          return Center(
            child: Text(
              "No contacts found for '${widget.searchText}'",
              style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            final user = filteredUsers[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: GestureDetector(
                onTap: () => _openContactOptions(user),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.profileImageUrl.isNotEmpty
                      ? user.profileImageUrl
                      : 'https://placehold.co/100x100/6200ea/white?text=${user.name[0]}'),
                ),
              ),
              title: Text(
                user.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Text(
                user.status,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey),
              ),
              trailing: Text(
                "10:30 PM", // Yeh baad mein last message time se replace hoga
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.white70 : Colors.grey,
                ),
              ),
              onTap: () => _openChatDetail(user),
            );
          },
        );
      },
    );
  }

  void _openContactOptions(UserModel user) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.profileImageUrl.isNotEmpty ? user.profileImageUrl : 'https://placehold.co/100x100/6200ea/white?text=${user.name[0]}'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.phone,
                    style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.white70 : Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  _buildActionTile(icon: Icons.chat, title: 'Chat', onTap: () { Navigator.pop(context); _openChatDetail(user); }, isDarkMode: isDarkMode),
                  _buildActionTile(icon: Icons.videocam, title: 'Video Call', onTap: () { Navigator.pop(context); _showComingSoon('Video Call'); }, isDarkMode: isDarkMode),
                  _buildActionTile(icon: Icons.call, title: 'Audio Call', onTap: () { Navigator.pop(context); _showComingSoon('Audio Call'); }, isDarkMode: isDarkMode),
                  // "Info" button ke liye navigation ko theek kiya gaya hai
                  _buildActionTile(
                      icon: Icons.info_outline,
                      title: 'Info',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatProfileScreen(
                              contactName: user.name,
                              avatarUrl: user.profileImageUrl,
                              contactPhone: user.phone,
                              lastSeen: user.isOnline ? 'Online' : 'Offline',
                            ),
                          ),
                        );
                      },
                      isDarkMode: isDarkMode
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDarkMode ? Colors.white : Colors.black),
      title: Text(title, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$feature feature coming soon!')));
  }

  // === YAHAN PAR AHEM TABDEELI KI GAYI HAI ===
  void _openChatDetail(UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // Ab hum poora 'user' object pass kar rahe hain
        builder: (_) => ChatDetailScreen(
          contact: user,
        ),
      ),
    );
  }
}

