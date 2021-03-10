import 'dart:io';

import 'package:extended_type/extended_type.dart';
import 'package:swiss_knife/swiss_knife_vm.dart';

void main() {
  var dataURLBase64 =
      'data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOulrSOp3WOyDZu6QdvCchPGolfO0o/XBs/fNwfjZ0frl3/zy7////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAkAABAALAAAAAAQABAAAAVVICSOZGlCQAosJ6mu7fiyZeKqNKToQGDsM8hBADgUXoGAiqhSvp5QAnQKGIgUhwFUYLCVDFCrKUE1lBavAViFIDlTImbKC5Gm2hB0SlBCBMQiB0UjIQA7';

  var etData = ETDataBase64URL.parse(dataURLBase64)!;

  if (etData.isImage) {
    var fileName = etData.isImageJPEG ? 'image.jpeg' : 'image.png';
    saveFileBytes(File(fileName), etData.data);
  }
}
