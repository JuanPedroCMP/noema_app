// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProviderCreate extends ProviderCreate {
  @override
  final String slug;
  @override
  final String displayName;
  @override
  final String baseUrl;

  factory _$ProviderCreate([void Function(ProviderCreateBuilder)? updates]) =>
      (ProviderCreateBuilder()..update(updates))._build();

  _$ProviderCreate._(
      {required this.slug, required this.displayName, required this.baseUrl})
      : super._();
  @override
  ProviderCreate rebuild(void Function(ProviderCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProviderCreateBuilder toBuilder() => ProviderCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProviderCreate &&
        slug == other.slug &&
        displayName == other.displayName &&
        baseUrl == other.baseUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, baseUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProviderCreate')
          ..add('slug', slug)
          ..add('displayName', displayName)
          ..add('baseUrl', baseUrl))
        .toString();
  }
}

class ProviderCreateBuilder
    implements Builder<ProviderCreate, ProviderCreateBuilder> {
  _$ProviderCreate? _$v;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _baseUrl;
  String? get baseUrl => _$this._baseUrl;
  set baseUrl(String? baseUrl) => _$this._baseUrl = baseUrl;

  ProviderCreateBuilder() {
    ProviderCreate._defaults(this);
  }

  ProviderCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _slug = $v.slug;
      _displayName = $v.displayName;
      _baseUrl = $v.baseUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProviderCreate other) {
    _$v = other as _$ProviderCreate;
  }

  @override
  void update(void Function(ProviderCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProviderCreate build() => _build();

  _$ProviderCreate _build() {
    final _$result = _$v ??
        _$ProviderCreate._(
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'ProviderCreate', 'slug'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'ProviderCreate', 'displayName'),
          baseUrl: BuiltValueNullFieldError.checkNotNull(
              baseUrl, r'ProviderCreate', 'baseUrl'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
