import 'dart:convert';
import 'dart:typed_data';

import 'package:extended_type/src/extended_type_base.dart';
import 'package:swiss_knife/swiss_knife.dart';

class _ExtendedTypeHandler extends ExtendedTypeHandler<ETDataBase64URL> {
  @override
  ETDataBase64URL createInstance(String value) => ETDataBase64URL(value);

  @override
  int getTypeID() => ETDataBase64URL.TYPE_ID;

  @override
  String getTypeName() => ETDataBase64URL.TYPE_NAME;

  @override
  bool matchesFormat(String value) => ETDataBase64URL.matchesFormat(value);
}

/// [ExtendedType] for Data URL in Base64 encoding.
class ETDataBase64URL extends ExtendedType {
  static void initialize() {
    ExtendedType.registerTypeHandler(_ExtendedTypeHandler());
  }

  static bool matchesFormat(String data) {
    if (data == null) return false;
    if (!data.startsWith('data:')) return false;

    var idx = data.indexOf(',');
    if (idx < 12) return false;

    var base64 = data.substring(idx - 7, idx);
    if (base64 != ';base64') return false;

    return true;
  }

  /// Returns the [MimeType] of data.
  final MimeType mimeType;

  final Uint8List _data;

  ETDataBase64URL.from(this.mimeType, this._data);

  factory ETDataBase64URL(String data) {
    var mimeType = DataURLBase64.parseMimeType(data);
    var payload = DataURLBase64.parsePayloadAsArrayBuffer(data);
    return ETDataBase64URL.from(mimeType, payload);
  }

  static final String TYPE_NAME = 'data_base64_url';

  static final int TYPE_ID = 500;

  @override
  int get typeID => TYPE_ID;

  @override
  String get typeName => TYPE_NAME;

  @override
  String encodeAsString() {
    return 'data:$mimeType;base64,${base64.encode(_data)}';
  }

  Uint8List get data => UnmodifiableUint8ListView(_data);

  /// Returns the data bytes length.
  int get dataLength => _data.length;

  /// Returns [true] if is an image [mimeType].
  bool get isImage => mimeType.isImage;

  /// Returns [true] if is a PNG image [mimeType].
  bool get isImagePNG => mimeType.isImagePNG;

  /// Returns [true] if is a JPEG image [mimeType].
  bool get isImageJPEG => mimeType.isImageJPEG;

  /// Returns [true] if is a video [mimeType].
  bool get isVideo => mimeType.isVideo;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ETDataBase64URL &&
          runtimeType == other.runtimeType &&
          mimeType == other.mimeType &&
          isEqualsList(_data, other._data);

  @override
  int get hashCode => mimeType.hashCode ^ _data.hashCode;

  @override
  String toString() {
    return 'ETDataURL{type=$mimeType, data=${_data.length}';
  }

  static final List<Operation> _OPERATIONS_BASIC = [
    Operation('BYTES', 'Returns the value raw bytes.')
  ];

  static final List<Operation> _OPERATIONS_IMAGE = [
    Operation('JPEG', 'Converts image to JPEG.'),
    Operation('JPEG', 'Converts image to JPEG with specific quality.',
        [OperationParameter(OperationParameterType.FLOAT, 'quality')]),
    Operation('PNG', 'Converts image to PNG.'),
    Operation(
        'SCALE',
        'Scales image with same scale parameter for width and height',
        [OperationParameter(OperationParameterType.FLOAT, 'scale')]),
    Operation('SCALE',
        'Scales image with specific scale parameter for width and height.', [
      OperationParameter(OperationParameterType.FLOAT, 'scaleWidth'),
      OperationParameter(OperationParameterType.FLOAT, 'scaleHeight')
    ]),
    Operation(
        'FIT',
        'Scales image inside a width and height dimension without change aspect ratio.',
        [
          OperationParameter(OperationParameterType.INT, 'width'),
          OperationParameter(OperationParameterType.INT, 'eight')
        ]),
  ];

  static final List<Operation> _OPERATIONS = [
    ..._OPERATIONS_BASIC,
    ..._OPERATIONS_IMAGE
  ];

  @override
  List<Operation> getOperations() {
    return List.from(_OPERATIONS);
  }

  @override
  List<Operation> getAvailableOperations() {
    if (isImage) {
      return List.from(_OPERATIONS);
    } else {
      return List.from(_OPERATIONS_BASIC);
    }
  }
}
