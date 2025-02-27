import 'package:bloc/bloc.dart';
import 'package:entries_repository/entries_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required EntriesRepository entriesRepository,
  })  : _entriesRepository = entriesRepository,
        super(const SettingsState());

  final EntriesRepository _entriesRepository;

  Future<void> launchSupport() async {
    emit(state.copyWith(errorMessage: ''));

    final supportUri = Uri.https('passworthy.thisissandipp.com', '/support');
    try {
      final launched = await url_launcher.launchUrl(supportUri);

      if (!launched) {
        emit(state.copyWith(errorMessage: 'failed_to_launch_support'));
      }
    } on PlatformException catch (_) {
      emit(state.copyWith(errorMessage: 'failed_to_launch_support'));
    }
  }

  Future<void> getEntriesCount() async {
    final entriesCount = _entriesRepository.entriesCount();
    emit(state.copyWith(entriesCount: entriesCount));
  }
}
