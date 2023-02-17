import 'dart:ffi';
import 'dart:math';

import 'package:dartedflib/src/edf_error.dart';
import 'package:ffi/ffi.dart';

import 'annotations_mode.dart';
import 'bindings.dart';
import 'dylib.dart';

extension on num {
  num roundToDecimals(int places) {
    num mod = pow(10.0, places);
    return ((this * mod).round().toDouble() / mod);
  }
}

class EdfReader {
  static const openErrors = {
    EDFLIB_MALLOC_ERROR: "malloc error",
    EDFLIB_NO_SUCH_FILE_OR_DIRECTORY:
        "can not open file, no such file or directory",
    EDFLIB_FILE_CONTAINS_FORMAT_ERRORS:
        "the file is not EDF(+) or BDF(+) compliant (it contains format errors)",
    EDFLIB_MAXFILES_REACHED: "to many files opened",
    EDFLIB_FILE_READ_ERROR: "a read error occurred",
    EDFLIB_FILE_ALREADY_OPENED: "file has already been opened",
    EDFLIB_FILETYPE_ERROR: "Wrong file type",
    EDFLIB_FILE_WRITE_ERROR: "a write error occurred",
    EDFLIB_NUMBER_OF_SIGNALS_INVALID: "The number of signals is invalid",
    EDFLIB_FILE_IS_DISCONTINUOUS:
        "The file is discontinuous and cannot be read",
    EDFLIB_INVALID_READ_ANNOTS_VALUE: "an annotation value could not be read",
  };

  /// EdfReader(file_name, annotations_mode, check_file_size)
  EdfReader(String fileName,
      {AnnotationsMode annotationsMode = AnnotationsMode.readAllAnnotations})
      : _fileName = fileName {
    _handle.ref.handle = -1;
    _open(fileName, annotationsMode: annotationsMode);
  }

  final Pointer<EdfHdr> _handle = calloc<EdfHdr>();
  final String _fileName;

  void close() {
    calloc.free(_handle);
  }

  /// Returns the physical data of signal chn. When start and n is set, a subset is returned
  ///   Parameters
  ///   ----------
  ///   [channel] : [int]
  ///       channel number
  ///   [start] : [int]
  ///       start pointer (default is 0)
  ///   [length] : [int]
  ///       length of data to read (default is None, by which the complete data of the channel are returned)
  ///   [digital] : [bool]
  ///       will return the signal in original digital values instead of physical values
  Iterable<num> readSignal(int channel,
      {int start = 0, int? length, bool digital = false}) {
    if (start < 0) {
      return Iterable<num>.empty();
    }
    if (length != null && length < 0) {
      return Iterable<num>.empty();
    }
    final List<int> numberOfSamples = getNumberOfSamples();
    if (0 <= channel && channel < numberOfSamples.length) {
      if (length == null) {
        length = numberOfSamples[channel];
      } else if (length > numberOfSamples[channel]) {
        return Iterable<num>.empty();
      }
      if (digital) {
        return _readDigitalSignal(channel, start, length);
      } else {
        return _readSignal(channel, start, length);
      }
    } else {
      throw EdfError(
          'Trying to access channel $channel, but only $signalsInFile channels found');
    }
  }

  /// Returns sample frequencies of all signals.
  List<num> getSampleFrequencies() {
    final result = <num>[];
    for (int i = 0; i < signalsInFile; i++) {
      result.add(getSampleFrequency(i));
    }

    return result;
  }

  /// Returns the samplefrequency of signal.
  /// [channel] : [int] channel number
  num getSampleFrequency(int channel) {
    return _handle.ref.signalparam[channel].smp_in_datarecord
        .toDouble()
        .roundToDecimals(3);
  }

  List<int> getNumberOfSamples() {
    final result = <int>[];
    for (int i = 0; i < signalsInFile; i++) {
      result.add(_samplesInChannel(i));
    }

    return result;
  }

  int get signalsInFile => _handle.ref.edfsignals;
  int get dataRecordsInFile => _handle.ref.datarecords_in_file;

  int _samplesInChannel(int channel) {
    return _handle.ref.signalparam[channel].smp_in_file;
  }

  Iterable<int> _readDigitalSignal(int channel, int start, int length) sync* {
    dylib.seek(_handle.ref.handle, channel, start, EDFSEEK_SET);
    final buffer = malloc.allocate<Int>(sizeOf<Int>() * length);
    final int samplesRead =
        dylib.read_digital_samples(_handle.ref.handle, channel, length, buffer);
    if (samplesRead != length) {
      print("read $samplesRead, less than $length requested!!!");
    }

    for (int i = 0; i < samplesRead; i++) {
      yield buffer.elementAt(i).value;
    }

    malloc.free(buffer);
  }

  Iterable<double> _readSignal(int channel, int start, int length) sync* {
    dylib.seek(_handle.ref.handle, channel, start, EDFSEEK_SET);
    final buffer = malloc.allocate<Double>(sizeOf<Double>() * length);
    final int samplesRead = dylib.read_physical_samples(
        _handle.ref.handle, channel, length, buffer);
    if (samplesRead != length) {
      print("read $samplesRead, less than $length requested!!!");
    }

    for (int i = 0; i < samplesRead; i++) {
      yield buffer.elementAt(i).value;
    }

    malloc.free(buffer);
  }

  void _open(String fileName,
      {AnnotationsMode annotationsMode = AnnotationsMode.readAllAnnotations}) {
    final result = dylib.open_file_readonly(
        fileName.toNativeUtf8().cast<Char>(),
        _handle,
        annotationsMode.toNative());

    if (result != 0) {
      final String msg = openErrors[_handle.ref.filetype] ?? 'unknown error';
      throw EdfError('$msg for file $fileName');
    }
  }
}
