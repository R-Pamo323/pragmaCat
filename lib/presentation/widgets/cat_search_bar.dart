import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class CatSearchBar extends StatelessWidget {
  const CatSearchBar({
    super.key,
    this.onChanged,
    this.suggestion,
    this.onSuggestionTap,
  });

  final ValueChanged<String>? onChanged;
  final String? suggestion;
  final VoidCallback? onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Search for a cat breed...',
            prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
            suffixIcon: Icon(Icons.pets, color: AppColors.primaryDark),
          ),
        ),
        if (suggestion != null && suggestion!.isNotEmpty) ...[
          const SizedBox(height: 4),
          _SuggestionChip(suggestion: suggestion!, onTap: onSuggestionTap),
        ],
      ],
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.suggestion, this.onTap});

  final String suggestion;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ActionChip(
        onPressed: onTap,
        avatar: const Icon(Icons.tips_and_updates, size: 18),
        backgroundColor: AppColors.chipBackground,
        label: Text(
          'Did you mean $suggestion?',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.chipText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
