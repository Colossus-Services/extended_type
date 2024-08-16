import 'package:extended_type/extended_type_br.dart';
import 'package:test/test.dart';

void main() {
  group('ExtendedType', () {
    setUp(() {});

    test('ETCNPJ', () {
      var c1 = '12.345.678/0001-95';
      var c2 = 'A2.345.678/0001-63';
      var cErrDV1 = '12.345.678/0001-85';
      var cErrDV2 = '12.345.678/0001-91';

      expect(ETCNPJ.matchesFormat(c1), isTrue);
      expect(ETCNPJ.matchesFormat(c2), isTrue);

      expect(ETCNPJ.matchesFormat('1234567890'), isFalse);
      expect(ETCNPJ.matchesFormat(cErrDV1), isFalse);
      expect(ETCNPJ.matchesFormat(cErrDV2), isFalse);

      var etCNPJ1 = ETCNPJ.parse(c1);

      expect(etCNPJ1!.code, equals('12345678'));
      expect(etCNPJ1.branch, equals('0001'));
      expect(etCNPJ1.dv, equals('95'));

      var etCNPJ2 = ETCNPJ.parse(c2);

      expect(etCNPJ2!.code, equals('A2345678'));
      expect(etCNPJ2.branch, equals('0001'));
      expect(etCNPJ2.dv, equals('63'));
    });
  });
}
