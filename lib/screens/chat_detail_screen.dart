import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';
import '../models/message.dart'; // Message model ko import karein
import '../providers/theme_provider.dart';
import 'chat_profile_screen.dart';

class ChatDetailScreen extends StatefulWidget {
  final UserModel contact; // Ab hum poora UserModel object receive karenge

  const ChatDetailScreen({
    super.key,
    required this.contact,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _chatId;

  @override
  void initState() {
    super.initState();
    // initState mein hi chat ko set up karein
    _setupChat();
  }

  void _setupChat() {
    // Providers ko access karein
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    final currentUser = authProvider.user;
    if (currentUser != null) {
      // Dono users ki UID ko sort karke ek unique chat ID banayein
      final participants = [currentUser.uid, widget.contact.uid]..sort();
      _chatId = participants.join('_');

      // ChatProvider ko batayein ke hum is chat ke messages dekhna chahte hain
      chatProvider.setCurrentChat(_chatId!);
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.user;

    if (text.isNotEmpty && _chatId != null && currentUser != null) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      chatProvider.sendTextMessage(
        chatId: _chatId!,
        receiverId: widget.contact.uid,
        text: text,
        senderId: currentUser.uid, // senderId ko yahan se pass karein
      );
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : const Color(0xFFECE5DD),
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // Yeh call ab theek kar di gayi hai
                builder: (_) => ChatProfileScreen(
                  contactName: widget.contact.name,
                  avatarUrl: widget.contact.profileImageUrl,
                  contactPhone: widget.contact.phone,
                  lastSeen: widget.contact.isOnline ? 'Online' : 'Offline',
                ),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.contact.profileImageUrl.isNotEmpty
                    ? widget.contact.profileImageUrl
                    : 'https://placehold.co/100x100/6200ea/white?text=${widget.contact.name[0]}'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contact.name,
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.contact.isOnline ? 'Online' : 'Offline', // Live status
                    style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.white70 : Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(icon: Icon(Icons.videocam, color: isDarkMode ? Colors.white : Colors.black), onPressed: () {}),
          IconButton(icon: Icon(Icons.call, color: isDarkMode ? Colors.white : Colors.black), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            // Consumer ka istemal karein taake messages list update ho
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                if (_chatId == null) {
                  return const Center(child: Text("Initializing chat..."));
                }

                // Messages ki live stream ke liye StreamBuilder
                return StreamBuilder<List<Message>>(
                  stream: chatProvider.getChatMessages(_chatId!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No messages yet. Say hi!"));
                    }

                    final messages = snapshot.data!;
                    return ListView.builder(
                      reverse: true, // Naye messages neeche aayein
                      padding: const EdgeInsets.all(12),
                      itemCount: messages.length,
                      itemBuilder: (_, index) {
                        final msg = messages[index];
                        final isMe = msg.senderId == authProvider.user?.uid;

                        // Message Bubble Widget
                        return _buildMessageBubble(msg, isMe, isDarkMode);
                      },
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(isDarkMode),
        ],
      ),
    );
  }

  // Message Bubble design karne ke liye alag widget
  Widget _buildMessageBubble(Message msg, bool isMe, bool isDarkMode) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe
              ? (isDarkMode ? const Color(0xFF005C4B) : const Color(0xFFD9FDD3))
              : (isDarkMode ? const Color(0xFF202C33) : Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              msg.text,
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              "${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}",
              style: TextStyle(
                fontSize: 10,
                color: isDarkMode ? Colors.white70 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Message input bar ke liye alag widget
  Widget _buildMessageInput(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              child: TextField(
                controller: _controller,
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.emoji_emotions_outlined, color: isDarkMode ? Colors.white70 : Colors.grey),
                    onPressed: () {},
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.attach_file, color: isDarkMode ? Colors.white70 : Colors.grey),
                    onPressed: () {},
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            onPressed: _sendMessage,
            backgroundColor: const Color(0xFF00A884),
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

