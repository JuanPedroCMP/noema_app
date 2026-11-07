// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_account_link_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoogleAccountLinkRequest extends GoogleAccountLinkRequest {
  @override
  final String googleIdToken;
  @override
  final String googleAccessToken;

  factory _$GoogleAccountLinkRequest(
          [void Function(GoogleAccountLinkRequestBuilder)? updates]) =>
      (GoogleAccountLinkRequestBuilder()..update(updates))._build();

  _$GoogleAccountLinkRequest._(
      {required this.googleIdToken, required this.googleAccessToken})
      : super._();
  @override
  GoogleAccountLinkRequest rebuild(
          void Function(GoogleAccountLinkRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoogleAccountLinkRequestBuilder toBuilder() =>
      GoogleAccountLinkRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoogleAccountLinkRequest &&
        googleIdToken == other.googleIdToken &&
        googleAccessToken == other.googleAccessToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, googleIdToken.hashCode);
    _$hash = $jc(_$hash, googleAccessToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoogleAccountLinkRequest')
          ..add('googleIdToken', googleIdToken)
          ..add('googleAccessToken', googleAccessToken))
        .toString();
  }
}

class GoogleAccountLinkRequestBuilder
    implements
        Builder<GoogleAccountLinkRequest, GoogleAccountLinkRequestBuilder> {
  _$GoogleAccountLinkRequest? _$v;

  String? _googleIdToken;
  String? get googleIdToken => _$this._googleIdToken;
  set googleIdToken(String? googleIdToken) =>
      _$this._googleIdToken = googleIdToken;

  String? _googleAccessToken;
  String? get googleAccessToken => _$this._googleAccessToken;
  set googleAccessToken(String? googleAccessToken) =>
      _$this._googleAccessToken = googleAccessToken;

  GoogleAccountLinkRequestBuilder() {
    GoogleAccountLinkRequest._defaults(this);
  }

  GoogleAccountLinkRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _googleIdToken = $v.googleIdToken;
      _googleAccessToken = $v.googleAccessToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoogleAccountLinkRequest other) {
    _$v = other as _$GoogleAccountLinkRequest;
  }

  @override
  void update(void Function(GoogleAccountLinkRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoogleAccountLinkRequest build() => _build();

  _$GoogleAccountLinkRequest _build() {
    final _$result = _$v ??
        _$GoogleAccountLinkRequest._(
          googleIdToken: BuiltValueNullFieldError.checkNotNull(
              googleIdToken, r'GoogleAccountLinkRequest', 'googleIdToken'),
          googleAccessToken: BuiltValueNullFieldError.checkNotNull(
              googleAccessToken,
              r'GoogleAccountLinkRequest',
              'googleAccessToken'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
