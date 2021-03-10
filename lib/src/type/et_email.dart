import 'package:extended_type/src/extended_type_base.dart';
import 'package:swiss_knife/swiss_knife.dart';

class _ExtendedTypeHandler extends ExtendedTypeHandler<ETEmail> {
  @override
  ETEmail? createInstance(String value) => ETEmail.parse(value);

  @override
  int getTypeID() => ETEmail.TYPE_ID;

  @override
  String getTypeName() => ETEmail.TYPE_NAME;

  @override
  bool matchesFormat(String value) => ETEmail.matchesFormat(value);
}

/// [ExtendedType] for E-Mail.
class ETEmail extends ExtendedType {
  static void initialize() {
    ExtendedType.registerTypeHandler(_ExtendedTypeHandler());
  }

  static bool matchesFormat(String data) {
    var length = data.length;
    if (length < 3) return false;

    var idx = data.indexOf('@');
    if (idx < 1) return false;

    if (!matchesUserFormat(data, 0, idx)) return false;

    var hostLength = (length - idx) - 1;
    if (!matchesHostFormat(data, idx + 1, hostLength)) return false;

    return true;
  }

  static final int _codeUnit_space = ' '.codeUnitAt(0);
  static final int _codeUnit_underscore = '_'.codeUnitAt(0);
  static final int _codeUnit_dot = '.'.codeUnitAt(0);
  static final int _codeUnit_plus = '+'.codeUnitAt(0);
  static final int _codeUnit_tilde1 = '-'.codeUnitAt(0);
  static final int _codeUnit_tilde2 = '~'.codeUnitAt(0);

  static bool matchesUserFormat(String user, int offset, int length) {
    if (length <= 0) return false;

    var prev = _codeUnit_space;

    for (var i = 0; i < length; i++) {
      var c = user.codeUnitAt(offset + i);

      if (!isAlphaNumeric(c) &&
          c != _codeUnit_dot &&
          c != _codeUnit_plus &&
          c != _codeUnit_tilde1 &&
          c != _codeUnit_tilde2) return false;

      if (c == _codeUnit_dot && prev == _codeUnit_dot) return false;

      prev = c;
    }

    if (user.codeUnitAt(offset) == _codeUnit_dot) return false;
    if (user.codeUnitAt(offset + length - 1) == _codeUnit_dot) return false;

    return true;
  }

  static bool matchesHostFormat(String host, int offset, int length) {
    if (length <= 0) return false;

    var prev = _codeUnit_space;

    for (var i = 0; i < length; i++) {
      var c = host.codeUnitAt(offset + i);

      if (!isAlphaNumeric(c) && c != _codeUnit_dot) return false;
      if (c == _codeUnit_underscore) return false;

      if (c == _codeUnit_dot && prev == _codeUnit_dot) return false;

      prev = c;
    }

    if (host.codeUnitAt(offset) == _codeUnit_dot) return false;
    if (host.codeUnitAt(offset + length - 1) == _codeUnit_dot) return false;

    return true;
  }

  static final int TYPE_ID = 300;

  static final String TYPE_NAME = 'email';

  final String _user;

  final String? _tag;

  final String _host;

  ETEmail(this._user, this._tag, this._host);

  static ETEmail? parse(String email) {
    if (email.length < 3) return null;

    email = email.trim();

    var idx = email.indexOf('@');
    if (idx < 1) return null;

    var localPart = email.substring(0, idx);

    var idx2 = email.indexOf('+');

    String user;
    String? tag;
    String host;

    if (idx2 < 0) {
      user = localPart;
      tag = null;
    } else {
      if (idx2 < 1) return null;

      user = localPart.substring(0, idx2);
      tag = localPart.substring(idx2 + 1);
    }

    host = email.substring(idx + 1);

    if (!matchesUserFormat(user, 0, user.length)) return null;
    if (tag != null && !matchesUserFormat(tag, 0, tag.length)) return null;
    if (!matchesHostFormat(host, 0, host.length)) return null;

    return ETEmail(user, tag, host);
  }

  @override
  int get typeID => TYPE_ID;

  @override
  String get typeName => TYPE_NAME;

  String get user => _user;

  String? get tag => _tag;

  String get host => _host;

  bool get hasTag => isNotEmptyString(_tag);

  @override
  String encodeAsString() => hasTag ? '$_user+$_tag@$_host' : '$_user@$_host';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ETEmail &&
          runtimeType == other.runtimeType &&
          _user == other._user &&
          _host == other._host &&
          hasTag == other.hasTag &&
          (hasTag ? _tag == other._tag : true);

  @override
  int get hashCode =>
      _user.hashCode ^ _host.hashCode ^ (hasTag ? _tag.hashCode : 0);

  @override
  String toString() {
    return encodeAsString();
  }
}
