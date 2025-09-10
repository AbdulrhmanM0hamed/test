import 'package:flutter/material.dart';
import 'package:test/l10n/app_localizations.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';

class ProductVideoSection extends StatefulWidget {
  final String? videoLink;

  const ProductVideoSection({
    super.key,
    required this.videoLink,
  });

  @override
  State<ProductVideoSection> createState() => _ProductVideoSectionState();
}

class _ProductVideoSectionState extends State<ProductVideoSection> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    if (widget.videoLink == null || widget.videoLink!.isEmpty) return;

    final videoId = _extractYouTubeVideoId(widget.videoLink!);
    if (videoId == null) return;

    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videoLink == null || widget.videoLink!.isEmpty) {
      return const SizedBox.shrink();
    }

    final videoId = _extractYouTubeVideoId(widget.videoLink!);
    if (videoId == null) {
      return const SizedBox.shrink();
    }

    if (_controller == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.play_circle_filled,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.productVideo,
                        style: getMediumStyle(
                          color: Colors.black,
                          fontSize: FontSize.size16,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context)!.productVideoDescription,
                        style: getRegularStyle(
                          color: Colors.grey[600]!,
                          fontSize: FontSize.size12,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // YouTube Video Player
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: YoutubePlayer(
                    controller: _controller!,
                    aspectRatio: 16 / 9,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }


  String? _extractYouTubeVideoId(String url) {
    try {
      final uri = Uri.parse(url);

      // Handle different YouTube URL formats
      if (uri.host.contains('youtube.com')) {
        // Standard YouTube URL: https://www.youtube.com/watch?v=VIDEO_ID
        return uri.queryParameters['v'];
      } else if (uri.host.contains('youtu.be')) {
        // Short YouTube URL: https://youtu.be/VIDEO_ID
        return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      } else if (uri.host.contains('m.youtube.com')) {
        // Mobile YouTube URL
        return uri.queryParameters['v'];
      }

      return null;
    } catch (e) {
      print('Error extracting YouTube video ID: $e');
      return null;
    }
  }
}
