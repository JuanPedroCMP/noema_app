// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_out.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProviderOut extends ProviderOut {
  @override
  final String id;
  @override
  final String slug;
  @override
  final String displayName;
  @override
  final String baseUrl;
  @override
  final bool? isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$ProviderOut([void Function(ProviderOutBuilder)? updates]) =>
      (ProviderOutBuilder()..update(updates))._build();

  _$ProviderOut._(
      {required this.id,
      required this.slug,
      required this.displayName,
      required this.baseUrl,
      this.isActive,
      this.createdAt,
      this.updatedAt})
      : super._();
  @override
  ProviderOut rebuild(void Function(ProviderOutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProviderOutBuilder toBuilder() => ProviderOutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProviderOut &&
        id == other.id &&
        slug == other.slug &&
        displayName == other.displayName &&
        baseUrl == other.baseUrl &&
        isActive == other.isActive &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, baseUrl.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProviderOut')
          ..add('id', id)
          ..add('slug', slug)
          ..add('displayName', displayName)
          ..add('baseUrl', baseUrl)
          ..add('isActive', isActive)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ProviderOutBuilder implements Builder<ProviderOut, ProviderOutBuilder> {
  _$ProviderOut? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _baseUrl;
  String? get baseUrl => _$this._baseUrl;
  set baseUrl(String? baseUrl) => _$this._baseUrl = baseUrl;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ProviderOutBuilder() {
    ProviderOut._defaults(this);
  }

  ProviderOutBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _slug = $v.slug;
      _displayName = $v.displayName;
      _baseUrl = $v.baseUrl;
      _isActive = $v.isActive;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProviderOut other) {
    _$v = other as _$ProviderOut;
  }

  @override
  void update(void Function(ProviderOutBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProviderOut build() => _build();

  _$ProviderOut _build() {
    final _$result = _$v ??
        _$ProviderOut._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ProviderOut', 'id'),
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'ProviderOut', 'slug'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'ProviderOut', 'displayName'),
          baseUrl: BuiltValueNullFieldError.checkNotNull(
              baseUrl, r'ProviderOut', 'baseUrl'),
          isActive: isActive,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
