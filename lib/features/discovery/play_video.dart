import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class NetflixVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const NetflixVideoPlayer({super.key, required this.videoUrl});

  @override
  State<NetflixVideoPlayer> createState() => _NetflixVideoPlayerState();
}

class _NetflixVideoPlayerState extends State<NetflixVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
            _controller.play();
            _startHideTimer();
          });
        }
      }).catchError((error) {
        print("LOI VIDEO: $error");
      });

    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) _startHideTimer();
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    _hideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            Center(
              child: _isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : const CircularProgressIndicator(color: Colors.red),
            ),
            if (_showControls && _isInitialized) _buildAdvancedControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedControls() {
    return Container(
      color: Colors.black45,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHeader(),
          _buildCenterControls(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
            const Text(
              'Stranger Things - Tập 1',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterControls() {
    final bool isBuffering = _controller.value.isBuffering;
    final bool isPlaying = _controller.value.isPlaying;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _controlIcon(Icons.replay_10, () {
          _controller.seekTo(_controller.value.position - const Duration(seconds: 10));
          _startHideTimer();
        }),
        const SizedBox(width: 50),

        SizedBox(
          width: 90,
          height: 90,
          child: isBuffering
              ? const Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(color: Colors.red, strokeWidth: 5),
          )
              : IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 80),
            onPressed: () {
              setState(() {
                isPlaying ? _controller.pause() : _controller.play();
              });
              _startHideTimer();
            },
          ),
        ),

        const SizedBox(width: 50),
        _controlIcon(Icons.forward_10, () {
          _controller.seekTo(_controller.value.position + const Duration(seconds: 10));
          _startHideTimer();
        }),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        VideoProgressIndicator(
          _controller,
          allowScrubbing: true,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          colors: const VideoProgressColors(
            playedColor: Colors.red,
            bufferedColor: Colors.white24,
            backgroundColor: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _controlIcon(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: 45),
      onPressed: onTap,
    );
  }
}