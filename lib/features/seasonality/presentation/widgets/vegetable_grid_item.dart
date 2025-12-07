import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../data/repositories/vegetable_repository.dart';
import '../../../../core/config/app_config.dart';

class VegetableGridItem extends ConsumerWidget {
  final Vegetable vegetable;
  final VoidCallback onTap;

  const VegetableGridItem({
    super.key,
    required this.vegetable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Basic seasonality check
    final now = DateTime.now();
    bool isSeason = true;
    try {
      if (vegetable.months.contains(now.month.toString())) {
         final clean = vegetable.months.replaceAll('[', '').replaceAll(']', '');
         final parts = clean.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList();
         isSeason = parts.contains(now.month);
      }
    } catch (_) {}

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isSeason ? 1.0 : 0.5, // Visual queue
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Hero(
                      tag: 'vegetable_${vegetable.id}',
                      child: CachedNetworkImage(
                        imageUrl: '${AppConfig.pocketBaseUrl}/api/files/vegetables/${vegetable.id}/${vegetable.image}',
                        fit: BoxFit.cover,
                        memCacheWidth: 400, // Optimization
                        placeholder: (context, url) => Container(color: Colors.grey[200]),
                        errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  // Favorite Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        ref.read(vegetableRepositoryProvider).toggleFavorite(vegetable.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          vegetable.isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: vegetable.isFavorite ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              vegetable.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
