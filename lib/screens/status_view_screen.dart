import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StatusViewScreen extends StatefulWidget {
  final String name;
  final List<String>? mediaUrls; // For dummy contacts
  final List<Uint8List>? imageBytesList; // For "My Status"

  const StatusViewScreen({
    super.key,
    required this.name,
    this.mediaUrls,
    this.imageBytesList,
  });

  @override
  State<StatusViewScreen> createState() => _StatusViewScreenState();
}

class _StatusViewScreenState extends State<StatusViewScreen> {
  PageController pageController = PageController();
  int currentIndex = 0;
  List<double> progressList = [];
  List<dynamic> mediaList = [];

  VideoPlayerController? videoController;
  Timer? imageTimer;
  bool isVideo = false;

  @override
  void initState() {
    super.initState();

    if (widget.imageBytesList != null) {
      mediaList = widget.imageBytesList!;
    } else if (widget.mediaUrls != null) {
      mediaList = widget.mediaUrls!;
    }

    progressList = List.filled(mediaList.length, 0.0);
    _startProgress();
  }

  void _startProgress() async {
    _disposeVideo();

    final media = mediaList[currentIndex];
    isVideo = media is String && media.endsWith('.mp4');

    if (isVideo) {
      videoController = VideoPlayerController.networkUrl(Uri.parse(media))
        ..setVolume(1.0)
        ..initialize().then((_) {
          if (!mounted) return;
          setState(() {});
          videoController!.play();
          videoController!.addListener(() {
            if (!videoController!.value.isInitialized) return;

            final position = videoController!.value.position;
            final duration = videoController!.value.duration;

            if (position >= duration) {
              _nextStory();
            } else {
              if (mounted) {
                setState(() {
                  progressList[currentIndex] =
                      position.inMilliseconds / duration.inMilliseconds;
                });
              }
            }
          });
        });
    } else {
      imageTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (!mounted) return;
        setState(() {
          progressList[currentIndex] += 0.02;
          if (progressList[currentIndex] >= 1.0) {
            timer.cancel();
            _nextStory();
          }
        });
      });
    }
  }

  void _nextStory() {
    _disposeVideo();
    imageTimer?.cancel();

    if (currentIndex < mediaList.length - 1) {
      setState(() {
        currentIndex++;
      });
      pageController.jumpToPage(currentIndex);
      _startProgress();
    } else {
      Navigator.pop(context);
    }
  }

  void _disposeVideo() {
    videoController?.pause();
    videoController?.dispose();
    videoController = null;
  }

  @override
  void dispose() {
    _disposeVideo();
    imageTimer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70, // Soft aqua background
      body: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: mediaList.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              final media = mediaList[index];

              if (media is Uint8List) {
                return Image.memory(
                  media,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
              } else if (media is String && media.endsWith('.mp4')) {
                return videoController != null && videoController!.value.isInitialized
                    ? Center(
                  child: AspectRatio(
                    aspectRatio: videoController!.value.aspectRatio,
                    child: VideoPlayer(videoController!),
                  ),
                )
                    : const Center(child: CircularProgressIndicator());
              } else {
                return Image.network(
                  media,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (_, child, loading) =>
                  loading == null ? child : const Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),

          // Progress bars + header
          SafeArea(
            child: Column(
              children: [
                Row(
                  children: List.generate(mediaList.length, (i) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                        child: LinearProgressIndicator(
                          value: progressList[i],
                          backgroundColor: Colors.white54,
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0097A7)), // Dark aqua
                        ),
                      ),
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 20,
                        child: Image.asset(
                          'assets/images/logo.png', // App logo
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "${widget.name}'s Status",
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tap to exit
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                _disposeVideo();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
