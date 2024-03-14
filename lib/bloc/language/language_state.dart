part of 'language_cubit.dart';

enum LanguageStatus { initial, loading, success, failure }

class LanguageState extends Equatable {
  const LanguageState({this.status = LanguageStatus.initial, this.message, this.locale});

  final LanguageStatus status;
  final String? message;
  final Locale? locale;

  LanguageState copyWith({LanguageStatus? status, String? message, Locale? locale}) {
    return LanguageState(
      status: status ?? this.status,
      message: message ?? this.message,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [status, locale, message];
}
