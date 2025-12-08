import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/config/app_config.dart';

class SeasonalFeedItem extends StatelessWidget {
  final Vegetable vegetable;
  final double parallaxOffset;

  const SeasonalFeedItem({
    super.key,
    required this.vegetable,
    required this.parallaxOffset,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Parallax Image Layer
        // We clip it to ensure it doesn't overflow during high parallax translation
        ClipRect(
          child: Transform.translate(
            offset: Offset(0, parallaxOffset),
            child: SizedBox(
               height: MediaQuery.of(context).size.height + 200, // Extra height for parallax
               child: CachedNetworkImage(
                  imageUrl: '${AppConfig.pocketBaseUrl}/api/files/vegetables/${vegetable.id}/${vegetable.image}',
                  fit: BoxFit.cover,
                  // Optimierte Cache-Dimensionen für Full-Screen
                  memCacheWidth: 1080,
                  memCacheHeight: 1920,
                  fadeInDuration: const Duration(milliseconds: 150),
                  fadeOutDuration: const Duration(milliseconds: 150),
                  placeholder: (context, url) => Container(color: Colors.grey[900]),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[900],
                    child: const Center(child: Icon(Icons.broken_image, color: Colors.white)),
                  ),
               ),
            ),
          ),
        ),

        // 2. Gradient Overlay for Text Legibility
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.25), // Oben: dezent für Status Bar
                Colors.black.withValues(alpha: 0.0),  // Mitte: transparent - Bild sichtbar
                Colors.black.withValues(alpha: 0.85), // Unten: stark für Text-Lesbarkeit
              ],
              stops: const [0.0, 0.4, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // 3. Content Layer
        Positioned(
          left: 24,
          right: 24,
          bottom: 150, // Above the navigation pill
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tier/Season Badge (Optional)
              if (vegetable.tier == 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5D5C3), // Hero Badge Color
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Saison Highlight',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),

              // Title using Hero for transition logic (matches Grid)
              Hero(
                tag: 'vegetable_feed_${vegetable.id}', // Distinct tag from grid to avoid conflicts or use matching if transitioning
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    vegetable.name,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              Text(
                vegetable.description ?? 'Derzeit in Saison und frisch verfügbar.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 24),
              
              // Action Button
              FilledButton.icon(
                onPressed: () {
                    context.push('/details/${vegetable.id}');
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                icon: const Icon(Icons.arrow_forward),
                label: const Text("Mehr erfahren"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
