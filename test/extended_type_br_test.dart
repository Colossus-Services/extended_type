import 'package:extended_type/extended_type_br.dart';
import 'package:test/test.dart';

void main() {
  group('ExtendedType', () {
    setUp(() {});

    test('ETCNPJ', () {
      var c1 = '12.345.678/0001-95';
      var c2 = 'A2.345.678/0001-63';
      var c3 = '98666044000150';
      var c4 = '98666044000230';
      var cErrDV1 = '12.345.678/0001-85';
      var cErrDV2 = '12.345.678/0001-91';

      expect(ETCNPJ.matchesFormat(c1), isTrue);
      expect(ETCNPJ.matchesFormat(c2), isTrue);
      expect(ETCNPJ.matchesFormat(c3), isTrue);
      expect(ETCNPJ.matchesFormat(c4), isTrue);

      expect(ETCNPJ.matchesValid(c1), isFalse);
      expect(ETCNPJ.matchesValid(c2), isFalse);
      expect(ETCNPJ.matchesValid(c3), isTrue);
      expect(ETCNPJ.matchesValid(c4), isTrue);

      expect(ETCNPJ.matchesFormat('1234567890'), isFalse);
      expect(ETCNPJ.matchesFormat(cErrDV1), isFalse);
      expect(ETCNPJ.matchesFormat(cErrDV2), isFalse);

      var etCNPJ1 = ETCNPJ.parse(c1);
      expect(etCNPJ1!.code, equals('12345678'));
      expect(etCNPJ1.branch, equals('0001'));
      expect(etCNPJ1.dv, equals('95'));
      expect(etCNPJ1.validate(), isFalse);

      var etCNPJ2 = ETCNPJ.parse(c2);
      expect(etCNPJ2!.code, equals('A2345678'));
      expect(etCNPJ2.branch, equals('0001'));
      expect(etCNPJ2.dv, equals('63'));
      expect(etCNPJ2.validate(), isFalse);

      var etCNPJ3 = ETCNPJ.parse(c3);
      expect(etCNPJ3!.code, equals('98666044'));
      expect(etCNPJ3.branch, equals('0001'));
      expect(etCNPJ3.dv, equals('50'));
      expect(etCNPJ3.validate(), isTrue);

      var etCNPJ4 = ETCNPJ.parse(c4);
      expect(etCNPJ4!.code, equals('98666044'));
      expect(etCNPJ4.branch, equals('0002'));
      expect(etCNPJ4.dv, equals('30'));
      expect(etCNPJ4.validate(), isTrue);
    });

    test('ETCPF', () {
      var c1 = '123.456.789-09';
      var c2 = '111.111.111-11';
      var c3 = '88015716071';
      var c4 = '92563228034';
      var cErrDV1 = '123.456.789-10';
      var cErrDV2 = '123.456.789-01';

      expect(ETCPF.matchesFormat(c1), isTrue);
      expect(ETCPF.matchesFormat(c2), isTrue);
      expect(ETCPF.matchesFormat(c3), isTrue);
      expect(ETCPF.matchesFormat(c4), isTrue);

      expect(ETCPF.matchesValid(c1), isFalse);
      expect(ETCPF.matchesValid(c2), isFalse);
      expect(ETCPF.matchesValid(c3), isTrue);
      expect(ETCPF.matchesValid(c4), isTrue);

      expect(ETCPF.matchesFormat('123456789'), isFalse);
      expect(ETCPF.matchesFormat(cErrDV1), isFalse);
      expect(ETCPF.matchesFormat(cErrDV2), isFalse);

      var etCPF1 = ETCPF.parse(c1);
      expect(etCPF1!.code, equals('123456789'));
      expect(etCPF1.dv, equals('09'));
      expect(etCPF1.validate(), isFalse);

      var etCPF2 = ETCPF.parse(c2);
      expect(etCPF2!.code, equals('111111111'));
      expect(etCPF2.dv, equals('11'));
      expect(etCPF1.validate(), isFalse);

      var etCPF3 = ETCPF.parse(c3);
      expect(etCPF3!.code, equals('880157160'));
      expect(etCPF3.dv, equals('71'));
      expect(etCPF3.validate(), isTrue);

      var etCPF4 = ETCPF.parse(c4);
      expect(etCPF4!.code, equals('925632280'));
      expect(etCPF4.dv, equals('34'));
      expect(etCPF4.validate(), isTrue);
    });
  });
}
