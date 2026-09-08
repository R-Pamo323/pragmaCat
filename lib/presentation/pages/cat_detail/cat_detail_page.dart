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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailImage(image: breed.image),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
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
                            icon: Icons.pets,
                            label: breed.breedGroup ?? 'Unknown',
                          ),
                          if (breed.lifeSpan.isNotEmpty)
                            _DetailChip(
                              icon: Icons.schedule,
                              label: '${breed.lifeSpan} years',
                            ),
                          if (breed.weight.imperial.isNotEmpty)
                            _DetailChip(
                              icon: Icons.balance_outlined,
                              label: '${breed.weight.imperial} kg',
                            ),
                          if (breed.height.imperial.isNotEmpty)
                            _DetailChip(
                              icon: Icons.height_outlined,
                              label: '${breed.height.imperial} cm',
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
                      if (breed.history != null) ...[
                        const SizedBox(height: 16),
                        const _SectionLabel('History'),
                        const SizedBox(height: 4),
                        Text(breed.history!, style: AppFonts.body),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
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
      backgroundColor: AppColors.background,
      label: Text(label, style: AppFonts.caption),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        side: const BorderSide(color: AppColors.primaryDark, width: 1),
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
