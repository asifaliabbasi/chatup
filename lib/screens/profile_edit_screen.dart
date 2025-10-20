import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme.dart';

class ProfileEditScreen extends StatefulWidget {
  final String name;
  final String about;
  final String phone;
  final String link;
  final File? profileImage;

  const ProfileEditScreen({
    super.key,
    required this.name,
    required this.about,
    required this.phone,
    required this.link,
    this.profileImage,
  });

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late String name;
  late String about;
  late String phone;
  late String link;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    name = widget.name;
    about = widget.about;
    phone = widget.phone;
    link = widget.link;
    _profileImage = widget.profileImage;
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // compress a little for better performance
    );
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text("Edit Profile", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        actions: [
          TextButton(
            onPressed: () {
              // Return updated profile to parent screen
              Navigator.pop(context, {
                "name": name,
                "about": about,
                "phone": phone,
                "link": link,
                "image": _profileImage, // << important: pass updated file
              });
            },
            child: Text("Save", style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey.shade300,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const AssetImage("assets/images/profile.png")
                  as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      backgroundColor: AppTheme.primaryGreen,
                      radius: 20,
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          buildEditableField("Name", name, (val) => setState(() => name = val), isDarkMode),
          buildEditableField("About", about, (val) => setState(() => about = val), isDarkMode),
          buildEditableField("Phone", phone, (val) => setState(() => phone = val), isDarkMode),
          buildEditableField("Link", link, (val) => setState(() => link = val), isDarkMode),
        ],
      ),
    );
  }

  Widget buildEditableField(
      String label, String value, Function(String) onChanged, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: value,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54),
              filled: true,
              fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
