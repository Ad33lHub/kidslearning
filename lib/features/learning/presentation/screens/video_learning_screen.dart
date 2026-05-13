import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/widgets/cosmic_scaffold.dart';
import '../../../../core/widgets/cosmic_theme.dart';

class VideoLearningScreen extends StatelessWidget {
  const VideoLearningScreen({super.key});

  static const List<Map<String, String>> videos = [
    {
      'title': 'ABC Phonics Song',
      'url': 'https://www.youtube.com/watch?v=hq3yfQnllfQ',
      'category': 'Alphabet',
      'thumbnail': '🔤',
    },
    {
      'title': 'Numbers 1-10 Song',
      'url': 'https://www.youtube.com/watch?v=u3L5n4gfp80',
      'category': 'Numbers',
      'thumbnail': '🔢',
    },
    {
      'title': 'Color Song for Kids',
      'url': 'https://www.youtube.com/watch?v=tkpfg-1FJLU',
      'category': 'Colors',
      'thumbnail': '🎨',
    },
    {
      'title': 'Learn Shapes Song',
      'url': 'https://www.youtube.com/watch?v=WTeqUejfYZM',
      'category': 'Shapes',
      'thumbnail': '🔷',
    },
    {
      'title': 'Animal Sounds Song',
      'url': 'https://www.youtube.com/watch?v=t99ULJjCsaM',
      'category': 'Animals',
      'thumbnail': '🦁',
    },
    {
      'title': 'Fruits & Vegetables',
      'url': 'https://www.youtube.com/watch?v=ut7_F5rZ8fE',
      'category': 'Health',
      'thumbnail': '🍎',
    },
  ];

  Future<void> _launchVideo(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      // Try launching in external app first (YouTube App)
      final launched = await launchUrl(
        uri, 
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched && context.mounted) {
        // Fallback to in-app or browser
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CosmicScaffold(
      title: 'Video Learning',
      subtitle: 'Educational videos for you!',
      accent: const Color(0xFFC9CE00),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _launchVideo(context, video['url']!);
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.white.withOpacity(0.05),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC9CE00).withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFC9CE00).withOpacity(0.3)),
                        ),
                        child: Center(
                          child: Text(
                            video['thumbnail']!,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video['category']!.toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xFFC9CE00),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              video['title']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'arlrdbd',
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Tap to play on YouTube',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.play_circle_fill_rounded,
                        color: Color(0xFFFF0000),
                        size: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
