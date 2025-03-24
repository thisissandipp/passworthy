part of 'details_bloc.dart';

final class DetailsState extends Equatable {
  const DetailsState({
    required this.entry,
    this.showPassword = false,
  });

  final Entry entry;
  final bool showPassword;

  @override
  List<Object> get props => [entry, showPassword];

  DetailsState copyWith({
    Entry? entry,
    bool? showPassword,
  }) {
    return DetailsState(
      entry: entry ?? this.entry,
      showPassword: showPassword ?? this.showPassword,
    );
  }
}
