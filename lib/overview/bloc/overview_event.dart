part of 'overview_bloc.dart';

sealed class OverviewEvent extends Equatable {
  const OverviewEvent();

  @override
  List<Object> get props => [];
}

final class OverviewSubscriptionRequested extends OverviewEvent {
  const OverviewSubscriptionRequested();
}

final class OverviewEntryDeleted extends OverviewEvent {
  const OverviewEntryDeleted(this.entryToBeDeleted);
  final Entry entryToBeDeleted;

  @override
  List<Object> get props => [entryToBeDeleted];
}

final class OverviewSearchInputChanged extends OverviewEvent {
  const OverviewSearchInputChanged(this.value);
  final String value;

  @override
  List<Object> get props => [value];
}
