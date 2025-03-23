import 'package:entries_api/entries_api.dart';
import 'package:objectbox/objectbox.dart';

/// {@template entry_dto}
/// A DTO object for the [Entry] model.
/// {@endtemplate}
@Entity()
class EntryDto {
  /// {@macro entry_dto}
  EntryDto({
    required this.uid,
    required this.platform,
    required this.identity,
    required this.password,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.id = 0,
    this.isFavorite = false,
    this.additionalNotes = '',
  });

  /// Creates an [EntryDto] object from [entry].
  factory EntryDto.fromEntry(Entry entry) {
    return EntryDto(
      uid: entry.id,
      platform: entry.platform,
      identity: entry.identity,
      password: entry.password,
      createdAt: entry.createdAt,
      lastUpdatedAt: entry.lastUpdatedAt,
      isFavorite: entry.isFavorite,
      additionalNotes: entry.additionalNotes,
    );
  }

  /// Converts this object into an [Entry] object.
  Entry toEntry() {
    return Entry(
      id: uid,
      platform: platform,
      identity: identity,
      password: password,
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
      isFavorite: isFavorite,
      additionalNotes: additionalNotes,
    );
  }

  /// Unique identifier for the object. Required by objectbox.
  int id;

  /// The unique identifier in model level.
  @Index()
  @Unique(onConflict: ConflictStrategy.replace)
  final String uid;

  /// The name of the platform.
  final String platform;

  /// The username, or phone number, or email address against which
  /// the password will be saved.
  final String identity;

  /// Encrypted password.
  final String password;

  /// Timestamp of when the object was created.
  @Property(type: PropertyType.dateNano)
  final DateTime createdAt;

  /// The timestamp defining when the password was last updated.
  @Property(type: PropertyType.dateNano)
  final DateTime lastUpdatedAt;

  /// Whether this entry is marked as a favorite.
  final bool isFavorite;

  /// Any associated additional notes for the entry.
  final String additionalNotes;
}
