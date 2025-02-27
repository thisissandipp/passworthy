part of 'settings_cubit.dart';

final class SettingsState extends Equatable {
  const SettingsState({
    this.entriesCount = 0,
    this.errorMessage = '',
  });

  final int entriesCount;
  final String errorMessage;

  @override
  List<Object> get props => [entriesCount, errorMessage];

  SettingsState copyWith({
    int? entriesCount,
    String? errorMessage,
  }) {
    return SettingsState(
      entriesCount: entriesCount ?? this.entriesCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
