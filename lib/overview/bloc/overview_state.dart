// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'overview_bloc.dart';

enum OverviewStatus { initial, loading, success, failure }

enum OverviewError { nullPasskey, readEntries }

final class OverviewState extends Equatable {
  const OverviewState({
    this.entries = const <Entry>[],
    this.status = OverviewStatus.initial,
    this.error,
  });

  final List<Entry> entries;
  final OverviewStatus status;
  final OverviewError? error;

  @override
  List<Object?> get props => [entries, status, error];

  OverviewState copyWith({
    List<Entry> Function()? entries,
    OverviewStatus Function()? status,
    OverviewError? Function()? error,
  }) {
    return OverviewState(
      entries: entries != null ? entries() : this.entries,
      status: status != null ? status() : this.status,
      error: error != null ? error() : this.error,
    );
  }
}
