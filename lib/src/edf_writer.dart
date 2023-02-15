import 'dart:ffi';
import 'dart:io';

import 'package:dartedflib/src/edf_error.dart';
import 'package:dartedflib/src/file_type.dart';
import 'package:ffi/ffi.dart';

import 'dylib.dart';

extension on String {
  Pointer<Char> toCharPointer() => toNativeUtf8().cast<Char>();
}

class EdfWriter {
  // signal header fields
  static const _transducerField = 'transducer';
  static const _prefilterField = 'prefilter';
  static const _digitalMinField = 'digital_min';
  static const _digitalMaxField = 'digital_max';
  static const _physicalMinField = 'physical_min';
  static const _physicalMaxField = 'physical_max';
  static const _sampleFrequencyField = 'sample_frequency';
  static const _sampleRateField = 'sample_rate';
  static const _dimensionField = 'dimension';
  static const _labelField = 'label';

  // file header fields
  static const _technicianField = 'technician';
  static const _recordingAdditionalField = 'recording_additional';
  static const _patientnameField = 'patientname';
  static const _patientAdditionalField = 'patient_additional';
  static const _patientcodeField = 'patientcode';
  static const _equipmentField = 'equipment';
  static const _admincodeField = 'admincode';
  static const _genderField = 'gender';
  static const _startdateField = 'startdate';
  static const _birthdateField = 'birthdate';

  EdfWriter(
      {required String fileName,
      required int numberOfChannels,
      FileType fileType = FileType.edfPlus})
      : _path = fileName,
        _numberOfChannels = numberOfChannels,
        _fileType = fileType,
        _numberOfAnnotations = _determineNumberOfAnnotations(fileType) {
    for (int i = 0; i < _numberOfChannels; i++) {
      if (_fileType.isBdf()) {
        _channels.add({
          _labelField: 'ch$i',
          _dimensionField: 'mV',
          _sampleRateField: 100,
          _sampleFrequencyField: null,
          _physicalMaxField: 1.0,
          _physicalMinField: -1.0,
          _digitalMaxField: 8388607,
          _digitalMinField: -8388608,
          _prefilterField: '',
          _transducerField: '',
        });
      } else if (_fileType.isEdf()) {
        _channels.add({
          _labelField: 'ch$i',
          _dimensionField: 'mV',
          _sampleRateField: 100,
          _sampleFrequencyField: null,
          _physicalMaxField: 1.0,
          _physicalMinField: -1.0,
          _digitalMaxField: 32767,
          _digitalMinField: -32768,
          _prefilterField: '',
          _transducerField: ''
        });
      }
    }
    _handle = dylib.open_file_writeonly(
        _path.toCharPointer(), _fileType.toNative(), _numberOfChannels);

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
  String _recordingAdditional = '';
  String _patientAdditional = '';
  String _admincode = '';
  int? _gender;
  DateTime _recordingStartTime = DateTime.now();
  DateTime? _birthdate;

  /// Duration of the record in units of 10 ms.
  int _duration = 1;
  final int _numberOfAnnotations;
  final int _numberOfChannels;
  final List<Map<String, dynamic>> _channels = [];

  /// Closes the file.
  void close() {
    dylib.close_file(_handle);
    _handle = -1;
  }

  /// Sets the parameter for signal [channelNumber].
  /// channel_info should be a [Map] with these values:
  /// 'label' : [String]
  ///   channel label (string, <= 16 characters, must be unique)
  /// 'dimension' : [String]
  ///   physical dimension (e.g., mV) (string, <= 8 characters)
  /// 'sample_rate' : [int]
  ///   sample frequency in hertz (int). Deprecated: use 'sample_frequency' instead.
  /// 'sample_frequency' : [int]
  ///   number of samples per record
  /// 'physical_max' : [double]
  ///   maximum physical value
  /// 'physical_min' : [double]
  ///   minimum physical value
  /// 'digital_max' : [int]
  ///   maximum digital value (-2**15 <= x < 2**15)
  /// 'digital_min' : [int]
  ///   minimum digital value (-2**15 <= x < 2**15)
  void setSignalHeader(int channelNumber, Map<String, dynamic> signalHeader) {
    if (channelNumber < 0 || channelNumber > _numberOfChannels) {
      throw EdfError('Channel number $channelNumber is out of range');
    }

    _channels[channelNumber].addAll(signalHeader);
    _updateHeader();
  }

  /// Sets the parameters for all signals
  ///
  /// [signalHeader] is a [Map] of strings of the following format:
  /// 'label' : [String]
  ///   channel label (string, <= 16 characters, must be unique)
  /// 'dimension' : [String]
  ///   physical dimension (e.g., mV) (string, <= 8 characters)
  /// 'sample_rate' : [int]
  ///   sample frequency in hertz (int). Deprecated: use 'sample_frequency' instead.
  /// 'sample_frequency' : [int]
  ///   number of samples per record
  /// 'physical_max' : [double]
  ///   maximum physical value
  /// 'physical_min' : [double]
  ///   minimum physical value
  /// 'digital_max' : [int]
  ///   maximum digital value (-2**15 <= x < 2**15)
  /// 'digital_min' : [int]
  ///   minimum digital value (-2**15 <= x < 2**15)
  void setSignalHeaders(Map<String, dynamic> signalHeader) {
    for (var edfSignal in _channels) {
      edfSignal.addAll(signalHeader);
    }
    _updateHeader();
  }

  /// Sets the parameters for the file.
  ///
  /// [fileHeader] is a [Map] of strings of the following format:
  /// 'technician': [String]
  /// 'recording_additional': [String]
  /// 'patient_name': [String]
  /// 'patient_additional': [String]
  /// 'patient_code': [String]
  /// 'equipment': [String]
  /// 'admincode': [String]
  /// 'gender': [String] or [int].
  ///   If it is an [int] 0 is female, 1 is male.
  ///   Supported strings:
  ///   '', 'x', 'xx', 'xxx', 'unknown', '?', '??',
  ///   'female', 'woman', 'f', 'w',
  ///   'male', 'man', 'm'.
  /// 'recording_start_time: [DateTime]
  /// 'birthdate': [DateTime]
  void setHeader(Map<String, dynamic> fileHeader) {
    _technician = fileHeader[_technicianField];
    _recordingAdditional = fileHeader[_recordingAdditionalField];
    _patientName = fileHeader[_patientnameField];
    _patientAdditional = fileHeader[_patientAdditionalField];
    _patientCode = fileHeader[_patientcodeField];
    _equipment = fileHeader[_equipmentField];
    _admincode = fileHeader[_admincodeField];
    _gender = _genderToInt(fileHeader[_genderField]);
    _recordingStartTime = fileHeader[_startdateField];
    _birthdate = fileHeader[_birthdateField];
    _updateHeader();
  }

  static int _determineNumberOfAnnotations(FileType fileType) {
    return fileType.isPlus() ? 1 : 0;
  }

  static int? _genderToInt(dynamic gender) {
    if (gender is int || gender == null) {
      return gender;
    }

    String genderString = (gender as String).toLowerCase();
    if (['', 'x', 'xx', 'xxx', 'unknown', '?', '??'].contains(genderString)) {
      return null;
    }

    if (['female', 'woman', 'f', 'w'].contains(genderString)) {
      return 0;
    }

    if (['male', 'man', 'm'].contains(genderString)) {
      return 1;
    }

    throw EdfError('Unknown gender: $genderString');
  }

  /// Updates header to edf file struct.
  void _updateHeader() {
    final patientIdLength = _patientCode.length +
        _patientName.length +
        _patientAdditional.length +
        3 +
        1 +
        11; // 3 spaces, 1 gender, 11 birth date

    final recordLength = _equipment.length +
        _technician.length +
        _admincode.length +
        _recordingAdditional.length +
        'Startdate'.length +
        3 +
        11; // 3 spaces, 11 birth date

    if (patientIdLength > 80) {
      throw EdfError(
          'Patient code, name, gender and birthdate combined must not be larger than 80 chars. '
          'Currently has length of $patientIdLength. '
          'See https://www.edfplus.info/specs/edfplus.html#additionalspecs');
    }

    if (recordLength > 80) {
      throw EdfError(
          'Equipment, technician, admincode and recording_additional combined must not be larger than 80 chars. '
          'Currently has len of $recordLength. '
          'See https://www.edfplus.info/specs/edfplus.html#additionalspecs');
    }

    dylib.set_technician(_handle, _technician.toCharPointer());
    dylib.set_recording_additional(
        _handle, _recordingAdditional.toCharPointer());
    dylib.set_patientname(_handle, _patientName.toCharPointer());
    dylib.set_patientcode(_handle, _patientCode.toCharPointer());
    dylib.set_patient_additional(_handle, _patientAdditional.toCharPointer());
    dylib.set_equipment(_handle, _equipment.toCharPointer());
    dylib.set_admincode(_handle, _admincode.toCharPointer());
    if (_gender != null) {
      dylib.set_gender(_handle, _gender!);
    }

    dylib.set_datarecord_duration(_handle, _duration);
    dylib.set_number_of_annotation_signals(_handle, _numberOfAnnotations);
    dylib.set_startdatetime(
        _handle,
        _recordingStartTime.year,
        _recordingStartTime.month,
        _recordingStartTime.day,
        _recordingStartTime.hour,
        _recordingStartTime.minute,
        _recordingStartTime.second);

    if (_recordingStartTime.microsecond > 0) {
      dylib.set_subsecond_starttime(
          _handle, _recordingStartTime.microsecond * 100);
    }

    if (_birthdate != null) {
      dylib.set_birthdate(
          _handle, _birthdate!.year, _birthdate!.month, _birthdate!.day);
    }

    for (int i = 0; i < _numberOfChannels; i++) {
      final channel = _channels[i];
      _checkSignalHeaderCorrect(i);

      dylib.set_samplefrequency(_handle, i, _getSampleFrequency(i));
      dylib.set_physical_maximum(_handle, i, channel[_physicalMaxField]);
      dylib.set_physical_minimum(_handle, i, channel[_physicalMinField]);
      dylib.set_digital_maximum(_handle, i, channel[_digitalMaxField]);
      dylib.set_digital_minimum(_handle, i, channel[_digitalMinField]);
      dylib.set_label(
          _handle, i, (channel[_labelField] as String).toCharPointer());
      dylib.set_physical_dimension(
          _handle, i, (channel[_dimensionField] as String).toCharPointer());
      dylib.set_transducer(
          _handle, i, (channel[_transducerField] as String).toCharPointer());
      dylib.set_prefilter(
          _handle, i, (channel[_prefilterField] as String).toCharPointer());
    }
  }

  /// helper function  to check if all entries in the channel dictionary are fine.
  ///
  /// Will give a warning if label, transducer, dimension, prefilter are too long.
  ///
  /// Will throw an exception if digital_min, digital_max, physical_min,
  /// physical_max are out of bounds or would be truncated in such a way as that
  /// signal values would be completely off.
  void _checkSignalHeaderCorrect(int channelIndex) {
    final channel = _channels[channelIndex];
    final String label = channel[_labelField];

    if (label.length > 16) {
      throw EdfError(
          'Label of channel $channelIndex is longer than 16 ASCII chars.');
    }

    final String prefilter = channel[_prefilterField];
    if (prefilter.length > 80) {
      throw EdfError(
          'prefilter of channel $channelIndex is longer than 80 ASCII chars.');
    }

    final String transducer = channel[_transducerField];
    if (transducer.length > 80) {
      throw EdfError(
          'transducer of channel $channelIndex is longer than 80 ASCII chars.');
    }

    final String dimension = channel[_dimensionField];
    if (dimension.length > 80) {
      throw EdfError(
          'dimension of channel $channelIndex is longer than 80 ASCII chars.');
    }

    final digitalMinBoundary = _fileType.isBdf() ? -8388608 : -32768;
    final digitalMaxBoundary = _fileType.isBdf() ? 8388607 : 32767;
    final int digitalMin = channel[_digitalMinField];
    final int digitalMax = channel[_digitalMaxField];
    if (digitalMin < digitalMinBoundary) {
      throw EdfError(
          'Digital minimum for channel $channelIndex ($label) is $digitalMin, '
          'but minimum allowed value is $digitalMinBoundary');
    }

    if (digitalMax > digitalMaxBoundary) {
      throw EdfError(
          'Digital maximum for channel $channelIndex ($label) is $digitalMax, '
          'but maximum allowed value is $digitalMaxBoundary');
    }

    // if we truncate the physical min before the dot, we potentially
    // have all the signals incorrect by an order of magnitude.
    final num physicalMin = channel[_physicalMinField];
    final int physicalMinLength = physicalMin.toString().length;
    if (physicalMinLength > 8) {
      throw EdfError(
          'Physical minimum for channel $channelIndex ($label) is $physicalMin, '
          'which has $physicalMinLength chars, however, '
          'EDF+ can only save 8 chars, critical precision loss is expected, '
          'please convert the signals to another dimension (eg uV to mV)');
    }

    final num physicalMax = channel[_physicalMaxField];
    final int physicalMaxLength = physicalMax.toString().length;
    if (physicalMaxLength > 8) {
      throw EdfError(
          'Physical minimum for channel $channelIndex ($label) is $physicalMax, '
          'which has $physicalMaxLength chars, however, '
          'EDF+ can only save 8 chars, critical precision loss is expected, '
          'please convert the signals to another dimension (eg uV to mV).');
    }
  }

  int _getSampleFrequency(int channelIndex) {
    // Temporary conditional assignment while we deprecate 'sample_rate' as a channel attribute
    // in favor of 'sample_frequency', supporting the use of either to give
    // users time to switch to the new interface.
    final channel = _channels[channelIndex];
    return channel[_sampleFrequencyField] ?? channel[_sampleRateField];
  }
}
