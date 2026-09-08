import 'package:flutter/material.dart';
import 'package:pragma_cat/core/constants/app_colors.dart';

class LoadingBar extends StatefulWidget {
  const LoadingBar({super.key});

  @override
  State<LoadingBar> createState() => _LoadingBarState();
}

class _LoadingBarState extends State<LoadingBar> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _animate();
  }

  Future<void> _animate() async {
    while (mounted) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      setState(() => _expanded = !_expanded);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: _expanded ? 48 : 16,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
