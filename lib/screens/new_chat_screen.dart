import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_detail_screen.dart';
import 'chat_profile_screen.dart'; // Isay import karein
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../models/user_model.dart';
import '../theme.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final chatProvider = Provider.of<ChatProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          "Select Contact",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: "Search by name or number",
                hintStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
                prefixIcon: Icon(Icons.search, color: AppTheme.primaryGreen),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                setState(() => _searchQuery = val);
              },
            ),
          ),

          // Create Group Shortcut
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryGreen,
              child: const Icon(Icons.group, color: Colors.white),
            ),
            title: Text(
              "Create Group",
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) => const CreateGroupScreen()),
              // );
            },
          ),

          // Contacts List
          Expanded(
            child: StreamBuilder<List<UserModel>>(
              stream: chatProvider.getUsersStream(authProvider.user?.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No contacts found."));
                }

                final users = snapshot.data!;
                final filteredUsers = users.where((user) {
                  final query = _searchQuery.toLowerCase();
                  return user.name.toLowerCase().contains(query) || user.phone.contains(query);
                }).toList();

                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (_, index) {
                    final user = filteredUsers[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: GestureDetector(
                        onTap: () {
                          // Profile screen par bhejne ke liye
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
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.profileImageUrl.isNotEmpty
                              ? user.profileImageUrl
                              : 'https://placehold.co/100x100/6200ea/white?text=${user.name[0]}'),
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        user.status,
                        style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey),
                      ),
                      onTap: () {
                        // Chat Detail Screen par bhejne ke liye
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatDetailScreen(
                              contact: user, // Pura UserModel object pass karein
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
