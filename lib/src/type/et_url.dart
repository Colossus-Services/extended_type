import 'package:extended_type/src/extended_type_base.dart';
import 'package:swiss_knife/swiss_knife.dart';

class _ExtendedTypeHandler extends ExtendedTypeHandler<ETURL> {
  @override
  ETURL createInstance(String value) => ETURL(value);

  @override
  int getTypeID() => ETURL.TYPE_ID;

  @override
  String getTypeName() => ETURL.TYPE_NAME;

  @override
  bool matchesFormat(String value) => ETURL.matchesFormat(value);
}

/// [ExtendedType] for URL.
class ETURL extends ExtendedType {
  static void initialize() {
    ExtendedType.registerTypeHandler(_ExtendedTypeHandler());
  }

  static bool matchesFormat(String data) {
    var length = data.length;
    if (length < 3) return false;

    var delimiter = _findDelimiter(data);
    if (delimiter < 0 || delimiter >= length - 2) return false;

    var init = delimiter + 2;

    var cNext = data[init];
    if (cNext == '/') init++;

    if (init >= length) return false;

    if (hasBlankCharFrom(data, init)) return false;

    return true;
  }

  static final int _codeColon = ':'.codeUnitAt(0);
  static final int _codeSlash = '/'.codeUnitAt(0);
  static final int _code0 = '0'.codeUnitAt(0);
  static final int _code_z = 'z'.codeUnitAt(0);
  static final int _code9 = '9'.codeUnitAt(0);
  static final int _codeA = 'A'.codeUnitAt(0);
  static final int _codeZ = 'Z'.codeUnitAt(0);
  static final int _code_a = 'a'.codeUnitAt(0);
  static final int _codeUnderscore = '_'.codeUnitAt(0);

  static int _findDelimiter(String data) {
    var end = data.length - 1;
    if (end > 20) end = 20;

    for (var i = 0; i < end; i++) {
      var c = data.codeUnitAt(i);

      if (c == _codeColon) {
        var c2 = data.codeUnitAt(i + 1);

        if (c2 == _codeSlash) {
          return i;
        } else {
          return -1;
        }
      }

      if (c < _code0 ||
          c > _code_z ||
          ((c > _code9 && c < _codeA) ||
              (c > _codeZ && c < _code_a && c != _codeUnderscore))) {
        return -1;
      }
    }

    return -1;
  }

  static final int TYPE_ID = 200;

  static final String TYPE_NAME = 'url';

  final Uri uri;

  factory ETURL(String url) => ETURL.fromURI(Uri.parse(url));

  ETURL.fromURI(this.uri);

  /// Returns the URL as [String].
  String get url => uri.toString();

  @override
  int get typeID => TYPE_ID;

  @override
  String get typeName => TYPE_NAME;

  @override
  String encodeAsString({bool pretty = false}) => url.toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ETURL && runtimeType == other.runtimeType && url == other.url;

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() {
    return encodeAsString();
  }
}
