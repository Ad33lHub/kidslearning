import 'package:flutter/material.dart';
import 'package:kids/VideoLearning/ABC%20song.dart';
import 'package:kids/VideoLearning/AnimalVideo.dart';
import 'package:kids/VideoLearning/BirdVideo.dart';
import 'package:kids/VideoLearning/FlowerVideo.dart';
import 'package:kids/VideoLearning/FruitVideo.dart';
import 'package:kids/VideoLearning/MonthVideo.dart';
import 'package:kids/VideoLearning/Number%20video.dart';
import 'package:kids/VideoLearning/ShapeVideo.dart';
import 'package:kids/VideoLearning/VegitableVideo.dart';
import 'package:kids/VideoLearning/colorvideo.dart';
import 'package:kids/core/theme/app_colors.dart';

class VideoLearning extends StatefulWidget {
  const VideoLearning({super.key});

  @override
  State<VideoLearning> createState() => _VideoLearningState();
}

class _VideoLearningState extends State<VideoLearning> {
  static const _items = [
    _VideoItem(
      label: 'ABC Video',
      image: 'assets/images/Alphabet.png',
      emoji: '🔤',
      gradient: AppColors.gradientAlphabet,
    ),
    _VideoItem(
      label: 'Number Video',
      image: 'assets/images/Numbers.png',
      emoji: '🔢',
      gradient: AppColors.gradientNumbers,
    ),
    _VideoItem(
      label: 'Color Video',
      image: 'assets/images/Color.png',
      emoji: '🎨',
      gradient: AppColors.gradientColors,
    ),
    _VideoItem(
      label: 'Shape Video',
      image: 'assets/images/Shapes.png',
      emoji: '🔷',
      gradient: AppColors.gradientShapes,
    ),
    _VideoItem(
      label: 'Animal Video',
      image: 'assets/images/Animals.png',
      emoji: '🦁',
      gradient: AppColors.gradientAnimals,
    ),
    _VideoItem(
      label: 'Bird Video',
      image: 'assets/images/Birds.png',
      emoji: '🦜',
      gradient: AppColors.gradientBirds,
    ),
    _VideoItem(
      label: 'Flower Video',
      image: 'assets/images/Flowers.png',
      emoji: '🌸',
      gradient: AppColors.gradientFlowers,
    ),
    _VideoItem(
      label: 'Fruit Video',
      image: 'assets/images/Fruit.png',
      emoji: '🍎',
      gradient: AppColors.gradientFruits,
    ),
    _VideoItem(
      label: 'Month Video',
      image: 'assets/images/Month.png',
      emoji: '📅',
      gradient: AppColors.gradientMonths,
    ),
    _VideoItem(
      label: 'Vegetable Video',
      image: 'assets/images/Vegitable.png',
      emoji: '🥦',
      gradient: AppColors.gradientVegetables,
    ),
  ];

  void _navigate(int i) {
    const destinations = [
      ABCVideo.new,
      NumberVideo.new,
      ColorVideo.new,
      ShapeVideo.new,
      AnimalVideo.new,
      BirdVideo.new,
      FlowerVideo.new,
      FruitVideo.new,
      MonthVideo.new,
      VegitableVideo.new,
    ];
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => destinations[i]()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _VideoAppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.92,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => _VideoCard(
                  item: _items[i],
                  onTap: () => _navigate(i),
                ),
                childCount: _items.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Video Learning',
          style: TextStyle(
            fontFamily: 'arlrdbd',
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.gradientVideo,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.12),
                  ),
                ),
              ),
              const Positioned(
                bottom: 16,
                left: 20,
                child: Text('🎬', style: TextStyle(fontSize: 36)),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF43F5E),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final _VideoItem item;
  final VoidCallback onTap;

  const _VideoCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: item.gradient,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: item.gradient.last.withOpacity(0.42),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.22),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        item.image,
                        height: 52,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          size: 16,
                          color: Color(0xFFF43F5E),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.label,
                  style: const TextStyle(
                    fontFamily: 'arlrdbd',
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.emoji,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoItem {
  final String label;
  final String image;
  final String emoji;
  final List<Color> gradient;

  const _VideoItem({
    required this.label,
    required this.image,
    required this.emoji,
    required this.gradient,
  });
}
