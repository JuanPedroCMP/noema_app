// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProviderUpdate extends ProviderUpdate {
  @override
  final String? slug;
  @override
  final String? displayName;
  @override
  final String? baseUrl;
  @override
  final bool? isActive;

  factory _$ProviderUpdate([void Function(ProviderUpdateBuilder)? updates]) =>
      (ProviderUpdateBuilder()..update(updates))._build();

  _$ProviderUpdate._({this.slug, this.displayName, this.baseUrl, this.isActive})
      : super._();
  @override
  ProviderUpdate rebuild(void Function(ProviderUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProviderUpdateBuilder toBuilder() => ProviderUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProviderUpdate &&
        slug == other.slug &&
        displayName == other.displayName &&
        baseUrl == other.baseUrl &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, baseUrl.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProviderUpdate')
          ..add('slug', slug)
          ..add('displayName', displayName)
          ..add('baseUrl', baseUrl)
          ..add('isActive', isActive))
        .toString();
  }
}

class ProviderUpdateBuilder
    implements Builder<ProviderUpdate, ProviderUpdateBuilder> {
  _$ProviderUpdate? _$v;

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

  ProviderUpdateBuilder() {
    ProviderUpdate._defaults(this);
  }

  ProviderUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _slug = $v.slug;
      _displayName = $v.displayName;
      _baseUrl = $v.baseUrl;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProviderUpdate other) {
    _$v = other as _$ProviderUpdate;
  }

  @override
  void update(void Function(ProviderUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProviderUpdate build() => _build();

  _$ProviderUpdate _build() {
    final _$result = _$v ??
        _$ProviderUpdate._(
          slug: slug,
          displayName: displayName,
          baseUrl: baseUrl,
          isActive: isActive,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
