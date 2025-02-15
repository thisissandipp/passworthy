// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again
// with `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'src/dtos/entry_dto.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(1, 6100215952033375227),
      name: 'EntryDto',
      lastPropertyId: const obx_int.IdUid(7, 7747267446288063515),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 7788624754513047223),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 8948857680733145495),
            name: 'uid',
            type: 9,
            flags: 34848,
            indexId: const obx_int.IdUid(1, 4073036465608811623)),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 7845620516496505716),
            name: 'platform',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 4317148113589121615),
            name: 'identity',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 4328688467648663387),
            name: 'password',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 3247140918347397447),
            name: 'createdAt',
            type: 12,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 7747267446288063515),
            name: 'isFavorite',
            type: 1,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [obx.Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [obx.Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
Future<obx.Store> openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) async {
  await loadObjectBoxLibraryAndroidCompat();
  return obx.Store(getObjectBoxModel(),
      directory: directory ?? (await defaultStoreDirectory()).path,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [obx.Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(1, 6100215952033375227),
      lastIndexId: const obx_int.IdUid(1, 4073036465608811623),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    EntryDto: obx_int.EntityDefinition<EntryDto>(
        model: _entities[0],
        toOneRelations: (EntryDto object) => [],
        toManyRelations: (EntryDto object) => {},
        getId: (EntryDto object) => object.id,
        setId: (EntryDto object, int id) {
          object.id = id;
        },
        objectToFB: (EntryDto object, fb.Builder fbb) {
          final uidOffset = fbb.writeString(object.uid);
          final platformOffset = fbb.writeString(object.platform);
          final identityOffset = fbb.writeString(object.identity);
          final passwordOffset = fbb.writeString(object.password);
          fbb.startTable(8);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, uidOffset);
          fbb.addOffset(2, platformOffset);
          fbb.addOffset(3, identityOffset);
          fbb.addOffset(4, passwordOffset);
          fbb.addInt64(5, object.createdAt.microsecondsSinceEpoch * 1000);
          fbb.addBool(6, object.isFavorite);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final uidParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final platformParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 8, '');
          final identityParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 10, '');
          final passwordParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 12, '');
          final createdAtParam = DateTime.fromMicrosecondsSinceEpoch(
              (const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0) /
                      1000)
                  .round());
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final isFavoriteParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 16, false);
          final object = EntryDto(
              uid: uidParam,
              platform: platformParam,
              identity: identityParam,
              password: passwordParam,
              createdAt: createdAtParam,
              id: idParam,
              isFavorite: isFavoriteParam);

          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [EntryDto] entity fields to define ObjectBox queries.
class EntryDto_ {
  /// See [EntryDto.id].
  static final id =
      obx.QueryIntegerProperty<EntryDto>(_entities[0].properties[0]);

  /// See [EntryDto.uid].
  static final uid =
      obx.QueryStringProperty<EntryDto>(_entities[0].properties[1]);

  /// See [EntryDto.platform].
  static final platform =
      obx.QueryStringProperty<EntryDto>(_entities[0].properties[2]);

  /// See [EntryDto.identity].
  static final identity =
      obx.QueryStringProperty<EntryDto>(_entities[0].properties[3]);

  /// See [EntryDto.password].
  static final password =
      obx.QueryStringProperty<EntryDto>(_entities[0].properties[4]);

  /// See [EntryDto.createdAt].
  static final createdAt =
      obx.QueryDateNanoProperty<EntryDto>(_entities[0].properties[5]);

  /// See [EntryDto.isFavorite].
  static final isFavorite =
      obx.QueryBooleanProperty<EntryDto>(_entities[0].properties[6]);
}
