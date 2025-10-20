import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class MediaGalleryScreen extends StatefulWidget {
  final String contactName;
  final String avatarUrl;

  const MediaGalleryScreen({
    super.key,
    required this.contactName,
    required this.avatarUrl,
  });

  @override
  State<MediaGalleryScreen> createState() => _MediaGalleryScreenState();
}

class _MediaGalleryScreenState extends State<MediaGalleryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> _photos = [];
  List<Map<String, dynamic>> _videos = [];
  List<Map<String, dynamic>> _documents = [];
  List<Map<String, dynamic>> _audio = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadMedia();
  }

  Future<void> _loadMedia() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _photos = [
        {
          'url': prefs.getString('photo1') ?? 'https://picsum.photos/300/300?random=1',
          'date': 'Today',
          'size': '2.1 MB',
        },
        {
          'url': 'https://picsum.photos/300/300?random=2',
          'date': 'Yesterday',
          'size': '1.8 MB',
        },
        {
          'url': 'https://picsum.photos/300/300?random=3',
          'date': '2 days ago',
          'size': '3.2 MB',
        },
      ];

      _videos = [
        {
          'url': 'https://picsum.photos/300/300?random=6',
          'date': 'Today',
          'size': '15.2 MB',
          'duration': '0:32',
        },
        {
          'url': 'https://picsum.photos/300/300?random=7',
          'date': 'Yesterday',
          'size': '28.7 MB',
          'duration': '1:15',
        },
      ];

      _documents = [
        {
          'name': 'Document.pdf',
          'date': 'Today',
          'size': '2.1 MB',
          'icon': Icons.picture_as_pdf,
          'color': Colors.red,
        },
        {
          'name': 'Presentation.pptx',
          'date': 'Yesterday',
          'size': '5.8 MB',
          'icon': Icons.slideshow,
          'color': Colors.orange,
        },
      ];

      _audio = [
        {
          'name': 'Voice Message 1',
          'date': 'Today',
          'size': '1.2 MB',
          'duration': '0:45',
        },
        {
          'name': 'Voice Message 2',
          'date': 'Yesterday',
          'size': '2.8 MB',
          'duration': '1:32',
        },
      ];
    });
  }

  void _deleteMedia(Map<String, dynamic> media, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Media'),
        content: Text('Are you sure you want to delete this $type?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                if (type == 'photo') _photos.remove(media);
                if (type == 'video') _videos.remove(media);
                if (type == 'audio') _audio.remove(media);
                if (type == 'document') _documents.remove(media);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$type deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showMediaOptions(Map<String, dynamic> media, String type) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.share, color: Colors.blue),
            title: const Text('Share'),
            onTap: () {
              Navigator.pop(context);
              _shareMedia(media, type);
            },
          ),
          ListTile(
            leading: const Icon(Icons.download, color: Colors.green),
            title: const Text('Save to Gallery'),
            onTap: () {
              Navigator.pop(context);
              _saveMedia(media, type);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete'),
            onTap: () {
              Navigator.pop(context);
              _deleteMedia(media, type);
            },
          ),
        ],
      ),
    );
  }

  void _shareMedia(Map<String, dynamic> media, String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing $type...')),
    );
  }

  void _saveMedia(Map<String, dynamic> media, String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$type saved to gallery')),
    );
  }

  void _showFullScreenMedia(Map<String, dynamic> media) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(10),
        backgroundColor: Colors.black,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(
              child: _buildMediaImage(media['url']),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaImage(String? url) {
    if (url == null) {
      return Container(color: Colors.grey, height: 400);
    }
    if (url.startsWith('http')) {
      return Image.network(url, width: double.infinity, height: 400, fit: BoxFit.cover);
    } else {
      return Image.file(File(url), width: double.infinity, height: 400, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.contactName} Media'),
        backgroundColor: const Color(0xFF075E54),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(icon: const Icon(Icons.photo), text: 'Photos (${_photos.length})'),
            Tab(icon: const Icon(Icons.video_library), text: 'Videos (${_videos.length})'),
            Tab(icon: const Icon(Icons.audiotrack), text: 'Audio (${_audio.length})'),
            Tab(icon: const Icon(Icons.insert_drive_file), text: 'Docs (${_documents.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPhotosTab(),
          _buildVideosTab(),
          _buildAudioTab(),
          _buildDocumentsTab(),
        ],
      ),
    );
  }

  // ======================= TABS =======================

  Widget _buildPhotosTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _photos.length,
      itemBuilder: (context, index) {
        final photo = _photos[index];
        return GestureDetector(
          onTap: () => _showFullScreenMedia(photo),
          onLongPress: () => _showMediaOptions(photo, 'photo'),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildMediaImage(photo['url']),
          ),
        );
      },
    );
  }

  Widget _buildVideosTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        final video = _videos[index];
        return GestureDetector(
          onTap: () => _showFullScreenMedia(video),
          onLongPress: () => _showMediaOptions(video, 'video'),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildMediaImage(video['url']),
              ),
              Container(
                color: Colors.black26,
                child: const Icon(Icons.play_circle_fill, color: Colors.white, size: 40),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAudioTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _audio.length,
      itemBuilder: (context, index) {
        final audio = _audio[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.audiotrack, color: Color(0xFF075E54)),
            title: Text(audio['name'] ?? ''),
            subtitle: Text('${audio['duration']} • ${audio['size']}'),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showMediaOptions(audio, 'audio'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDocumentsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _documents.length,
      itemBuilder: (context, index) {
        final doc = _documents[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: Icon(doc['icon'], color: doc['color']),
            title: Text(doc['name'] ?? ''),
            subtitle: Text('${doc['size']} • ${doc['date']}'),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showMediaOptions(doc, 'document'),
            ),
          ),
        );
      },
    );
  }
}
