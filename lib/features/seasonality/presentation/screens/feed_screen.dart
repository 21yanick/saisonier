import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saisonier/core/config/app_config.dart';
import 'package:saisonier/features/profile/presentation/state/user_profile_controller.dart';
import 'package:saisonier/features/seasonality/data/repositories/vegetable_repository.dart';
import 'package:saisonier/features/seasonality/presentation/widgets/seasonal_feed_item.dart';

import '../../../../core/database/app_database.dart';

/// Provider für den Saison-Feed mit Type- und User-Preference-Filterung
///
/// Zeigt nur: vegetable, fruit, salad, herb (kein meat, nut)
/// Berücksichtigt User-Dislikes wenn eingeloggt
final seasonalVegetablesProvider = StreamProvider.autoDispose<List<Vegetable>>((ref) {
  final repo = ref.watch(vegetableRepositoryProvider);
  final profileAsync = ref.watch(userProfileControllerProvider);

  // UserProfile extrahieren (null wenn nicht eingeloggt oder noch nicht geladen)
  final profile = profileAsync.valueOrNull;

  return repo.watchSeasonalFiltered(
    DateTime.now().month,
    profile: profile,
  );
});

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final PageController _pageController = PageController();
  final Set<String> _preloadedImages = {};

  /// Preload images für smoother scrolling
  void _preloadImage(Vegetable vegetable) {
    final imageUrl = '${AppConfig.pocketBaseUrl}/api/files/vegetables/${vegetable.id}/${vegetable.image}';

    // Nur einmal pro Bild preloaden
    if (_preloadedImages.contains(imageUrl)) return;
    _preloadedImages.add(imageUrl);

    // Bild in den Cache laden
    precacheImage(
      CachedNetworkImageProvider(imageUrl),
      context,
    );
  }

  /// Preload current + nächste 2 Bilder
  void _preloadNearbyImages(List<Vegetable> vegetables, int currentIndex) {
    // Aktuelles Bild
    if (currentIndex < vegetables.length) {
      _preloadImage(vegetables[currentIndex]);
    }
    // Nächstes Bild
    if (currentIndex + 1 < vegetables.length) {
      _preloadImage(vegetables[currentIndex + 1]);
    }
    // Übernächstes Bild
    if (currentIndex + 2 < vegetables.length) {
      _preloadImage(vegetables[currentIndex + 2]);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vegetablesAsync = ref.watch(seasonalVegetablesProvider);

    // Kein AnnotatedRegion hier - wird vom DiscoverScreen gehandhabt
    return Scaffold(
      backgroundColor: Colors.black,
      body: vegetablesAsync.when(
        data: (vegetables) {
          if (vegetables.isEmpty) {
            return const Center(child: Text('Keine Saison-Highlights gefunden.', style: TextStyle(color: Colors.white)));
          }

          // Initial preload der ersten Bilder
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _preloadNearbyImages(vegetables, 0);
          });

          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: vegetables.length,
            onPageChanged: (index) {
              // Haptic feedback for "Snap" effect
              HapticFeedback.lightImpact();
              // Preload nächste Bilder beim Swipen
              _preloadNearbyImages(vegetables, index);
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
    );
  }
}
