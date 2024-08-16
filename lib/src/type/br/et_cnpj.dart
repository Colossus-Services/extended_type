import '../../extended_type_base.dart';

class _ExtendedTypeHandler extends ExtendedTypeHandler<ETCNPJ> {
  @override
  ETCNPJ? createInstance(String value) => ETCNPJ.parse(value);

  @override
  int getTypeID() => ETCNPJ.TYPE_ID;

  @override
  String getTypeName() => ETCNPJ.TYPE_NAME;

  @override
  bool matchesFormat(String value) => ETCNPJ.matchesFormat(value);
}

/// [ExtendedType] for CNPJ (br).
class ETCNPJ extends ExtendedType {
  static void initialize() {
    ExtendedType.registerTypeHandler(_ExtendedTypeHandler());
  }

  static bool matchesFormat(String data) {
    var length = data.length;
    if (length < 14) return false;

    data = data.replaceAll(RegExp(r'[^0-9a-zA-Z]'), '');

    if (data.length != 14) return false;

    data = data.toUpperCase();

    var dv = data.substring(8 + 4);

    var dvCheck = _buildDV(cnpj: data);

    if (dv != dvCheck) return false;

    return true;
  }

  static final int TYPE_ID = 55101;

  static final String TYPE_NAME = 'cnpj';

  final String _code;
  final String _branch;

  ETCNPJ(this._code, this._branch, {String? dv}) : _dv = dv;

  static final _regexpNonNumeric = RegExp(r'\D');
  static final _regexpNonAlphaNumeric = RegExp(r'[^0-9a-zA-Z]');

  static ETCNPJ? parse(String cnpj) {
    if (cnpj.length < 14) return null;

    cnpj = cnpj.trim();

    if (cnpj.length < 14) return null;

    cnpj = cnpj.replaceAll(_regexpNonAlphaNumeric, '').toUpperCase();

    if (cnpj.length != 14) return null;

    var dv = cnpj.substring(8 + 4, 8 + 4 + 2);
    dv = dv.replaceAll(_regexpNonNumeric, '');

    if (dv.length != 2) return null;

    var code = cnpj.substring(0, 8);
    var branch = cnpj.substring(8, 8 + 4);

    return ETCNPJ(code, branch, dv: dv);
  }

  @override
  int get typeID => TYPE_ID;

  @override
  String get typeName => TYPE_NAME;

  String get code => _code;

  String get branch => _branch;

  String? _dv;

  String get dv => _dv ??= _buildDV(code: _code, branch: branch);

  static const _weightsDV1 = <int>[5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
  static const _weightsDV2 = <int>[6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
  static final _code0 = '0'.codeUnitAt(0);

  static String _buildDV({String? cnpj, String? code, String? branch}) {
    cnpj ??= '$code$branch';

    if (cnpj.length < 12) {
      throw ArgumentError('Invalid CNPJ code length: ${cnpj.length}');
    }

    if (cnpj.length > 14) {
      cnpj = cnpj.substring(0, 12);
    }

    cnpj = cnpj.toUpperCase();

    // DB1:
    var sum1 = 0;
    for (var i = 0; i < 12; i++) {
      sum1 += (cnpj.codeUnitAt(i) - _code0) * _weightsDV1[i];
    }

    var remainder1 = sum1 % 11;
    var dv1 = remainder1 < 2 ? 0 : 11 - remainder1;

    // DV2:
    var sum2 = 0;
    for (var i = 0; i < 12; i++) {
      sum2 += (cnpj.codeUnitAt(i) - _code0) * _weightsDV2[i];
    }
    sum2 += dv1 * _weightsDV2[12];

    var remainder2 = sum2 % 11;
    var dv2 = remainder2 < 2 ? 0 : 11 - remainder2;

    return '$dv1$dv2';
  }

  @override
  String encodeAsString({bool pretty = false}) => pretty
      ? '${_code.substring(0, 2)}.${_code.substring(2, 5)}.${_code.substring(5, 8)}/$branch-$dv'
      : '$_code$branch$dv';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ETCNPJ &&
          runtimeType == other.runtimeType &&
          _code == other._code &&
          _branch == other._branch;

  @override
  int get hashCode => _code.hashCode ^ _branch.hashCode;

  @override
  String toString() {
    return encodeAsString();
  }
}
