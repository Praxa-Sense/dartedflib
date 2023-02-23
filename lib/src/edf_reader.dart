import 'dart:ffi';
import 'dart:math';

import 'package:dartedflib/src/edf_error.dart';
import 'package:ffi/ffi.dart';

import 'annotations_mode.dart';
import 'bindings.dart';
import 'dylib.dart';
import 'file_type.dart';

extension on num {
  num roundToDecimals(int places) {
    num mod = pow(10.0, places);
    return ((this * mod).round().toDouble() / mod);
  }
}

extension on Array<Char> {
  /// Convert the char array to a dart string.
  /// Searches for a 0 terminator.
  ///
  /// Arrays cannot be casted to pointers. There is an open ticket for this:
  /// https://github.com/dart-lang/ffigen/issues/504
  String toDartString() {
    final stringList = <int>[];
    var i = 0;
    while (this[i] != 0) {
      stringList.add(this[i]);
      i++;
    }

    return String.fromCharCodes(stringList).trimRight();
  }
}

/// This provides a simple interface to read EDF, EDF+, BDF and BDF+ files.
class EdfReader {
  static const _openErrors = {
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

  /// Open an EDF file in read-only mode.
  EdfReader(String fileName,
      {AnnotationsMode annotationsMode = AnnotationsMode.readAllAnnotations})
      : _fileName = fileName {
    _handle.ref.handle = -1;
    _open(fileName, annotationsMode: annotationsMode);
  }

  final Pointer<EdfHdr> _handle = calloc<EdfHdr>();
  final String _fileName;

  /// File duration in seconds.
  int get fileDuration => _handle.ref.file_duration ~/ EDFLIB_TIME_DIMENSION;

  /// Number of channels/signals in the opened file.
  int get signalsInFile => _handle.ref.edfsignals;
  int get dataRecordsInFile => _handle.ref.datarecords_in_file;

  /// Full path to the file that was opened.
  String get fileName => _fileName;

  /// The file type of the opened file.
  /// Is null when an error occurred while reading.
  FileType? get fileType => FileType.fromInt(_handle.ref.filetype);

  /// Close the reader to ensure that the process is not holding on to it.
  void close() {
    if (_handle.ref.handle >= 0) {
      dylib.close_file(_handle.ref.handle);
      _handle.ref.handle = -1;
    }
    calloc.free(_handle);
  }

  /// Returns the physical data of signal chn. When start and n is set, a subset is returned
  ///
  /// [channel] Channel number.
  /// [start] Start pointer (default is 0).
  /// [length] Length of data to read (default is null, by which the complete data of the channel are returned).
  /// [digital] Will return the signal in original digital values instead of physical values.
  Iterable<num> readSignal(int channel,
      {int start = 0, int? length, bool digital = false}) {
    if (start < 0) {
      return Iterable<num>.empty();
    }
    if (length != null && length < 0) {
      return Iterable<num>.empty();
    }

    final List<int> numberOfSamples = getNumberOfSamples();
    if (0 > channel || channel >= numberOfSamples.length) {
      throw EdfError(
          'Trying to access channel $channel, but only $signalsInFile channels found');
    }

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
  ///
  /// [channel] channel number.
  num getSampleFrequency(int channel) {
    return _handle.ref.signalparam[channel].smp_in_datarecord
        .toDouble()
        .roundToDecimals(3);
  }

  /// Get the number of samples per channel.
  List<int> getNumberOfSamples() {
    return List<int>.generate(
        signalsInFile, (index) => _samplesInChannel(index));
  }

  /// Retrieve the start DateTime.
  DateTime getStartDatetime() {
    final subsecond = (_handle.ref.starttime_subsecond / 100).round();
    return DateTime(
        _handle.ref.startdate_year,
        _handle.ref.startdate_month,
        _handle.ref.startdate_day,
        _handle.ref.starttime_hour,
        _handle.ref.starttime_minute,
        _handle.ref.starttime_second,
        subsecond);
  }

  /// Returns the patient code.
  String getPatientCode() {
    return _handle.ref.patientcode.toDartString();
  }

  /// Returns the patient name.
  String getPatientName() {
    return _handle.ref.patient_name.toDartString();
  }

  /// Returns the gender.
  String getGender() {
    return _handle.ref.gender.toDartString();
  }

  /// Returns the birth date.
  DateTime getBirthdate() {
    return DateTime(_handle.ref.birthdate_year, _handle.ref.birthdate_month,
        _handle.ref.birthdate_day);
  }

  /// Returns the additional patient information.
  String getPatientAdditional() {
    return _handle.ref.patient_additional.toDartString();
  }

  /// Returns the technician.
  String getTechnician() {
    return _handle.ref.technician.toDartString();
  }

  /// Returns the administrator code.
  String getAdminCode() {
    return _handle.ref.admincode.toDartString();
  }

  /// Returns the equipment.
  String getEquipment() {
    return _handle.ref.equipment.toDartString();
  }

  /// Returns the additional recording information.
  String getRecordingAdditional() {
    return _handle.ref.recording_additional.toDartString();
  }

  /// Returns the labels for each channel/signal.
  List<String> getSignalLabels() {
    return List<String>.generate(signalsInFile,
        (index) => _handle.ref.signalparam[index].label.toDartString());
  }

  /// Returns the label for the given channel.
  String getLabel(int channel) {
    _checkChannelIndex(channel);
    return _handle.ref.signalparam[channel].label.toDartString();
  }

  /// Returns the prefilter for the given channel.
  String getPrefilter(int channel) {
    _checkChannelIndex(channel);
    return _handle.ref.signalparam[channel].prefilter.toDartString();
  }

  /// Returns the transducer.
  String getTransducer(int channel) {
    _checkChannelIndex(channel);
    return _handle.ref.signalparam[channel].transducer.toDartString();
  }

  /// Gets the physical dimension.
  String getPhysicalDimension(int channel) {
    _checkChannelIndex(channel);
    return _handle.ref.signalparam[channel].physdimension.toDartString();
  }

  int _samplesInChannel(int channel) {
    return _handle.ref.signalparam[channel].smp_in_file;
  }

  void _checkChannelIndex(int channel) {
    if (channel < 0 || channel >= signalsInFile) {
      throw EdfError('Index $channel is out of bounds for $signalsInFile');
    }
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
      final String msg = _openErrors[_handle.ref.filetype] ?? 'unknown error';
      throw EdfError('$msg for file $fileName');
    }
  }
}
