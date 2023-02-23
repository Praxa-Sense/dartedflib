import 'dart:io';
import 'dart:math';

import 'package:dartedflib/edflib.dart';
import 'package:dartedflib/src/edf_error.dart';
import 'package:dartedflib/src/edf_reader.dart';
import 'package:dartedflib/src/file_type.dart';
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

// copied from package:numdart
List<double> linspace(double start, double stop, int delta) {
  double incrementCount = (stop - start) / delta;
  List<double> base = List<double>.generate(
      delta + 1, (index) => start.toDouble() + index * incrementCount);

  return base;
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

  test('exceptions raised', () {
    final numberOfChannels = 5;
    final writer =
        EdfWriter(fileName: filePath, numberOfChannels: numberOfChannels);

    final functionsToTest = [writer.setSignalHeader];

    try {
      for (var f in functionsToTest) {
        expect(() => f(-1, {}), throwsA(isA<EdfError>()));
        expect(() => f(numberOfChannels + 1, {}), throwsA(isA<EdfError>()));
      }
    } finally {
      writer.close();
    }
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

      test('writeSamples floats as digital throw error', () {
        const dMin = 0;
        const dMax = 1024;
        const pMin = 0.0;
        const pMax = 1.0;

        const channelInfo1 = {
          'label': 'test_label1',
          'dimension': 'mV',
          'sample_frequency': 100,
          'physical_max': pMax,
          'physical_min': pMin,
          'digital_max': dMax,
          'digital_min': dMin,
          'prefilter': 'pre1',
          'transducer': 'trans1'
        };
        const channelInfo2 = {
          'label': 'test_label2',
          'dimension': 'mV',
          'sample_frequency': 100,
          'physical_max': pMax,
          'physical_min': pMin,
          'digital_max': dMax,
          'digital_min': dMin,
          'prefilter': 'pre2',
          'transducer': 'trans2'
        };

        final writer = EdfWriter(fileName: filePath, numberOfChannels: 2);
        try {
          writer.setSignalHeader(0, channelInfo1);
          writer.setSignalHeader(1, channelInfo2);

          final data1 = List<num>.generate(500, (index) => index.toDouble());
          final data2 = List<num>.generate(500, (index) => index.toDouble());
          final allData = [data1, data2];

          expect(() => writer.writeSamples(allData, true),
              throwsA(isA<EdfError>()));
        } finally {
          writer.close();
        }
      });

      test('writeSamples ints as digital', () {
        const dMin = 0;
        const dMax = 1024;
        const pMin = 0.0;
        const pMax = 1.0;

        const channelInfo1 = {
          'label': 'test_label1',
          'dimension': 'mV',
          'sample_frequency': 100,
          'physical_max': pMax,
          'physical_min': pMin,
          'digital_max': dMax,
          'digital_min': dMin,
          'prefilter': 'pre1',
          'transducer': 'trans1'
        };
        const channelInfo2 = {
          'label': 'test_label2',
          'dimension': 'mV',
          'sample_frequency': 100,
          'physical_max': pMax,
          'physical_min': pMin,
          'digital_max': dMax,
          'digital_min': dMin,
          'prefilter': 'pre2',
          'transducer': 'trans2'
        };

        final writer = EdfWriter(fileName: filePath, numberOfChannels: 2);
        final data1 = List<num>.generate(500, (index) => index);
        final data2 = List<num>.generate(500, (index) => index);
        try {
          writer.setSignalHeader(0, channelInfo1);
          writer.setSignalHeader(1, channelInfo2);

          final allData = [data1, data2];

          writer.writeSamples(allData, true);
        } finally {
          writer.close();
        }

        final reader = EdfReader(filePath);
        try {
          // convert to digital
          final data1Read = reader
              .readSignal(0)
              .map((v) => (v - pMin) / ((pMax - pMin) / (dMax - dMin)));
          final data2Read = reader
              .readSignal(1)
              .map((v) => (v - pMin) / ((pMax - pMin) / (dMax - dMin)));
          expect(reader.fileType, FileType.edfPlus);
          expect(data1Read.length, data1.length);
          expect(data2Read.length, data2.length);
          expect(data1Read, data1);
          expect(data2Read, data2);
        } finally {
          reader.close();
        }
      });

      test('write samples with rounding', () {
        const channelInfo1 = {
          'label': 'test_label1',
          'dimension': 'mV',
          'sample_frequency': 100,
          'physical_max': 1.0,
          'physical_min': -1.0,
          'digital_max': 32767,
          'digital_min': -32768,
          'prefilter': 'pre1',
          'transducer': 'trans1'
        };

        final writer = EdfWriter(fileName: filePath, numberOfChannels: 1);
        final time = linspace(0, 5, 499);
        final data1 = time.map((t) => sin(2 * pi * 1 * t)).toList();
        final allData = [data1];
        try {
          writer.setSignalHeader(0, channelInfo1);
          writer.writeSamples(allData);
        } finally {
          writer.close();
        }

        final reader = EdfReader(filePath);
        try {
          final data1Read = reader.readSignal(0).toList();
          expect(reader.fileType, FileType.edfPlus);
          expect(data1Read.length, data1.length);
          for (var i = 0; i < data1Read.length; i++) {
            expect(data1Read[i], closeTo(data1[i], 0.0001));
          }
        } finally {
          reader.close();
        }
      });
    });
  });
}
