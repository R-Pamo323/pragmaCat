import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pragma_cat/core/constants/app_images.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_fonts.dart';
import '../../../domain/entities/cat_breed.dart';
import '../../widgets/loading_indicator.dart';

class CatDetailPage extends StatelessWidget {
  const CatDetailPage({super.key, required this.breed});

  final CatBreed breed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(breed.name),
        titleTextStyle: AppFonts.pageTitle.copyWith(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailImage(image: breed.image),
              Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(breed.name, style: AppFonts.headline),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _DetailChip(
                          icon: Icons.location_on_outlined,
                          label: breed.origin,
                        ),
                        _DetailChip(
                          icon: Icons.psychology_outlined,
                          label: 'Otra cosa ${breed.height.metric}/5',
                        ),
                        if (breed.lifeSpan.isNotEmpty)
                          _DetailChip(
                            icon: Icons.schedule,
                            label: '${breed.lifeSpan} years',
                          ),
                        if (breed.weight.metric.isNotEmpty)
                          _DetailChip(
                            icon: Icons.monitor_weight_outlined,
                            label: '${breed.weight.metric} kg',
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (breed.description.isNotEmpty) ...[
                      const _SectionLabel('Description'),
                      const SizedBox(height: 4),
                      Text(breed.description, style: AppFonts.body),
                    ],
                    if (breed.temperament.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const _SectionLabel('Temperament'),
                      const SizedBox(height: 4),
                      Text(breed.temperament, style: AppFonts.body),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _RatingChip(label: 'Otra cosa', value: 1),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _RatingChip(label: 'Otraco sosa', value: 2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailImage extends StatelessWidget {
  const _DetailImage({required this.image});

  final CatImage? image;

  @override
  Widget build(BuildContext context) {
    final String? url = image?.url;

    if (url == null || url.isEmpty) {
      return Container(
        height: 260,
        color: AppColors.primaryDark,
        alignment: Alignment.center,
        //child: const Icon(Icons.pets, size: 72, color: Colors.white),
        child: Image.asset(
          AppImages.catNotFound,
          width: 72,
          height: 72,
          color: Colors.white,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      height: 260,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (_, _) => Container(
        height: 260,
        color: AppColors.border,
        alignment: Alignment.center,
        child: const LoadingIndicator(),
      ),
      errorWidget: (_, _, _) => Container(
        height: 260,
        color: AppColors.primaryDark,
        alignment: Alignment.center,
        child: const Icon(Icons.pets, size: 72, color: Colors.white),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: AppColors.chipText),
      backgroundColor: AppColors.chipBackground,
      label: Text(label, style: AppFonts.caption),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
      ),
    );
  }
}

class _RatingChip extends StatelessWidget {
  const _RatingChip({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(label, style: AppFonts.caption),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (int index) {
              return Icon(
                index < value ? Icons.star_rounded : Icons.star_border_rounded,
                size: 18,
                color: index < value
                    ? AppColors.primary
                    : AppColors.textSecondary,
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label, style: AppFonts.title);
  }
}
