import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saisonier/features/seasonality/data/repositories/vegetable_repository.dart';
import 'package:saisonier/features/seasonality/presentation/widgets/seasonal_feed_item.dart';

import '../../../../core/database/app_database.dart';

final seasonalVegetablesProvider = StreamProvider.autoDispose<List<Vegetable>>((ref) {
  final repo = ref.watch(vegetableRepositoryProvider);
  return repo.watchSeasonal(DateTime.now().month);
});

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final PageController _pageController = PageController();

  /// Helper to allow PageView.builder to access the controller for parallax
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vegetablesAsync = ref.watch(seasonalVegetablesProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // Weiße Icons auf schwarzem Hintergrund
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.black, // Immersive background
        body: vegetablesAsync.when(
        data: (vegetables) {
          if (vegetables.isEmpty) {
            return const Center(child: Text('Keine Saison-Highlights gefunden.', style: TextStyle(color: Colors.white)));
          }

          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: vegetables.length,
            onPageChanged: (index) {
              // Haptic feedback for "Snap" effect
              HapticFeedback.lightImpact();
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double parallaxOffset = 0;
                  // Only calculate parallax if controller is attached and we have dimensions
                  if (_pageController.position.haveDimensions) {
                    final pageValue = _pageController.page ?? 0; // Original pageValue
                    // Calculate offset relative to this page
                    final offset = pageValue - index;
                    // Apply parallax factor (e.g. 50% speed) multiplied by screen height or pixels
                    // Negative offset on scroll down to move background up slower
                    parallaxOffset = offset * 300; 
                  }
                  
                  return SeasonalFeedItem(
                    vegetable: vegetables[index],
                    parallaxOffset: parallaxOffset,
                  );
                },
              );
            },
          );
        },
        error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
        loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
