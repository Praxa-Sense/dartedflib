import 'dart:io';

import 'package:dartedflib/src/edf_reader.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  late final String edfDataFile;

  setUp(() {
    edfDataFile =
        join(Directory.current.path, 'test', 'data', 'test_generator.edf');
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
  });
}
