// ignore_for_file: type=lint

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
import 'dart:ffi' as ffi;

/// edflib: cross-platform library for reading and writing edf files
class EdfLib {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  EdfLib(ffi.DynamicLibrary dynamicLibrary) : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  EdfLib.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  /// the following functions are used to read files
  int open_file_readonly(
    ffi.Pointer<ffi.Char> path,
    ffi.Pointer<EdfHdr> edfhdr,
    int read_annotations,
  ) {
    return _open_file_readonly(
      path,
      edfhdr,
      read_annotations,
    );
  }

  late final _open_file_readonlyPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Pointer<ffi.Char>, ffi.Pointer<EdfHdr>,
              ffi.Int)>>('edfopen_file_readonly');
  late final _open_file_readonly = _open_file_readonlyPtr.asFunction<
      int Function(ffi.Pointer<ffi.Char>, ffi.Pointer<EdfHdr>, int)>();

  int read_physical_samples(
    int handle,
    int edfsignal,
    int n,
    ffi.Pointer<ffi.Double> buf,
  ) {
    return _read_physical_samples(
      handle,
      edfsignal,
      n,
      buf,
    );
  }

  late final _read_physical_samplesPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Int, ffi.Int, ffi.Int,
              ffi.Pointer<ffi.Double>)>>('edfread_physical_samples');
  late final _read_physical_samples = _read_physical_samplesPtr
      .asFunction<int Function(int, int, int, ffi.Pointer<ffi.Double>)>();

  int read_digital_samples(
    int handle,
    int edfsignal,
    int n,
    ffi.Pointer<ffi.Int> buf,
  ) {
    return _read_digital_samples(
      handle,
      edfsignal,
      n,
      buf,
    );
  }

  late final _read_digital_samplesPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Int, ffi.Int, ffi.Int,
              ffi.Pointer<ffi.Int>)>>('edfread_digital_samples');
  late final _read_digital_samples = _read_digital_samplesPtr
      .asFunction<int Function(int, int, int, ffi.Pointer<ffi.Int>)>();

  int seek(
    int handle,
    int edfsignal,
    int offset,
    int whence,
  ) {
    return _seek(
      handle,
      edfsignal,
      offset,
      whence,
    );
  }

  late final _seekPtr = _lookup<
      ffi.NativeFunction<
          ffi.LongLong Function(
              ffi.Int, ffi.Int, ffi.LongLong, ffi.Int)>>('edfseek');
  late final _seek = _seekPtr.asFunction<int Function(int, int, int, int)>();

  int tell(
    int handle,
    int edfsignal,
  ) {
    return _tell(
      handle,
      edfsignal,
    );
  }

  late final _tellPtr =
      _lookup<ffi.NativeFunction<ffi.LongLong Function(ffi.Int, ffi.Int)>>(
          'edftell');
  late final _tell = _tellPtr.asFunction<int Function(int, int)>();

  void rewind(
    int handle,
    int edfsignal,
  ) {
    return _rewind(
      handle,
      edfsignal,
    );
  }

  late final _rewindPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int, ffi.Int)>>(
          'edfrewind');
  late final _rewind = _rewindPtr.asFunction<void Function(int, int)>();

  int get_annotation(
    int handle,
    int n,
    ffi.Pointer<EdfAnnotation> annot,
  ) {
    return _get_annotation(
      handle,
      n,
      annot,
    );
  }

  late final _get_annotationPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Int, ffi.Int,
              ffi.Pointer<EdfAnnotation>)>>('edf_get_annotation');
  late final _get_annotation = _get_annotationPtr
      .asFunction<int Function(int, int, ffi.Pointer<EdfAnnotation>)>();

  /// the following functions are used in read and write mode
  int close_file(
    int handle,
  ) {
    return _close_file(
      handle,
    );
  }

  late final _close_filePtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Int)>>('edfclose_file');
  late final _close_file = _close_filePtr.asFunction<int Function(int)>();

  int version() {
    return _version();
  }

  late final _versionPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function()>>('edflib_version');
  late final _version = _versionPtr.asFunction<int Function()>();

  int is_file_used(
    ffi.Pointer<ffi.Char> path,
  ) {
    return _is_file_used(
      path,
    );
  }

  late final _is_file_usedPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Pointer<ffi.Char>)>>(
          'edflib_is_file_used');
  late final _is_file_used =
      _is_file_usedPtr.asFunction<int Function(ffi.Pointer<ffi.Char>)>();

  int get_number_of_open_files() {
    return _get_number_of_open_files();
  }

  late final _get_number_of_open_filesPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function()>>(
          'edflib_get_number_of_open_files');
  late final _get_number_of_open_files =
      _get_number_of_open_filesPtr.asFunction<int Function()>();

  int get_handle(
    int file_number,
  ) {
    return _get_handle(
      file_number,
    );
  }

  late final _get_handlePtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Int)>>(
          'edflib_get_handle');
  late final _get_handle = _get_handlePtr.asFunction<int Function(int)>();

  /// the following functions are used to write files
  int open_file_writeonly(
    ffi.Pointer<ffi.Char> path,
    int filetype,
    int number_of_signals,
  ) {
    return _open_file_writeonly(
      path,
      filetype,
      number_of_signals,
    );
  }

  late final _open_file_writeonlyPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Pointer<ffi.Char>, ffi.Int,
              ffi.Int)>>('edfopen_file_writeonly');
  late final _open_file_writeonly = _open_file_writeonlyPtr
      .asFunction<int Function(ffi.Pointer<ffi.Char>, int, int)>();

  int open_file_writeonly_with_params(
    ffi.Pointer<ffi.Char> path,
    int filetype,
    int number_of_signals,
    int samplefrequency,
    double phys_max_min,
    ffi.Pointer<ffi.Char> phys_dim,
  ) {
    return _open_file_writeonly_with_params(
      path,
      filetype,
      number_of_signals,
      samplefrequency,
      phys_max_min,
      phys_dim,
    );
  }

  late final _open_file_writeonly_with_paramsPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(
              ffi.Pointer<ffi.Char>,
              ffi.Int,
              ffi.Int,
              ffi.Int,
              ffi.Double,
              ffi.Pointer<ffi.Char>)>>('edfopen_file_writeonly_with_params');
  late final _open_file_writeonly_with_params =
      _open_file_writeonly_with_paramsPtr.asFunction<
          int Function(ffi.Pointer<ffi.Char>, int, int, int, double,
              ffi.Pointer<ffi.Char>)>();

  int set_samplefrequency(
    int handle,
    int edfsignal,
    int samplefrequency,
  ) {
    return _set_samplefrequency(
      handle,
      edfsignal,
      samplefrequency,
    );
  }

  late final _set_samplefrequencyPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Int, ffi.Int)>>(
          'edf_set_samplefrequency');
  late final _set_samplefrequency =
      _set_samplefrequencyPtr.asFunction<int Function(int, int, int)>();

  int set_physical_maximum(
    int handle,
    int edfsignal,
    double phys_max,
  ) {
    return _set_physical_maximum(
      handle,
      edfsignal,
      phys_max,
    );
  }

  late final _set_physical_maximumPtr = _lookup<
          ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Int, ffi.Double)>>(
      'edf_set_physical_maximum');
  late final _set_physical_maximum =
      _set_physical_maximumPtr.asFunction<int Function(int, int, double)>();

  int set_physical_minimum(
    int handle,
    int edfsignal,
    double phys_min,
  ) {
    return _set_physical_minimum(
      handle,
      edfsignal,
      phys_min,
    );
  }

  late final _set_physical_minimumPtr = _lookup<
          ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Int, ffi.Double)>>(
      'edf_set_physical_minimum');
  late final _set_physical_minimum =
      _set_physical_minimumPtr.asFunction<int Function(int, int, double)>();

  int set_digital_maximum(
    int handle,
    int edfsignal,
    int dig_max,
  ) {
    return _set_digital_maximum(
      handle,
      edfsignal,
      dig_max,
    );
  }

  late final _set_digital_maximumPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Int, ffi.Int)>>(
          'edf_set_digital_maximum');
  late final _set_digital_maximum =
      _set_digital_maximumPtr.asFunction<int Function(int, int, int)>();

  int set_digital_minimum(
    int handle,
    int edfsignal,
    int dig_min,
  ) {
    return _set_digital_minimum(
      handle,
      edfsignal,
      dig_min,
    );
  }

  late final _set_digital_minimumPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Int, ffi.Int)>>(
          'edf_set_digital_minimum');
  late final _set_digital_minimum =
      _set_digital_minimumPtr.asFunction<int Function(int, int, int)>();

  int set_label(
    int handle,
    int edfsignal,
    ffi.Pointer<ffi.Char> label,
  ) {
    return _set_label(
      handle,
      edfsignal,
      label,
    );
  }

  late final _set_labelPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(
              ffi.Int, ffi.Int, ffi.Pointer<ffi.Char>)>>('edf_set_label');
  late final _set_label =
      _set_labelPtr.asFunction<int Function(int, int, ffi.Pointer<ffi.Char>)>();

  int set_prefilter(
    int handle,
    int edfsignal,
    ffi.Pointer<ffi.Char> prefilter,
  ) {
    return _set_prefilter(
      handle,
      edfsignal,
      prefilter,
    );
  }

  late final _set_prefilterPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(
              ffi.Int, ffi.Int, ffi.Pointer<ffi.Char>)>>('edf_set_prefilter');
  late final _set_prefilter = _set_prefilterPtr
      .asFunction<int Function(int, int, ffi.Pointer<ffi.Char>)>();

  int set_transducer(
    int handle,
    int edfsignal,
    ffi.Pointer<ffi.Char> transducer,
  ) {
    return _set_transducer(
      handle,
      edfsignal,
      transducer,
    );
  }

  late final _set_transducerPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(
              ffi.Int, ffi.Int, ffi.Pointer<ffi.Char>)>>('edf_set_transducer');
  late final _set_transducer = _set_transducerPtr
      .asFunction<int Function(int, int, ffi.Pointer<ffi.Char>)>();

  int set_physical_dimension(
    int handle,
    int edfsignal,
    ffi.Pointer<ffi.Char> phys_dim,
  ) {
    return _set_physical_dimension(
      handle,
      edfsignal,
      phys_dim,
    );
  }

  late final _set_physical_dimensionPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Int, ffi.Int,
              ffi.Pointer<ffi.Char>)>>('edf_set_physical_dimension');
  late final _set_physical_dimension = _set_physical_dimensionPtr
      .asFunction<int Function(int, int, ffi.Pointer<ffi.Char>)>();

  int set_startdatetime(
    int handle,
    int startdate_year,
    int startdate_month,
    int startdate_day,
    int starttime_hour,
    int starttime_minute,
    int starttime_second,
  ) {
    return _set_startdatetime(
      handle,
      startdate_year,
      startdate_month,
      startdate_day,
      starttime_hour,
      starttime_minute,
      starttime_second,
    );
  }

  late final _set_startdatetimePtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Int, ffi.Int, ffi.Int, ffi.Int, ffi.Int, ffi.Int,
              ffi.Int)>>('edf_set_startdatetime');
  late final _set_startdatetime = _set_startdatetimePtr
      .asFunction<int Function(int, int, int, int, int, int, int)>();

  int set_patientname(
    int handle,
    ffi.Pointer<ffi.Char> patientname,
  ) {
    return _set_patientname(
      handle,
      patientname,
    );
  }

  late final _set_patientnamePtr = _lookup<
          ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Pointer<ffi.Char>)>>(
      'edf_set_patientname');
  late final _set_patientname = _set_patientnamePtr
      .asFunction<int Function(int, ffi.Pointer<ffi.Char>)>();

  int set_patientcode(
    int handle,
    ffi.Pointer<ffi.Char> patientcode,
  ) {
    return _set_patientcode(
      handle,
      patientcode,
    );
  }

  late final _set_patientcodePtr = _lookup<
          ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Pointer<ffi.Char>)>>(
      'edf_set_patientcode');
  late final _set_patientcode = _set_patientcodePtr
      .asFunction<int Function(int, ffi.Pointer<ffi.Char>)>();

  int set_gender(
    int handle,
    int gender,
  ) {
    return _set_gender(
      handle,
      gender,
    );
  }

  late final _set_genderPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Int)>>(
          'edf_set_gender');
  late final _set_gender = _set_genderPtr.asFunction<int Function(int, int)>();

  int set_birthdate(
    int handle,
    int birthdate_year,
    int birthdate_month,
    int birthdate_day,
  ) {
    return _set_birthdate(
      handle,
      birthdate_year,
      birthdate_month,
      birthdate_day,
    );
  }

  late final _set_birthdatePtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(
              ffi.Int, ffi.Int, ffi.Int, ffi.Int)>>('edf_set_birthdate');
  late final _set_birthdate =
      _set_birthdatePtr.asFunction<int Function(int, int, int, int)>();

  int set_patient_additional(
    int handle,
    ffi.Pointer<ffi.Char> patient_additional,
  ) {
    return _set_patient_additional(
      handle,
      patient_additional,
    );
  }

  late final _set_patient_additionalPtr = _lookup<
          ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Pointer<ffi.Char>)>>(
      'edf_set_patient_additional');
  late final _set_patient_additional = _set_patient_additionalPtr
      .asFunction<int Function(int, ffi.Pointer<ffi.Char>)>();

  int set_admincode(
    int handle,
    ffi.Pointer<ffi.Char> admincode,
  ) {
    return _set_admincode(
      handle,
      admincode,
    );
  }

  late final _set_admincodePtr = _lookup<
          ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Pointer<ffi.Char>)>>(
      'edf_set_admincode');
  late final _set_admincode =
      _set_admincodePtr.asFunction<int Function(int, ffi.Pointer<ffi.Char>)>();

  int set_technician(
    int handle,
    ffi.Pointer<ffi.Char> technician,
  ) {
    return _set_technician(
      handle,
      technician,
    );
  }

  late final _set_technicianPtr = _lookup<
          ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Pointer<ffi.Char>)>>(
      'edf_set_technician');
  late final _set_technician =
      _set_technicianPtr.asFunction<int Function(int, ffi.Pointer<ffi.Char>)>();

  int set_equipment(
    int handle,
    ffi.Pointer<ffi.Char> equipment,
  ) {
    return _set_equipment(
      handle,
      equipment,
    );
  }

  late final _set_equipmentPtr = _lookup<
          ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Pointer<ffi.Char>)>>(
      'edf_set_equipment');
  late final _set_equipment =
      _set_equipmentPtr.asFunction<int Function(int, ffi.Pointer<ffi.Char>)>();

  int set_recording_additional(
    int handle,
    ffi.Pointer<ffi.Char> recording_additional,
  ) {
    return _set_recording_additional(
      handle,
      recording_additional,
    );
  }

  late final _set_recording_additionalPtr = _lookup<
          ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Pointer<ffi.Char>)>>(
      'edf_set_recording_additional');
  late final _set_recording_additional = _set_recording_additionalPtr
      .asFunction<int Function(int, ffi.Pointer<ffi.Char>)>();

  int write_physical_samples(
    int handle,
    ffi.Pointer<ffi.Double> buf,
  ) {
    return _write_physical_samples(
      handle,
      buf,
    );
  }

  late final _write_physical_samplesPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(
              ffi.Int, ffi.Pointer<ffi.Double>)>>('edfwrite_physical_samples');
  late final _write_physical_samples = _write_physical_samplesPtr
      .asFunction<int Function(int, ffi.Pointer<ffi.Double>)>();

  int blockwrite_physical_samples(
    int handle,
    ffi.Pointer<ffi.Double> buf,
  ) {
    return _blockwrite_physical_samples(
      handle,
      buf,
    );
  }

  late final _blockwrite_physical_samplesPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Int,
              ffi.Pointer<ffi.Double>)>>('edf_blockwrite_physical_samples');
  late final _blockwrite_physical_samples = _blockwrite_physical_samplesPtr
      .asFunction<int Function(int, ffi.Pointer<ffi.Double>)>();

  int write_digital_short_samples(
    int handle,
    ffi.Pointer<ffi.Short> buf,
  ) {
    return _write_digital_short_samples(
      handle,
      buf,
    );
  }

  late final _write_digital_short_samplesPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Int,
              ffi.Pointer<ffi.Short>)>>('edfwrite_digital_short_samples');
  late final _write_digital_short_samples = _write_digital_short_samplesPtr
      .asFunction<int Function(int, ffi.Pointer<ffi.Short>)>();

  int write_digital_samples(
    int handle,
    ffi.Pointer<ffi.Int> buf,
  ) {
    return _write_digital_samples(
      handle,
      buf,
    );
  }

  late final _write_digital_samplesPtr = _lookup<
          ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Pointer<ffi.Int>)>>(
      'edfwrite_digital_samples');
  late final _write_digital_samples = _write_digital_samplesPtr
      .asFunction<int Function(int, ffi.Pointer<ffi.Int>)>();

  int blockwrite_digital_3byte_samples(
    int handle,
    ffi.Pointer<ffi.Void> buf,
  ) {
    return _blockwrite_digital_3byte_samples(
      handle,
      buf,
    );
  }

  late final _blockwrite_digital_3byte_samplesPtr = _lookup<
          ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Pointer<ffi.Void>)>>(
      'edf_blockwrite_digital_3byte_samples');
  late final _blockwrite_digital_3byte_samples =
      _blockwrite_digital_3byte_samplesPtr
          .asFunction<int Function(int, ffi.Pointer<ffi.Void>)>();

  int blockwrite_digital_short_samples(
    int handle,
    ffi.Pointer<ffi.Short> buf,
  ) {
    return _blockwrite_digital_short_samples(
      handle,
      buf,
    );
  }

  late final _blockwrite_digital_short_samplesPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Int,
              ffi.Pointer<ffi.Short>)>>('edf_blockwrite_digital_short_samples');
  late final _blockwrite_digital_short_samples =
      _blockwrite_digital_short_samplesPtr
          .asFunction<int Function(int, ffi.Pointer<ffi.Short>)>();

  int blockwrite_digital_samples(
    int handle,
    ffi.Pointer<ffi.Int> buf,
  ) {
    return _blockwrite_digital_samples(
      handle,
      buf,
    );
  }

  late final _blockwrite_digital_samplesPtr = _lookup<
          ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Pointer<ffi.Int>)>>(
      'edf_blockwrite_digital_samples');
  late final _blockwrite_digital_samples = _blockwrite_digital_samplesPtr
      .asFunction<int Function(int, ffi.Pointer<ffi.Int>)>();

  int write_annotation_utf8(
    int handle,
    int onset,
    int duration,
    ffi.Pointer<ffi.Char> description,
  ) {
    return _write_annotation_utf8(
      handle,
      onset,
      duration,
      description,
    );
  }

  late final _write_annotation_utf8Ptr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Int, ffi.LongLong, ffi.LongLong,
              ffi.Pointer<ffi.Char>)>>('edfwrite_annotation_utf8');
  late final _write_annotation_utf8 = _write_annotation_utf8Ptr
      .asFunction<int Function(int, int, int, ffi.Pointer<ffi.Char>)>();

  int write_annotation_latin1(
    int handle,
    int onset,
    int duration,
    ffi.Pointer<ffi.Char> description,
  ) {
    return _write_annotation_latin1(
      handle,
      onset,
      duration,
      description,
    );
  }

  late final _write_annotation_latin1Ptr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Int, ffi.LongLong, ffi.LongLong,
              ffi.Pointer<ffi.Char>)>>('edfwrite_annotation_latin1');
  late final _write_annotation_latin1 = _write_annotation_latin1Ptr
      .asFunction<int Function(int, int, int, ffi.Pointer<ffi.Char>)>();

  int set_datarecord_duration(
    int handle,
    int duration,
  ) {
    return _set_datarecord_duration(
      handle,
      duration,
    );
  }

  late final _set_datarecord_durationPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Int)>>(
          'edf_set_datarecord_duration');
  late final _set_datarecord_duration =
      _set_datarecord_durationPtr.asFunction<int Function(int, int)>();

  int set_micro_datarecord_duration(
    int handle,
    int duration,
  ) {
    return _set_micro_datarecord_duration(
      handle,
      duration,
    );
  }

  late final _set_micro_datarecord_durationPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Int)>>(
          'edf_set_micro_datarecord_duration');
  late final _set_micro_datarecord_duration =
      _set_micro_datarecord_durationPtr.asFunction<int Function(int, int)>();

  int set_number_of_annotation_signals(
    int handle,
    int annot_signals,
  ) {
    return _set_number_of_annotation_signals(
      handle,
      annot_signals,
    );
  }

  late final _set_number_of_annotation_signalsPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Int)>>(
          'edf_set_number_of_annotation_signals');
  late final _set_number_of_annotation_signals =
      _set_number_of_annotation_signalsPtr.asFunction<int Function(int, int)>();

  int set_subsecond_starttime(
    int handle,
    int subsecond,
  ) {
    return _set_subsecond_starttime(
      handle,
      subsecond,
    );
  }

  late final _set_subsecond_starttimePtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Int, ffi.Int)>>(
          'edf_set_subsecond_starttime');
  late final _set_subsecond_starttime =
      _set_subsecond_starttimePtr.asFunction<int Function(int, int)>();
}

class EdfParam extends ffi.Struct {
  @ffi.Array.multi([17])
  external ffi.Array<ffi.Char> label;

  @ffi.LongLong()
  external int smp_in_file;

  @ffi.Double()
  external double phys_max;

  @ffi.Double()
  external double phys_min;

  @ffi.Int()
  external int dig_max;

  @ffi.Int()
  external int dig_min;

  @ffi.Int()
  external int smp_in_datarecord;

  @ffi.Array.multi([9])
  external ffi.Array<ffi.Char> physdimension;

  @ffi.Array.multi([81])
  external ffi.Array<ffi.Char> prefilter;

  @ffi.Array.multi([81])
  external ffi.Array<ffi.Char> transducer;
}

class EdfAnnotation extends ffi.Struct {
  @ffi.LongLong()
  external int onset;

  @ffi.LongLong()
  external int duration_l;

  @ffi.Array.multi([16])
  external ffi.Array<ffi.Char> duration;

  @ffi.Array.multi([513])
  external ffi.Array<ffi.Char> annotation;
}

class EdfHdr extends ffi.Struct {
  @ffi.Int()
  external int handle;

  @ffi.Int()
  external int filetype;

  @ffi.Int()
  external int edfsignals;

  @ffi.LongLong()
  external int file_duration;

  @ffi.Int()
  external int startdate_day;

  @ffi.Int()
  external int startdate_month;

  @ffi.Int()
  external int startdate_year;

  @ffi.LongLong()
  external int starttime_subsecond;

  @ffi.Int()
  external int starttime_second;

  @ffi.Int()
  external int starttime_minute;

  @ffi.Int()
  external int starttime_hour;

  @ffi.Array.multi([81])
  external ffi.Array<ffi.Char> patient;

  @ffi.Array.multi([81])
  external ffi.Array<ffi.Char> recording;

  @ffi.Array.multi([81])
  external ffi.Array<ffi.Char> patientcode;

  @ffi.Array.multi([16])
  external ffi.Array<ffi.Char> gender;

  @ffi.Array.multi([16])
  external ffi.Array<ffi.Char> birthdate;

  @ffi.Int()
  external int birthdate_day;

  @ffi.Int()
  external int birthdate_month;

  @ffi.Int()
  external int birthdate_year;

  @ffi.Array.multi([81])
  external ffi.Array<ffi.Char> patient_name;

  @ffi.Array.multi([81])
  external ffi.Array<ffi.Char> patient_additional;

  @ffi.Array.multi([81])
  external ffi.Array<ffi.Char> admincode;

  @ffi.Array.multi([81])
  external ffi.Array<ffi.Char> technician;

  @ffi.Array.multi([81])
  external ffi.Array<ffi.Char> equipment;

  @ffi.Array.multi([81])
  external ffi.Array<ffi.Char> recording_additional;

  @ffi.LongLong()
  external int datarecord_duration;

  @ffi.LongLong()
  external int datarecords_in_file;

  @ffi.LongLong()
  external int annotations_in_file;

  @ffi.Array.multi([640])
  external ffi.Array<EdfParam> signalparam;
}

const int EDFLIB_TIME_DIMENSION = 10000000;

const int EDFLIB_MAXSIGNALS = 640;

const int EDFLIB_MAX_ANNOTATION_LEN = 512;

const int EDFSEEK_SET = 0;

const int EDFSEEK_CUR = 1;

const int EDFSEEK_END = 2;

const int EDFLIB_FILETYPE_EDF = 0;

const int EDFLIB_FILETYPE_EDFPLUS = 1;

const int EDFLIB_FILETYPE_BDF = 2;

const int EDFLIB_FILETYPE_BDFPLUS = 3;

const int EDFLIB_MALLOC_ERROR = -1;

const int EDFLIB_NO_SUCH_FILE_OR_DIRECTORY = -2;

const int EDFLIB_FILE_CONTAINS_FORMAT_ERRORS = -3;

const int EDFLIB_MAXFILES_REACHED = -4;

const int EDFLIB_FILE_READ_ERROR = -5;

const int EDFLIB_FILE_ALREADY_OPENED = -6;

const int EDFLIB_FILETYPE_ERROR = -7;

const int EDFLIB_FILE_WRITE_ERROR = -8;

const int EDFLIB_NUMBER_OF_SIGNALS_INVALID = -9;

const int EDFLIB_FILE_IS_DISCONTINUOUS = -10;

const int EDFLIB_INVALID_READ_ANNOTS_VALUE = -11;

const int EDFLIB_ARCH_ERROR = -12;

const int EDFLIB_DO_NOT_READ_ANNOTATIONS = 0;

const int EDFLIB_READ_ANNOTATIONS = 1;

const int EDFLIB_READ_ALL_ANNOTATIONS = 2;

const int EDFLIB_NO_SIGNALS = -20;

const int EDFLIB_TOO_MANY_SIGNALS = -21;

const int EDFLIB_NO_SAMPLES_IN_RECORD = -22;

const int EDFLIB_DIGMIN_IS_DIGMAX = -23;

const int EDFLIB_DIGMAX_LOWER_THAN_DIGMIN = -24;

const int EDFLIB_PHYSMIN_IS_PHYSMAX = -25;

const int EDFLIB_DATARECORD_SIZE_TOO_BIG = -26;
