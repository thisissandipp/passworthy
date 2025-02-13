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
    this.status = CreateEntryStatus.initial,
    this.initialEntry,
    this.platform = '',
    this.identity = '',
    this.password = '',
  });

  final CreateEntryStatus status;
  final Entry? initialEntry;
  final String platform;
  final String identity;
  final String password;

  bool get isNewEntry => initialEntry == null;

  @override
  List<Object?> get props =>
      [status, initialEntry, platform, identity, password];

  CreateState copyWith({
    CreateEntryStatus? status,
    Entry? initialEntry,
    String? platform,
    String? identity,
    String? password,
  }) {
    return CreateState(
      status: status ?? this.status,
      initialEntry: initialEntry ?? this.initialEntry,
      platform: platform ?? this.platform,
      identity: identity ?? this.identity,
      password: password ?? this.password,
    );
  }
}
