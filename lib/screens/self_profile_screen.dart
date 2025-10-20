import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class SelfProfileScreen extends StatefulWidget {
  final String currentAvatar;

  const SelfProfileScreen({super.key, required this.currentAvatar});

  @override
  State<SelfProfileScreen> createState() => _SelfProfileScreenState();
}

class _SelfProfileScreenState extends State<SelfProfileScreen> {
  File? newAvatar;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('self_avatar', picked.path);
      setState(() => newAvatar = file);
    }
  }

  Future<String?> loadSavedAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('self_avatar');
  }

  @override
  void initState() {
    super.initState();
    loadSavedAvatar().then((path) {
      if (path != null) setState(() => newAvatar = File(path));
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayImage = newAvatar != null
        ? FileImage(newAvatar!)
        : NetworkImage(widget.currentAvatar) as ImageProvider;

    return Scaffold(
      backgroundColor: Colors.white, // ✅ match splash background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white, // ✅ splash style appbar
        foregroundColor: Colors.black,
        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Avatar with edit option
            GestureDetector(
              onTap: pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: displayImage,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.green, // ✅ green accent
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: const Icon(Icons.edit, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Name
            const Text(
              "You (Saved Messages)",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black, // ✅ splash style text
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Personal profile",
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // Info Cards
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const ListTile(
                leading: Icon(Icons.info, color: Colors.green), // ✅ green accent
                title: Text("Status"),
                subtitle: Text("Hey there! I’m using ChatUp"),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const ListTile(
                leading: Icon(Icons.phone, color: Colors.green), // ✅ green accent
                title: Text("Phone"),
                subtitle: Text("03001234567"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
