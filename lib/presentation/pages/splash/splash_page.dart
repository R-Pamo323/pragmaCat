import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pragma_cat/core/constants/app_images.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_fonts.dart';
import '../../viewmodels/splash/splash_cubit.dart';
import '../home/home_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => SplashCubit(),
        child: BlocListener<SplashCubit, SplashState>(
          listener: (BuildContext context, SplashState state) {
            if (state is SplashNavigatingToHome) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(builder: (_) => const HomePage()),
              );
            }
          },
          child: const _SplashContent(),
        ),
      ),
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.splashCat,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24),
            Text(AppConstants.appName, style: AppFonts.headline),
            const SizedBox(height: 48),
            const _LoadingBar(),
          ],
        ),
      ),
    );
  }
}

class _LoadingBar extends StatefulWidget {
  const _LoadingBar();

  @override
  State<_LoadingBar> createState() => _LoadingBarState();
}

class _LoadingBarState extends State<_LoadingBar> {
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
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
