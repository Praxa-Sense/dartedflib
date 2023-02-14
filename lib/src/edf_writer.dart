import 'dart:ffi';
import 'dart:io';

import 'package:dartedflib/src/file_type.dart';
import 'package:ffi/ffi.dart';

import 'dylib.dart';

class EdfWriter {
  EdfWriter(
      {required String fileName,
      required int numberOfChannels,
      FileType fileType = FileType.edfPlus})
      : _path = fileName,
        _numberOfChannels = numberOfChannels,
        _fileType = fileType,
        _numberOfAnnotations = _determineNumberOfAnnotations(fileType) {
    for (int i = 0; i < _numberOfChannels; i++) {
      if ([FileType.bdf, FileType.bdfPlus].contains(_fileType)) {
        channels.add({
          'label': 'ch$i',
          'dimension': 'mV',
          'sample_rate': 100,
          'sample_frequency': null,
          'physical_max': 1.0,
          'physical_min': -1.0,
          'digital_max': 8388607,
          'digital_min': -8388608,
          'prefilter': '',
          'transducer': '',
        });
      } else if ([FileType.edf, FileType.edfPlus].contains(_fileType)) {
        channels.add({
          'label': 'ch$i',
          'dimension': 'mV',
          'sample_rate': 100,
          'sample_frequency': null,
          'physical_max': 1.0,
          'physical_min': -1.0,
          'digital_max': 32767,
          'digital_min': -32768,
          'prefilter': '',
          'transducer': ''
        });
      }
    }
    _handle = dylib.open_file_writeonly(_path.toNativeUtf8().cast<Char>(),
        _fileType.toNative(), _numberOfChannels);

    if (_handle < 0) {
      throw FileSystemException('Unable to open file for writing', _path);
    }
  }

  final String _path;
  final FileType _fileType;
  late int _handle;
  String _patientName = '';
  String _patientCode = '';
  String _technician = '';
  String _equipment = '';
  String _recording_additional = '';
  String _patient_additional = '';
  String _adminCode = '';
  int? _gender = null;
  DateTime _recordingStartTime = DateTime.now();
  DateTime? _birthDate = null;

  /// Duration of the record in units of 10 ms.
  int _duration = 1;
  final _numberOfAnnotations;
  final int _numberOfChannels;
  final List<Map<String, dynamic>> channels = [];

  /// Closes the file.
  void close() {
    dylib.close_file(_handle);
    _handle = -1;
  }

  /// Sets the parameters for all signals
  ///
  /// [signalHeaders] is a map of strings of the following format:
  /// 'label' : String
  ///   channel label (string, <= 16 characters, must be unique)
  /// 'dimension' : String
  ///   physical dimension (e.g., mV) (string, <= 8 characters)
  /// 'sample_rate' : Int
  ///   sample frequency in hertz (int). Deprecated: use 'sample_frequency' instead.
  /// 'sample_frequency' : Int
  ///   number of samples per record
  /// 'physical_max' : Float
  ///   maximum physical value
  /// 'physical_min' : Float
  ///   minimum physical value
  /// 'digital_max' : Int
  ///   maximum digital value (-2**15 <= x < 2**15)
  /// 'digital_min' : Int
  ///   minimum digital value (-2**15 <= x < 2**15)
  void setSignalHeaders(Map<String, dynamic> signalHeaders) {}

  static int _determineNumberOfAnnotations(FileType fileType) {
    return [FileType.edfPlus, FileType.bdfPlus].contains(fileType) ? 1 : 0;
  }
}
