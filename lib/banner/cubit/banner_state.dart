part of 'banner_cubit.dart';

final class BannerState extends Equatable {
  const BannerState({
    this.showBanner = true,
  });

  final bool showBanner;

  @override
  List<Object> get props => [showBanner];

  BannerState copyWith({
    bool? showBanner,
  }) {
    return BannerState(
      showBanner: showBanner ?? this.showBanner,
    );
  }
}
