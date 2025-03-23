part of 'create_bloc.dart';

enum CreateEntryStatus { initial, loading, success, failure }

extension CreatedEntryStatusExt on CreateEntryStatus {
  bool get isLoadingOrSuccess => [
        CreateEntryStatus.loading,
        CreateEntryStatus.success,
      ].contains(this);
}

final class CreateState extends Equatable {
  const CreateState({
    this.createStatus = CreateEntryStatus.initial,
    this.initialEntry,
    this.platform = const Platform.pure(),
    this.identity = const Identity.pure(),
    this.password = const Password.pure(),
    this.additionalNotes = '',
    this.isFormValid = false,
  });

  final CreateEntryStatus createStatus;
  final Entry? initialEntry;
  final Platform platform;
  final Identity identity;
  final Password password;
  final String additionalNotes;
  final bool isFormValid;

  bool get isNewEntry => initialEntry == null;

  @override
  List<Object?> get props => [
        createStatus,
        initialEntry,
        platform,
        identity,
        password,
        additionalNotes,
        isFormValid,
      ];

  CreateState copyWith({
    CreateEntryStatus? createStatus,
    Entry? initialEntry,
    Platform? platform,
    Identity? identity,
    Password? password,
    String? additionalNotes,
    bool? isFormValid,
  }) {
    return CreateState(
      createStatus: createStatus ?? this.createStatus,
      initialEntry: initialEntry ?? this.initialEntry,
      platform: platform ?? this.platform,
      identity: identity ?? this.identity,
      password: password ?? this.password,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }
}
