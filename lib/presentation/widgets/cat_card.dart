import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pragma_cat/core/constants/app_images.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_fonts.dart';
import '../../../domain/entities/cat_breed.dart';
import 'loading_indicator.dart';

class CatCard extends StatelessWidget {
  const CatCard({super.key, required this.breed, required this.onMorePressed});

  final CatBreed breed;
  final VoidCallback onMorePressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 180, child: _BreedImage(image: breed.image)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(breed.name, style: AppFonts.title),
                const SizedBox(height: 4),
                _InfoRow(icon: Icons.location_on_outlined, label: breed.origin),
                const SizedBox(height: 2),
                _InfoRow(
                  icon: Icons.psychology_outlined,
                  label: 'Otra cosa ${breed.height.metric}/5',
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: onMorePressed,
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('More'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BreedImage extends StatelessWidget {
  const _BreedImage({required this.image});

  final CatImage? image;

  @override
  Widget build(BuildContext context) {
    final String? url = image?.url;

    if (url == null || url.isEmpty) {
      return Center(
        //child: Icon(Icons.pets, size: 64, color: AppColors.textSecondary),
        child: Image.asset(
          AppImages.catNotFound,
          width: 64,
          height: 64,
          color: AppColors.textSecondary,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, _) => const LoadingIndicator(),
      errorWidget: (_, _, _) => const Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 64,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: AppFonts.bodySecondary,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
