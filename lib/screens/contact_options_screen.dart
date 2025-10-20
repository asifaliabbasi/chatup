import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../providers/theme_provider.dart';
import 'chat_detail_screen.dart';

class ContactOptionsScreen extends StatefulWidget {
  // Ab hum poora UserModel object receive karenge
  final UserModel contact;

  const ContactOptionsScreen({
    super.key,
    required this.contact,
  });

  @override
  State<ContactOptionsScreen> createState() => _ContactOptionsScreenState();
}

class _ContactOptionsScreenState extends State<ContactOptionsScreen> {
  bool isBlocked = false;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    _loadContactSettings();
  }

  void _loadContactSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isBlocked = prefs.getBool('${widget.contact.phone}_blocked') ?? false;
      isMuted = prefs.getBool('${widget.contact.phone}_muted') ?? false;
    });
  }

  void _toggleBlock() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => isBlocked = !isBlocked);
    await prefs.setBool('${widget.contact.phone}_blocked', isBlocked);
    _showSnack(
      isBlocked
          ? '${widget.contact.name} has been blocked'
          : '${widget.contact.name} has been unblocked',
      isBlocked ? Colors.red : Colors.green,
    );
  }

  void _toggleMute() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => isMuted = !isMuted);
    await prefs.setBool('${widget.contact.phone}_muted', isMuted);
    _showSnack(
      isMuted
          ? '${widget.contact.name} has been muted'
          : '${widget.contact.name} has been unmuted',
      isMuted ? Colors.orange : Colors.green,
    );
  }

  void _showSnack(String message, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  void _startChat() {
    // ChatDetailScreen ko ab poora 'contact' object pass karein
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetailScreen(
          contact: widget.contact,
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? color,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Card(
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: Icon(icon, color: color ?? (isDarkMode ? Colors.white70 : Colors.blueGrey)),
        title: Text(title, style: TextStyle(color: color ?? (isDarkMode ? Colors.white : Colors.black))),
        subtitle: subtitle != null ? Text(subtitle) : null,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.contact.name),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.contact.profileImageUrl.isNotEmpty
                      ? widget.contact.profileImageUrl
                      : 'https://placehold.co/100x100/6200ea/white?text=${widget.contact.name[0]}'),
                  radius: 50,
                ),
                const SizedBox(height: 10),
                Text(widget.contact.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                Text(widget.contact.phone, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _buildActionTile(
                  icon: Icons.chat,
                  title: 'Start Chat',
                  subtitle: 'Send a message',
                  color: Colors.green,
                  onTap: _startChat,
                ),
                _buildActionTile(
                  icon: isBlocked ? Icons.block : Icons.block_outlined,
                  title: isBlocked ? 'Unblock Contact' : 'Block Contact',
                  subtitle: isBlocked ? 'Unblock to receive messages' : 'Block to stop receiving messages',
                  color: isBlocked ? Colors.red : null,
                  onTap: _toggleBlock,
                ),
                _buildActionTile(
                  icon: isMuted ? Icons.volume_off : Icons.volume_up,
                  title: isMuted ? 'Unmute Contact' : 'Mute Contact',
                  subtitle: isMuted ? 'Unmute to receive notifications' : 'Mute to stop notifications',
                  color: isMuted ? Colors.orange : null,
                  onTap: _toggleMute,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

