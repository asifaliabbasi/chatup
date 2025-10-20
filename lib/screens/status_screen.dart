import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'status_view_screen.dart';
import '../providers/theme_provider.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> myStatuses = [];

  List<Map<String, dynamic>> dummyStatuses = [
    {
      'name': 'Ali',
      'media': [
        'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
        'https://picsum.photos/400/700?random=21'
      ],
      'timestamp': DateTime.now().subtract(const Duration(minutes: 10)),
      'expiresAt': DateTime.now().add(const Duration(hours: 24)),
      'viewed': false,
      'avatar': 'https://randomuser.me/api/portraits/men/31.jpg',
    },
    {
      'name': 'Aisha',
      'media': [
        'https://sample-videos.com/video123/mp4/720/sample-mp4-file.mp4'
      ],
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'expiresAt': DateTime.now().add(const Duration(hours: 24)),
      'viewed': false,
      'avatar': 'https://randomuser.me/api/portraits/women/29.jpg',
    },
    {
      'name': 'Usman',
      'media': [
        'https://picsum.photos/400/700?random=12'
      ],
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'expiresAt': DateTime.now().add(const Duration(hours: 24)),
      'viewed': false,
      'avatar': 'https://randomuser.me/api/portraits/men/22.jpg',
    },
    {
      'name': 'Hira',
      'media': [
        'https://picsum.photos/400/700?random=17'
      ],
      'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
      'expiresAt': DateTime.now().add(const Duration(hours: 24)),
      'viewed': false,
      'avatar': 'https://randomuser.me/api/portraits/women/23.jpg',
    },
    {
      'name': 'Zain',
      'media': [
        'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4'
      ],
      'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
      'expiresAt': DateTime.now().add(const Duration(hours: 24)),
      'viewed': false,
      'avatar': 'https://randomuser.me/api/portraits/men/28.jpg',
    },
    {
      'name': 'Mehwish',
      'media': [
        'https://picsum.photos/400/700?random=19'
      ],
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'expiresAt': DateTime.now().add(const Duration(hours: 24)),
      'viewed': false,
      'avatar': 'https://randomuser.me/api/portraits/women/33.jpg',
    },
    {
      'name': 'Ahmed',
      'media': [
        'https://sample-videos.com/video123/mp4/720/sample-mp4-file.mp4'
      ],
      'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
      'expiresAt': DateTime.now().add(const Duration(hours: 24)),
      'viewed': false,
      'avatar': 'https://randomuser.me/api/portraits/men/34.jpg',
    },
  ];

  Future<void> _pickStatusImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        myStatuses.add({
          'imageBytes': bytes,
          'timestamp': DateTime.now(),
        });
      });
    }
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hrs ago';
    return '${diff.inDays} days ago';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    final latest = myStatuses.isNotEmpty ? myStatuses.last : null;

    final recent = dummyStatuses
        .where((s) => !s['viewed'] && s['expiresAt'].isAfter(DateTime.now()))
        .toList();

    final viewed = dummyStatuses
        .where((s) => s['viewed'] && s['expiresAt'].isAfter(DateTime.now()))
        .toList();

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white70,
      body: SafeArea(
        child: ListView(
          children: [
            // My Status Section
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                backgroundImage: latest != null ? MemoryImage(latest['imageBytes']) : null,
                child: latest == null
                    ? Icon(Icons.add, color: isDarkMode ? Colors.white70 : Colors.grey[600])
                    : null,
              ),
              title: Text(
                "My Status",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Text(
                latest == null ? "Tap to add status update" : _timeAgo(latest['timestamp']),
                style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
              ),
              onTap: () {
                if (myStatuses.isEmpty) {
                  _pickStatusImage();
                } else {
                  final images = myStatuses.map<Uint8List>((e) => e['imageBytes']).toList();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StatusViewScreen(
                        name: "My Status",
                        imageBytesList: images,
                      ),
                    ),
                  );
                }
              },
              onLongPress: () {
                if (myStatuses.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
                      title: Text(
                        "Delete My Status?",
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() => myStatuses.clear());
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),

            // Recent Updates Section
            if (recent.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  "Recent updates",
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey[600], 
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),

            ...recent.map((s) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(s['avatar']),
                ),
                title: Text(
                  s['name'],
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  _timeAgo(s['timestamp']),
                  style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey),
                ),
                onTap: () {
                  setState(() => s['viewed'] = true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StatusViewScreen(
                        name: s['name'],
                        mediaUrls: s['media'],
                      ),
                    ),
                  );
                },
              );
            }),

            // Viewed Updates Section
            if (viewed.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  "Viewed updates",
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey[600], 
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),

            ...viewed.map((s) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(s['avatar']),
                ),
                title: Text(
                  s['name'],
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  "Viewed",
                  style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StatusViewScreen(
                        name: s['name'],
                        mediaUrls: s['media'],
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
