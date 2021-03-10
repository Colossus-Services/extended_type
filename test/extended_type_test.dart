import 'package:extended_type/extended_type.dart';
import 'package:extended_type/src/type/et_data_base64_url.dart';
import 'package:extended_type/src/type/et_url.dart';
import 'package:test/test.dart';

void main() {
  group('ExtendedType', () {
    setUp(() {});

    test('ETURL', () {
      var s = 'http://www.google.com/';

      expect(ETURL.matchesFormat(s), isTrue);
      expect(ETURL.matchesFormat('http scheme'), isFalse);

      var etURL = ETURL(s);

      expect(etURL.url, equals('http://www.google.com/'));

      expect(etURL.getParameters(), isNull);
      expect(etURL.getParametersLine(), isNull);
      expect(etURL.getOperations(), isNull);
      expect(etURL.getAvailableOperations(), isNull);

      var etURL2 = ETURL(s);
      expect(etURL, equals(etURL2));

      var etURL3 = ExtendedType.from('http://www.google.com/');

      expect(etURL, equals(etURL3));

      var s2 = 'https://dart.dev/';
      var etURL4 = ExtendedType.from(s2) as ETURL;

      expect(etURL4.url, equals('https://dart.dev/'));

      expect(ExtendedType.identifyTypeID(s2), equals(ETURL.TYPE_ID));
      expect(ExtendedType.identifyTypeName(s2), equals(ETURL.TYPE_NAME));
    });

    test('ETEmail', () {
      var s = 'joe@mail.com';

      expect(ETEmail.matchesFormat(s), isTrue);
      expect(ETEmail.matchesFormat('@a'), isFalse);
      expect(ETEmail.matchesFormat('a@'), isFalse);
      expect(ETEmail.matchesFormat('@'), isFalse);
      expect(ETEmail.matchesFormat('asdasd'), isFalse);
      expect(ETEmail.matchesFormat(''), isFalse);

      var etEmail = ETEmail.parse(s)!;

      expect(etEmail.user, equals('joe'));
      expect(etEmail.host, equals('mail.com'));

      var etEmail2 = ETEmail.parse(s);
      expect(etEmail, equals(etEmail2));

      var etEmail3 = ExtendedType.from(s);

      expect(etEmail, equals(etEmail3));

      var s2 = 'smith+x@mail2.com';
      var etEmail4 = ExtendedType.from(s2) as ETEmail;

      expect(etEmail4.user, equals('smith'));
      expect(etEmail4.tag, equals('x'));
      expect(etEmail4.host, equals('mail2.com'));

      expect(ExtendedType.identifyTypeID(s2), equals(ETEmail.TYPE_ID));
      expect(ExtendedType.identifyTypeName(s2), equals(ETEmail.TYPE_NAME));
    });

    test('ETEntityReference', () {
      var s = 'user#11';

      expect(ETEntityReference.matchesFormat(s), isTrue);
      expect(ETEntityReference.matchesFormat('#1'), isFalse);
      expect(ETEntityReference.matchesFormat('a#'), isFalse);
      expect(ETEntityReference.matchesFormat('#'), isFalse);
      expect(ETEntityReference.matchesFormat('asdasd'), isFalse);
      expect(ETEntityReference.matchesFormat(''), isFalse);

      var etRef = ETEntityReference.parse(s)!;

      expect(etRef.type, equals('user'));
      expect(etRef.id, equals(11));

      var etRef2 = ETEntityReference.parse(s);
      expect(etRef, equals(etRef2));

      var etRef3 = ExtendedType.from(s);

      expect(etRef, equals(etRef3));

      var s2 = 'task#101';
      var etRef4 = ExtendedType.from(s2) as ETEntityReference;

      expect(etRef4.type, equals('task'));
      expect(etRef4.id, equals(101));

      expect(
          ExtendedType.identifyTypeID(s2), equals(ETEntityReference.TYPE_ID));
      expect(ExtendedType.identifyTypeName(s2),
          equals(ETEntityReference.TYPE_NAME));
    });

    test('ETDataBase64URL', () {
      var s =
          'data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOulrSOp3WOyDZu6QdvCchPGolfO0o/XBs/fNwfjZ0frl3/zy7////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAkAABAALAAAAAAQABAAAAVVICSOZGlCQAosJ6mu7fiyZeKqNKToQGDsM8hBADgUXoGAiqhSvp5QAnQKGIgUhwFUYLCVDFCrKUE1lBavAViFIDlTImbKC5Gm2hB0SlBCBMQiB0UjIQA7';

      expect(ETDataBase64URL.matchesFormat(s), isTrue);
      expect(ETDataBase64URL.matchesFormat('data:image'), isFalse);

      var etData = ETDataBase64URL.parse(s)!;

      expect(etData.mimeType.toString(), equals('image/gif'));
      expect(etData.dataLength, equals(216));

      expect(etData.getParameters(), isNull);
      expect(etData.getParametersLine(), isNull);
      expect(etData.getOperations(), isNotEmpty);
      expect(etData.getAvailableOperations(), isNotEmpty);

      var etData2 = ETDataBase64URL.parse(etData.encodeAsString())!;

      expect(etData.dataLength, equals(etData2.dataLength));
      expect(etData.data, equals(etData2.data));
      expect(etData, equals(etData2));

      var s2 =
          'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAP//////////////////////////////////////////////////////////////////////////////////////2wBDAf//////////////////////////////////////////////////////////////////////////////////////wAARCADqATkDASIAAhEBAxEB/8QAFwABAQEBAAAAAAAAAAAAAAAAAAECA//EACQQAQEBAAIBBAMBAQEBAAAAAAABESExQQISUXFhgZGxocHw/8QAFQEBAQAAAAAAAAAAAAAAAAAAAAH/xAAWEQEBAQAAAAAAAAAAAAAAAAAAEQH/2gAMAwEAAhEDEQA/AMriLyCKgg1gQwCgs4FTMOdutepjQak+FzMSVqgxZdRdPPIIvH5WzzGdBriphtTeAXg2ZjKA1pqKDUGZca3foBek8gFv8Ie3fKdA1qb8s7hoL6eLVt51FsAnql3Ut1M7AWbflLMDkEMX/F6/YjK/pADFQAUNA6alYagKk72m/j9p4Bq2fDDSYKLNXPNLoHE/NT6RYC31cJxZ3yWVM+aBYi/S2ZgiAsnYJx5D21vPmqrm3PTfpQQwyAC8JZvSKDni41ZrMuUVVl+Uz9w9v/1QWrZsZ5nFPHYH+JZyureQSF5M+fJ0CAfwRAVRBQA1DAWVUayoJUWoDpsxntPsueBV4+VxhdyAtv8AjOLGpIDMLbeGvbF4iozJfr/WukAVABAXAQXEAAASzVAZdO2WNordm+emFl7XcQSNZiFtv0C9w90nhJf4mA1u+GcJFwIyAqL/AOovwgGNfSRqdIrNa29M0gKCAojU9PAMjWXpckEJFNFEAAXEUBABYz6rZ0ureQc9vyt9XxDF2QAXtABcQAs0AZywkvluJbyipifas52DcyxjlZweAO0xri/hc+wZOEKIu6nSyeToVZyWXwvCg53gW81QQ7aTNAn5dGZJPs1UXURQAUEMCXQLZE93PRZ5hPTgNMrbIzKCm52LZwCs+2M8w2g3sjPuZAXb4IsMAUACzVUGM4/K+md6vEXUUyM5PDR0IxYe6ramih0VNBrS4xoqN8Q1BFQk3yqyAsioioAAKgDSJL4/jQIn5igLrPqtOuf6oOaxbMoAltUAhhIoJiiggrPu+AaOIxtAX3JbaAIaLwi4t9X4T3fg2AFtqcrUUarP20zUDAmqoE0WRBZPNVUVEAAAAVAC8kvih2DSKxOdBqs7Z0l0gI0mKAC4AuHE7ZtBriM+744QAAAAABAFsveIttBICyaikvy1+r/Cen5rWQHIBQa4rIDRqSl5qDWqziqgAAAATA7BpGdqXb2C2+J/UgAtRQBSQtkBWb6vhLbQAAAAAEBRAAAAAUbm+GZNdPxAP+ql2Tjwx7/wIgZ8iKvBk+CJoCXii9gaqZ/qqihAAAEVABGkBFUwBftNkZ3QW34QAAABFAQAVAAAAAARVkl8gs/43sk1jL45LvHArepk+E9XTG35oLqsmIKmLAEygKg0y1AFQBUXwgAAAoBC34S3UAAABAVAAAAAABAUQAVABdRQa1PcYyit2z58M8C4ouM2NXpOEGeWtNZUatiAIoAKIoCoAoG4C9MW6dgIoAIAAAAAAACKWAgL0CAAAALiANCKioNLgM1CrLihmTafkt1EF3SZ5ZVUW4mnIKvAi5fhEURVDWVQBRAAAAAAAAQFRVyAyulgAqCKlF8IqLsEgC9mGoC+IusqCrv5ZEUVOk1RuJfwSLOOkGFi4XPCoYYrNiKauosBGi9ICstM1UAAAAAAFQ0VcTBAXUGgIqGoKhKAzRRUQUAwxoSrGRpkQA/qiosOL9oJptMRRVZa0VUqSiChE6BqMgCwqKqIogAIAqKCKgKoogg0lBFuIKgAAAKNRlf2gqsftsEtZWoAAqAACKoMqAAeSoqp39kL2AqLOlE8rEBFQARYALhigrNC9gGmooLp4TweEQFFBFAECgIoAu0ifIAqAAA//9k=';
      var etURL3 = ExtendedType.from(s2) as ETDataBase64URL;

      expect(etURL3.mimeType.toString(), equals('image/jpeg'));

      expect(ExtendedType.identifyTypeID(s2), equals(ETDataBase64URL.TYPE_ID));
      expect(
          ExtendedType.identifyTypeName(s2), equals(ETDataBase64URL.TYPE_NAME));
    });
  });
}
