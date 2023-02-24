import 'dart:ffi' as ffi;

import 'package:dylib/dylib.dart';
import 'bindings.dart';

EdfLib? _dylib;
EdfLib get dylib {
  return _dylib ??= EdfLib(ffi.DynamicLibrary.open(
    resolveDylibPath(
      'edflib',
      dartDefine: 'EDFLIB_PATH',
      environmentVariable: 'EDFLIB_PATH',
    ),
  ));
}
