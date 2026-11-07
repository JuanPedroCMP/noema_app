// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snapshot_manifest.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SnapshotManifest extends SnapshotManifest {
  @override
  final String format;
  @override
  final int schemaVersion;
  @override
  final String snapshotVersion;
  @override
  final DateTime createdAt;
  @override
  final String installationId;
  @override
  final BuiltList<String> includedCategories;
  @override
  final BuiltList<String> excludedCategories;
  @override
  final BuiltMap<String, int> counts;
  @override
  final BuiltMap<String, String> hashes;

  factory _$SnapshotManifest(
          [void Function(SnapshotManifestBuilder)? updates]) =>
      (SnapshotManifestBuilder()..update(updates))._build();

  _$SnapshotManifest._(
      {required this.format,
      required this.schemaVersion,
      required this.snapshotVersion,
      required this.createdAt,
      required this.installationId,
      required this.includedCategories,
      required this.excludedCategories,
      required this.counts,
      required this.hashes})
      : super._();
  @override
  SnapshotManifest rebuild(void Function(SnapshotManifestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SnapshotManifestBuilder toBuilder() =>
      SnapshotManifestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SnapshotManifest &&
        format == other.format &&
        schemaVersion == other.schemaVersion &&
        snapshotVersion == other.snapshotVersion &&
        createdAt == other.createdAt &&
        installationId == other.installationId &&
        includedCategories == other.includedCategories &&
        excludedCategories == other.excludedCategories &&
        counts == other.counts &&
        hashes == other.hashes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, format.hashCode);
    _$hash = $jc(_$hash, schemaVersion.hashCode);
    _$hash = $jc(_$hash, snapshotVersion.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, installationId.hashCode);
    _$hash = $jc(_$hash, includedCategories.hashCode);
    _$hash = $jc(_$hash, excludedCategories.hashCode);
    _$hash = $jc(_$hash, counts.hashCode);
    _$hash = $jc(_$hash, hashes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SnapshotManifest')
          ..add('format', format)
          ..add('schemaVersion', schemaVersion)
          ..add('snapshotVersion', snapshotVersion)
          ..add('createdAt', createdAt)
          ..add('installationId', installationId)
          ..add('includedCategories', includedCategories)
          ..add('excludedCategories', excludedCategories)
          ..add('counts', counts)
          ..add('hashes', hashes))
        .toString();
  }
}

class SnapshotManifestBuilder
    implements Builder<SnapshotManifest, SnapshotManifestBuilder> {
  _$SnapshotManifest? _$v;

  String? _format;
  String? get format => _$this._format;
  set format(String? format) => _$this._format = format;

  int? _schemaVersion;
  int? get schemaVersion => _$this._schemaVersion;
  set schemaVersion(int? schemaVersion) =>
      _$this._schemaVersion = schemaVersion;

  String? _snapshotVersion;
  String? get snapshotVersion => _$this._snapshotVersion;
  set snapshotVersion(String? snapshotVersion) =>
      _$this._snapshotVersion = snapshotVersion;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _installationId;
  String? get installationId => _$this._installationId;
  set installationId(String? installationId) =>
      _$this._installationId = installationId;

  ListBuilder<String>? _includedCategories;
  ListBuilder<String> get includedCategories =>
      _$this._includedCategories ??= ListBuilder<String>();
  set includedCategories(ListBuilder<String>? includedCategories) =>
      _$this._includedCategories = includedCategories;

  ListBuilder<String>? _excludedCategories;
  ListBuilder<String> get excludedCategories =>
      _$this._excludedCategories ??= ListBuilder<String>();
  set excludedCategories(ListBuilder<String>? excludedCategories) =>
      _$this._excludedCategories = excludedCategories;

  MapBuilder<String, int>? _counts;
  MapBuilder<String, int> get counts =>
      _$this._counts ??= MapBuilder<String, int>();
  set counts(MapBuilder<String, int>? counts) => _$this._counts = counts;

  MapBuilder<String, String>? _hashes;
  MapBuilder<String, String> get hashes =>
      _$this._hashes ??= MapBuilder<String, String>();
  set hashes(MapBuilder<String, String>? hashes) => _$this._hashes = hashes;

  SnapshotManifestBuilder() {
    SnapshotManifest._defaults(this);
  }

  SnapshotManifestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _format = $v.format;
      _schemaVersion = $v.schemaVersion;
      _snapshotVersion = $v.snapshotVersion;
      _createdAt = $v.createdAt;
      _installationId = $v.installationId;
      _includedCategories = $v.includedCategories.toBuilder();
      _excludedCategories = $v.excludedCategories.toBuilder();
      _counts = $v.counts.toBuilder();
      _hashes = $v.hashes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SnapshotManifest other) {
    _$v = other as _$SnapshotManifest;
  }

  @override
  void update(void Function(SnapshotManifestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SnapshotManifest build() => _build();

  _$SnapshotManifest _build() {
    _$SnapshotManifest _$result;
    try {
      _$result = _$v ??
          _$SnapshotManifest._(
            format: BuiltValueNullFieldError.checkNotNull(
                format, r'SnapshotManifest', 'format'),
            schemaVersion: BuiltValueNullFieldError.checkNotNull(
                schemaVersion, r'SnapshotManifest', 'schemaVersion'),
            snapshotVersion: BuiltValueNullFieldError.checkNotNull(
                snapshotVersion, r'SnapshotManifest', 'snapshotVersion'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'SnapshotManifest', 'createdAt'),
            installationId: BuiltValueNullFieldError.checkNotNull(
                installationId, r'SnapshotManifest', 'installationId'),
            includedCategories: includedCategories.build(),
            excludedCategories: excludedCategories.build(),
            counts: counts.build(),
            hashes: hashes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'includedCategories';
        includedCategories.build();
        _$failedField = 'excludedCategories';
        excludedCategories.build();
        _$failedField = 'counts';
        counts.build();
        _$failedField = 'hashes';
        hashes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SnapshotManifest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
