import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

Future imageToForm(XFile? img) async {
  if (img == null) return null;

  return await MultipartFile.fromFile(img.path,
      filename: img.name,
      contentType: MediaType.parse("${lookupMimeType(basename(img.name))}"));
}
