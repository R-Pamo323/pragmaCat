import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pragma_cat/presentation/viewmodels/splash/splash_state.dart';
import '../../../core/constants/app_constants.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashLoading()) {
    _startTimer();
  }

  Timer? _timer;

  void _startTimer() {
    _timer = Timer(AppConstants.splashDuration, () {
      emit(const SplashNavigatingToHome());
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
