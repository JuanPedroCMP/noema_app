// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_direction.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SyncDirection _$upload = const SyncDirection._('upload');
const SyncDirection _$download = const SyncDirection._('download');

SyncDirection _$valueOf(String name) {
  switch (name) {
    case 'upload':
      return _$upload;
    case 'download':
      return _$download;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SyncDirection> _$values =
    BuiltSet<SyncDirection>(const <SyncDirection>[
  _$upload,
  _$download,
]);

class _$SyncDirectionMeta {
  const _$SyncDirectionMeta();
  SyncDirection get upload => _$upload;
  SyncDirection get download => _$download;
  SyncDirection valueOf(String name) => _$valueOf(name);
  BuiltSet<SyncDirection> get values => _$values;
}

abstract class _$SyncDirectionMixin {
  // ignore: non_constant_identifier_names
  _$SyncDirectionMeta get SyncDirection => const _$SyncDirectionMeta();
}

Serializer<SyncDirection> _$syncDirectionSerializer =
    _$SyncDirectionSerializer();

class _$SyncDirectionSerializer implements PrimitiveSerializer<SyncDirection> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'upload': 'upload',
    'download': 'download',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'upload': 'upload',
    'download': 'download',
  };

  @override
  final Iterable<Type> types = const <Type>[SyncDirection];
  @override
  final String wireName = 'SyncDirection';

  @override
  Object serialize(Serializers serializers, SyncDirection object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SyncDirection deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SyncDirection.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
