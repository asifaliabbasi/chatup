import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme.dart';
import 'media_links_docs_screen.dart';

class ChatProfileScreen extends StatefulWidget {
  final String contactName;
  final String contactPhone;
  final String avatarUrl;
  final String lastSeen;

  const ChatProfileScreen({
    super.key,
    required this.contactName,
    required this.contactPhone,
    required this.avatarUrl,
    required this.lastSeen,
  });

  @override
  State<ChatProfileScreen> createState() => _ChatProfileScreenState();
}

class _ChatProfileScreenState extends State<ChatProfileScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        title: Text(
          widget.contactName,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onSelected: (value) {
              switch (value) {
                case 'media':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MediaLinksDocsScreen(
                        contactName: widget.contactName,
                        contactPhone: widget.contactPhone,
                      ),
                    ),
                  );
                  break;
                case 'block':
                  _showBlockDialog();
                  break;
                case 'report':
                  _showReportDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'media',
                child: Row(
                  children: [
                    Icon(Icons.photo_library, color: isDarkMode ? Colors.white : Colors.black),
                    const SizedBox(width: 8),
                    Text('View Media', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'block',
                child: Row(
                  children: [
                    Icon(Icons.block, color: Colors.red),
                    const SizedBox(width: 8),
                    const Text('Block', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.report, color: Colors.red),
                    const SizedBox(width: 8),
                    const Text('Report', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearching)
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search messages...',
                  hintStyle: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54),
                  prefixIcon: Icon(Icons.search, color: isDarkMode ? Colors.white54 : Colors.black54),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          Expanded(
            child: ListView(
              children: [
                // Profile Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(widget.avatarUrl),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.contactName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.contactPhone,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.lastSeen,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white54 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Call Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCallButton(
                            icon: Icons.call,
                            label: 'Audio',
                            onTap: () => _makeCall('audio'),
                            isDarkMode: isDarkMode,
                          ),
                          _buildCallButton(
                            icon: Icons.videocam,
                            label: 'Video',
                            onTap: () => _makeCall('video'),
                            isDarkMode: isDarkMode,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Media, Links, Docs Section
                _buildSectionHeader('Media, Links, and Docs', isDarkMode),
                _buildMediaSection(isDarkMode),
                
                // Settings Section
                _buildSectionHeader('Settings', isDarkMode),
                _buildSettingsSection(isDarkMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.primaryGreen,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDarkMode ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }

  Widget _buildMediaSection(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildMediaItem(
            icon: Icons.photo_library,
            title: 'Media',
            subtitle: '12 photos, 3 videos',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MediaLinksDocsScreen(
                  contactName: widget.contactName,
                  contactPhone: widget.contactPhone,
                  initialTab: 0,
                ),
              ),
            ),
            isDarkMode: isDarkMode,
          ),
          _buildDivider(isDarkMode),
          _buildMediaItem(
            icon: Icons.link,
            title: 'Links',
            subtitle: '5 links',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MediaLinksDocsScreen(
                  contactName: widget.contactName,
                  contactPhone: widget.contactPhone,
                  initialTab: 1,
                ),
              ),
            ),
            isDarkMode: isDarkMode,
          ),
          _buildDivider(isDarkMode),
          _buildMediaItem(
            icon: Icons.insert_drive_file,
            title: 'Docs',
            subtitle: '2 documents',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MediaLinksDocsScreen(
                  contactName: widget.contactName,
                  contactPhone: widget.contactPhone,
                  initialTab: 2,
                ),
              ),
            ),
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildMediaItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryGreen),
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: isDarkMode ? Colors.white54 : Colors.black54,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(left: 56),
      height: 0.5,
      color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
    );
  }

  Widget _buildSettingsSection(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildSettingItem(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () => _showNotificationSettings(),
            isDarkMode: isDarkMode,
          ),
          _buildDivider(isDarkMode),
          _buildSettingItem(
            icon: Icons.visibility,
            title: 'Media Visibility',
            onTap: () => _showMediaVisibilitySettings(),
            isDarkMode: isDarkMode,
          ),
          _buildDivider(isDarkMode),
          _buildSettingItem(
            icon: Icons.lock,
            title: 'Encryption',
            subtitle: 'Messages and calls are end-to-end encrypted',
            onTap: () => _showEncryptionInfo(),
            isDarkMode: isDarkMode,
          ),
          _buildDivider(isDarkMode),
          _buildSettingItem(
            icon: Icons.timer,
            title: 'Disappearing Messages',
            onTap: () => _showDisappearingMessagesSettings(),
            isDarkMode: isDarkMode,
          ),
          _buildDivider(isDarkMode),
          _buildSettingItem(
            icon: Icons.lock_outline,
            title: 'Chat Lock',
            onTap: () => _showChatLockSettings(),
            isDarkMode: isDarkMode,
          ),
          _buildDivider(isDarkMode),
          _buildSettingItem(
            icon: Icons.block,
            title: 'Block',
            textColor: Colors.red,
            onTap: () => _showBlockDialog(),
            isDarkMode: isDarkMode,
          ),
          _buildDivider(isDarkMode),
          _buildSettingItem(
            icon: Icons.report,
            title: 'Report',
            textColor: Colors.red,
            onTap: () => _showReportDialog(),
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? textColor,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppTheme.primaryGreen),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? (isDarkMode ? Colors.white : Colors.black),
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black54,
                fontSize: 12,
              ),
            )
          : null,
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: isDarkMode ? Colors.white54 : Colors.black54,
      ),
      onTap: onTap,
    );
  }

  void _makeCall(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${type.toUpperCase()} call to ${widget.contactName}'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }

  void _showNotificationSettings() {
    // TODO: Implement notification settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification settings coming soon!')),
    );
  }

  void _showMediaVisibilitySettings() {
    // TODO: Implement media visibility settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Media visibility settings coming soon!')),
    );
  }

  void _showEncryptionInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Encryption'),
        content: const Text('Messages and calls are end-to-end encrypted. No one outside of this chat, not even WhatsApp, can read or listen to them.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDisappearingMessagesSettings() {
    // TODO: Implement disappearing messages settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Disappearing messages settings coming soon!')),
    );
  }

  void _showChatLockSettings() {
    // TODO: Implement chat lock settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chat lock settings coming soon!')),
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Block ${widget.contactName}?'),
        content: Text('${widget.contactName} will no longer be able to call you or send you messages.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${widget.contactName} has been blocked')),
              );
            },
            child: const Text('Block', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report ${widget.contactName}?'),
        content: const Text('This contact will be reported to WhatsApp for review.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${widget.contactName} has been reported')),
              );
            },
            child: const Text('Report', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
