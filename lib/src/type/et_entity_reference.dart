import 'package:extended_type/src/extended_type_base.dart';
import 'package:swiss_knife/swiss_knife.dart';

class _ExtendedTypeHandler extends ExtendedTypeHandler<ETEntityReference> {
  @override
  ETEntityReference createInstance(String value) =>
      ETEntityReference.parse(value);

  @override
  int getTypeID() => ETEntityReference.TYPE_ID;

  @override
  String getTypeName() => ETEntityReference.TYPE_NAME;

  @override
  bool matchesFormat(String value) => ETEntityReference.matchesFormat(value);
}

/// [ExtendedType] for an entity reference (`type#id`).
class ETEntityReference extends ExtendedType {
  static void initialize() {
    ExtendedType.registerTypeHandler(_ExtendedTypeHandler());
  }

  static bool matchesFormat(String data) {
    if (data == null) return false;

    var length = data.length;
    if (length < 3) return false;

    var idx = data.indexOf('#');
    if (idx < 1) return false;

    if (!matchesType(data, 0, idx)) return false;

    var idLength = (length - idx) - 1;
    if (!matchesID(data, idx + 1, idLength)) return false;

    return true;
  }

  static final RegExp _REGEXP_TYPE = RegExp(r'^\w+$');
  static final RegExp _REGEXP_ID = RegExp(r'^\d+$');

  static bool matchesType(String s, int offset, int length) {
    if (length <= 0) return false;
    var part = offset == 0 && length == s.length
        ? s
        : s.substring(offset, offset + length);
    return _REGEXP_TYPE.hasMatch(part);
  }

  static bool matchesID(String s, int offset, int length) {
    if (length <= 0) return false;
    var part = offset == 0 && length == s.length
        ? s
        : s.substring(offset, offset + length);
    return _REGEXP_ID.hasMatch(part);
  }

  static final int TYPE_ID = 100;

  static final String TYPE_NAME = 'entity_reference';

  String _type;

  int _id;

  ETEntityReference(this._type, this._id);

  factory ETEntityReference.parse(String ref) {
    if (ref == null || ref.isEmpty) return null;

    var idx = ref.indexOf('#');
    if (idx < 1) return null;

    var typePart = ref.substring(0, idx);
    var idPart = ref.substring(idx + 1);

    if (!matchesType(typePart, 0, typePart.length)) return null;
    if (!matchesID(idPart, 0, idPart.length)) return null;

    var id = parseInt(idPart);

    return ETEntityReference(typePart, id);
  }

  @override
  int get typeID => TYPE_ID;

  @override
  String get typeName => TYPE_NAME;

  String get type => _type;

  int get id => _id;

  @override
  String encodeAsString() => '$_type#$_id';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ETEntityReference &&
          runtimeType == other.runtimeType &&
          _type == other._type &&
          _id == other._id;

  @override
  int get hashCode => _type.hashCode ^ _id.hashCode;

  @override
  String toString() {
    return encodeAsString();
  }
}
