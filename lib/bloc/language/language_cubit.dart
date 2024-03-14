import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../data/repo/app_storage.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final AppStorage appStorage;
  LanguageCubit(this.appStorage) : super(LanguageState());

  Future<void> load() async {
    emit(state.copyWith(status: LanguageStatus.loading));
    try {
      final language = await appStorage.getLanguage();
      final locale = Locale(language);
      emit(state.copyWith(status: LanguageStatus.success, locale: locale));
    } catch (e) {
      emit(state.copyWith(status: LanguageStatus.failure, locale: const Locale('en')));
    }
  }

  Future<void> changeLanguage(String language) async {
    emit(state.copyWith(status: LanguageStatus.loading));
    try {
      final locale = Locale(language);
      await appStorage.saveLanguage(language);
      emit(state.copyWith(status: LanguageStatus.success, locale: locale));
    } catch (e) {
      emit(state.copyWith(status: LanguageStatus.failure, locale: const Locale('en')));
    }
  }
}
