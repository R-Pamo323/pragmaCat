import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class CatSearchBar extends StatelessWidget {
  const CatSearchBar({super.key, required this.controller, this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (BuildContext context, TextEditingValue value, _) {
            return TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search for a cat breed...',
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                suffixIcon: value.text.isEmpty
                    ? Icon(Icons.pets, color: AppColors.primaryDark)
                    : IconButton(
                        icon: const Icon(Icons.close),
                        color: AppColors.primaryDark,
                        onPressed: () {
                          controller.clear();
                          onChanged?.call('');
                        },
                      ),
              ),
            );
          },
        ),
      ],
    );
  }
}
