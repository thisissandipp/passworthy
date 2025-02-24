import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'banner_state.dart';

class BannerCubit extends Cubit<BannerState> {
  BannerCubit() : super(const BannerState());

  void removeBanner() {
    emit(state.copyWith(showBanner: false));
  }
}
