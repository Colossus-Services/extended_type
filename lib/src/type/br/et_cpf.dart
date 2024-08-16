import '../../extended_type_base.dart';

class _ExtendedTypeHandler extends ExtendedTypeHandler<ETCPF> {
  @override
  ETCPF? createInstance(String value) => ETCPF.parse(value);

  @override
  int getTypeID() => ETCPF.TYPE_ID;

  @override
  String getTypeName() => ETCPF.TYPE_NAME;

  @override
  bool matchesFormat(String value) => ETCPF.matchesFormat(value);
}

/// [ExtendedType] for CNPJ (br).
class ETCPF extends ExtendedType {
  static void initialize() {
    ExtendedType.registerTypeHandler(_ExtendedTypeHandler());
  }

  static bool matchesFormat(String data) {
    var length = data.length;
    if (length < 11) return false;

    data = data.replaceAll(_regexpNonNumeric, '');

    if (data.length != 11) return false;

    var dv = data.substring(9);

    var dvCheck = _buildDV(cpf: data);

    if (dv != dvCheck) return false;

    return true;
  }

  static bool matchesValid(String data) {
    if (!matchesFormat(data)) return false;
    var et = ETCPF.parse(data);
    return et?.validate() ?? false;
  }

  static final int TYPE_ID = 55101;

  static final String TYPE_NAME = 'cpf';

  final String _code;

  ETCPF(this._code, {String? dv}) : _dv = dv;

  static final _regexpNonNumeric = RegExp(r'\D');

  static ETCPF? parse(String cpf) {
    if (cpf.length < 11) return null;

    cpf = cpf.trim();

    if (cpf.length < 11) return null;

    cpf = cpf.replaceAll(_regexpNonNumeric, '').toUpperCase();

    if (cpf.length != 11) return null;

    var dv = cpf.substring(9);
    assert(dv.length == 2);

    var code = cpf.substring(0, 9);

    return ETCPF(code, dv: dv);
  }

  @override
  int get typeID => TYPE_ID;

  @override
  String get typeName => TYPE_NAME;

  String get code => _code;

  String? _dv;

  String get dv => _dv ??= _buildDV(code: _code);

  static final _code0 = '0'.codeUnitAt(0);

  static String _buildDV({String? cpf, String? code}) {
    cpf ??= code ?? '';

    if (cpf.length < 9) {
      throw ArgumentError('Invalid CPF length: ${cpf.length}');
    }

    // DV1:
    var sum1 = 0;
    for (var i = 0; i < 9; i++) {
      sum1 += (cpf.codeUnitAt(i) - _code0) * (10 - i);
    }
    var remainder1 = sum1 % 11;
    var dv1 = remainder1 < 2 ? 0 : 11 - remainder1;

    // DV2:
    var sum2 = 0;
    for (var i = 0; i < 9; i++) {
      sum2 += (cpf.codeUnitAt(i) - _code0) * (11 - i);
    }
    sum2 += dv1 * 2;
    var remainder2 = sum2 % 11;
    var dv2 = remainder2 < 2 ? 0 : 11 - remainder2;

    var dv = '$dv1$dv2';
    return dv;
  }

  static const invalids = <String>[
    '12345678900',
    '12345678909',
    '11111111111',
    '22222222222',
    '33333333333',
    '44444444444',
    '55555555555',
    '66666666666',
    '77777777777',
    '88888888888',
    '99999999999',
    '00000000000',
    '12345678901',
    '98765432100',
    '55544433322',
  ];

  @override
  bool validate() {
    return !invalids.contains(toString());
  }

  @override
  String encodeAsString({bool pretty = false}) => pretty
      ? '${_code.substring(0, 3)}.${_code.substring(3, 6)}.${_code.substring(6, 9)}-$dv'
      : '$_code$dv';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ETCPF &&
          runtimeType == other.runtimeType &&
          _code == other._code;

  @override
  int get hashCode => _code.hashCode;

  @override
  String toString() {
    return encodeAsString();
  }
}
