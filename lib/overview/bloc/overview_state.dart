// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'overview_bloc.dart';

enum OverviewStatus { initial, loading, success, failure }

enum OverviewError { nullPasskey, readEntries }

final class OverviewState extends Equatable {
  const OverviewState({
    this.entries = const <Entry>[],
    this.status = OverviewStatus.initial,
    this.searchText = '',
    this.error,
  });

  final List<Entry> entries;
  final OverviewStatus status;
  final String searchText;
  final OverviewError? error;

  @override
  List<Object?> get props => [entries, status, searchText, error];

  OverviewState copyWith({
    List<Entry> Function()? entries,
    OverviewStatus Function()? status,
    String Function()? searchText,
    OverviewError? Function()? error,
  }) {
    return OverviewState(
      entries: entries != null ? entries() : this.entries,
      status: status != null ? status() : this.status,
      searchText: searchText != null ? searchText() : this.searchText,
      error: error != null ? error() : this.error,
    );
  }
}
