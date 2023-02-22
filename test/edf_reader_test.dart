import 'dart:io';
import 'dart:math';

import 'package:dartedflib/src/edf_error.dart';
import 'package:dartedflib/src/edf_reader.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  late final String edfDataFile;
  late final String edfSubsecondFile;

  setUp(() {
    edfDataFile =
        path.join(Directory.current.path, 'test', 'data', 'test_generator.edf');
    edfSubsecondFile =
        path.join(Directory.current.path, 'test', 'data', 'test_subsecond.edf');
  });

  group(EdfReader, () {
    group('readSignal', () {
      test('edf file from test generator', () {
        final reader = EdfReader(edfDataFile);
        try {
          // TODO: Implement annotations
          // ann_index, ann_duration, ann_text = f.readAnnotations()
          // np.testing.assert_almost_equal(ann_index[0], 0)
          // np.testing.assert_almost_equal(ann_index[1], 600)

          expect(reader.signalsInFile, 11);
          expect(reader.dataRecordsInFile, 600);

          for (int i = 0; i < 11; i++) {
            expect(reader.getSampleFrequencies()[i], closeTo(200, 0.1));
            expect(reader.getNumberOfSamples()[i], 120000);
          }
        } finally {
          reader.close();
        }
      });
    });

    test('index errors thrown when out of bounds', () {
      final reader = EdfReader(edfDataFile);
      try {
        for (var i = 0; i <= 10; i++) {
          reader.readSignal(i);
        }

        expect(() => reader.readSignal(-1), throwsA(isA<EdfError>()));
        expect(() => reader.readSignal(11), throwsA(isA<EdfError>()));
      } finally {
        reader.close();
      }
    });

    test('read header infos', () {
      final reader = EdfReader(edfDataFile);
      try {
        final dateTimeSoll = DateTime(2011, 4, 4, 12, 57, 2);
        expect(reader.getStartDatetime(), dateTimeSoll);
        expect(reader.getPatientCode(), 'abcxyz99');
        expect(reader.getPatientName(), 'Hans Muller');
        expect(reader.getGender(), 'Male');
        expect(reader.getBirthdate(), DateTime(1969, 6, 30));
        expect(reader.getPatientAdditional(), 'patient');
        expect(reader.getAdminCode(), 'Dr. X');
        expect(reader.getTechnician(), 'Mr. Spotty');
        expect(reader.getEquipment(), 'test generator');
        expect(reader.getRecordingAdditional(), 'unit test file');
        expect(reader.fileDuration, 600);
      } finally {
        reader.close();
      }
    });

    test('read signal infos', () {
      final reader = EdfReader(edfDataFile);
      try {
        expect(reader.getSignalLabels().first, 'squarewave');
        expect(reader.getLabel(0), 'squarewave');
        expect(reader.getPrefilter(0), 'pre1');
        expect(reader.getTransducer(0), 'trans1');

        for (var i = 1; i < 11; i++) {
          expect(reader.getPhysicalDimension(i), 'uV');
          expect(reader.getSampleFrequency(i), 200);
          expect(reader.getSampleFrequencies()[i], 200);
        }

        expect(reader.getSignalLabels().sublist(1), [
          'ramp',
          'pulse',
          'noise',
          'sine 1 Hz',
          'sine 8 Hz',
          'sine 8.1777 Hz',
          'sine 8.5 Hz',
          'sine 15 Hz',
          'sine 17 Hz',
          'sine 50 Hz',
        ]);
      } finally {
        reader.close();
      }
    });

    test('read subsecond', () {
      final reader = EdfReader(edfSubsecondFile);
      try {
        expect(
            reader.getStartDatetime(), DateTime(2020, 1, 24, 4, 5, 56, 39453));
      } finally {
        reader.close();
      }
    });
  });
}
