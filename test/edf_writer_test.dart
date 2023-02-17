import 'dart:io';

import 'package:dartedflib/edflib.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:random_string/random_string.dart';
import 'package:test/test.dart';

Matcher containsMinsAndMaxes(
    {required num physicalMin,
    required num physicalMax,
    required int digitalMin,
    required int digitalMax}) {
  // the second channel is the annotation channel and contains the defaults anyways.
  return matches(
      '$physicalMin\\s+\\-1\\s+$physicalMax\\s+1\\s+$digitalMin\\s+\\-32768\\s+$digitalMax\\s+32767');
}

void main() async {
  late final Directory tempDir;
  late String filePath;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync();
  });

  setUp(() {
    final fileName = '${randomAlphaNumeric(7)}.edf';
    filePath = path.join(tempDir.path, fileName);
  });

  tearDownAll(() async {
    await tempDir.delete(recursive: true);
  });

  group(EdfWriter, () {
    test('construct and close without errors', () {
      final writer = EdfWriter(fileName: filePath, numberOfChannels: 1);
      try {
        expect(File(filePath).existsSync(), true);
      } finally {
        writer.close();
      }
    });

    group('setSignalHeaders', () {
      test('empty map keeps defaults', () async {
        final writer = EdfWriter(fileName: filePath, numberOfChannels: 1);
        try {
          expect(File(filePath).existsSync(), true);
          writer.setSignalHeaders({});
          writer.close();
          final result = await File(filePath).readAsString();
          final expectedStartDate =
              DateFormat('dd-MMM-y').format(DateTime.now()).toUpperCase();
          expect(result, contains('Startdate $expectedStartDate'));
          expect(
              result,
              containsMinsAndMaxes(
                  digitalMin: -32768,
                  digitalMax: 32767,
                  physicalMin: -1,
                  physicalMax: 1));
          expect(result, contains('mV'));
          expect(result, contains('EDF+C'));
          expect(result, contains('ch0'));
        } finally {
          writer.close();
        }
      });

      test('overwrite physical min', () async {
        final writer = EdfWriter(fileName: filePath, numberOfChannels: 1);
        try {
          expect(File(filePath).existsSync(), true);
          writer.setSignalHeaders({'physical_min': -300.1});
          writer.close();
          final result = await File(filePath).readAsString();
          expect(
              result,
              containsMinsAndMaxes(
                  digitalMin: -32768,
                  digitalMax: 32767,
                  physicalMin: -300.1,
                  physicalMax: 1));
        } finally {
          writer.close();
        }
      });

      test('overwrite physical max', () async {
        final writer = EdfWriter(fileName: filePath, numberOfChannels: 1);
        try {
          expect(File(filePath).existsSync(), true);
          writer.setSignalHeaders({'physical_max': 300.1});
          writer.close();
          final result = await File(filePath).readAsString();
          expect(
              result,
              containsMinsAndMaxes(
                  digitalMin: -32768,
                  digitalMax: 32767,
                  physicalMin: -1,
                  physicalMax: 300.1));
        } finally {
          writer.close();
        }
      });

      test('overwrite digital min', () async {
        final writer = EdfWriter(fileName: filePath, numberOfChannels: 1);
        try {
          expect(File(filePath).existsSync(), true);
          writer.setSignalHeaders({'digital_min': -250});
          writer.close();
          final result = await File(filePath).readAsString();
          expect(
              result,
              containsMinsAndMaxes(
                  digitalMin: -250,
                  digitalMax: 32767,
                  physicalMin: -1,
                  physicalMax: 1));
        } finally {
          writer.close();
        }
      });

      test('overwrite digital max', () async {
        final writer = EdfWriter(fileName: filePath, numberOfChannels: 1);
        try {
          expect(File(filePath).existsSync(), true);
          writer.setSignalHeaders({'digital_max': 250});
          writer.close();
          final result = await File(filePath).readAsString();
          expect(
              result,
              containsMinsAndMaxes(
                  digitalMin: -32768,
                  digitalMax: 250,
                  physicalMin: -1,
                  physicalMax: 1));
        } finally {
          writer.close();
        }
      });
    });

    group('writeSamples', () {
      test('simple signal', () {
        final data = [List<num>.filled(500, 0.1), List.filled(500, 0.2)];
        final writer = EdfWriter(fileName: filePath, numberOfChannels: 2);
        try {
          expect(File(filePath).existsSync(), true);
          writer.setSignalHeaders({'sample_frequency': 100});
          writer.writeSamples(data);
        } finally {
          writer.close();
        }
      });
    });
  });
}
