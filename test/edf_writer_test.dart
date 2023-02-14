import 'dart:io';

import 'package:dartedflib/edflib.dart';
import 'package:path/path.dart' as path;
import 'package:random_string/random_string.dart';
import 'package:test/test.dart';

void main() async {
  late final Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync();
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group(EdfWriter, () {
    test('construct and close without errors', () {
      final fileName = '${randomAlphaNumeric(7)}.edf';
      final filePath = path.join(tempDir.path, fileName);
      final writer = EdfWriter(fileName: filePath, numberOfChannels: 1);
      expect(File(filePath).existsSync(), true);
      writer.close();
    });
  });
}
