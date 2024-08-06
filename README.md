# Extended_Type

[![pub package](https://img.shields.io/pub/v/extended_type.svg?logo=dart&logoColor=00b9fc)](https://pub.dartlang.org/packages/extended_type)
[![Null Safety](https://img.shields.io/badge/null-safety-brightgreen)](https://dart.dev/null-safety)
[![Dart CI](https://github.com/Colossus-Services/extended_type/actions/workflows/dart.yml/badge.svg?branch=master)](https://github.com/Colossus-Services/extended_type/actions/workflows/dart.yml)
[![GitHub Tag](https://img.shields.io/github/v/tag/Colossus-Services/extended_type?logo=git&logoColor=white)](https://github.com/Colossus-Services/extended_type/releases)
[![New Commits](https://img.shields.io/github/commits-since/Colossus-Services/extended_type/latest?logo=git&logoColor=white)](https://github.com/Colossus-Services/extended_type/network)
[![Last Commits](https://img.shields.io/github/last-commit/Colossus-Services/extended_type?logo=git&logoColor=white)](https://github.com/Colossus-Services/extended_type/commits/master)
[![Pull Requests](https://img.shields.io/github/issues-pr/Colossus-Services/extended_type?logo=github&logoColor=white)](https://github.com/Colossus-Services/extended_type/pulls)
[![Code size](https://img.shields.io/github/languages/code-size/Colossus-Services/extended_type?logo=github&logoColor=white)](https://github.com/Colossus-Services/extended_type)
[![License](https://img.shields.io/github/license/Colossus-Services/extended_type?logo=open-source-initiative&logoColor=green)](https://github.com/Colossus-Services/extended_type/blob/master/LICENSE)

Collection of platform agnostic types that can be converted from/to JSON and used in databases and UI.

## Usage

A simple usage example:

```dart
import 'package:extended_type/extended_type.dart';

main() {

  // URL Type:

  var etURL = ETURL('http://www.google.com/');

  // Automatic format identification:

  ETURL etURL2 = ExtendedType.from('http://www.google.com/')! ;

  // Data-URL-Base64 type:
  
  var etDataUrl = ETDataBase64URL.parse('data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOulrSOp3WOyDZu6QdvCchPGolfO0o/XBs/fNwfjZ0frl3/zy7////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAkAABAALAAAAAAQABAAAAVVICSOZGlCQAosJ6mu7fiyZeKqNKToQGDsM8hBADgUXoGAiqhSvp5QAnQKGIgUhwFUYLCVDFCrKUE1lBavAViFIDlTImbKC5Gm2hB0SlBCBMQiB0UjIQA7')! ;
      
  print( etDataUrl.mimeType ); // Outputs: image/gif
  print( etDataUrl.dataLength ); // Outputs: 216

}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/Colossus-Services/extended_type/issues

## Colossus.Services

This is an open-source project from [Colossus.Services][colossus]:
the gateway for smooth solutions.

## Author

Graciliano M. Passos: [gmpassos@GitHub][gmpassos_github].

## License

[Apache License - Version 2.0][apache_license]



[gmpassos_github]: https://github.com/gmpassos
[colossus]: https://colossus.services/
[artistic_license]: https://github.com/Colossus-Services/extended_type/blob/master/LICENSE

