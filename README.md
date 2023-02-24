# dartEDFLib

## Features

A wrapper library around [EDFLib v1.23](https://gitlab.com/Teuniz/EDFlib/-/tree/v1.23) inspired by [pyEDFlib v0.1.28](https://github.com/holgern/pyedflib/tree/v0.1.28) to read/write EDF+ files.
The definition of the EDF/EDF+/BDF/BDF+ format can be found under [edfplus.info](https://edfplus.info).

This package uses [dart:ffi](https://dart.dev/guides/libraries/c-interop) to call libEDF's C APIs, which implies that libEDF must be bundled to or deployed with the host application.

## Installation

Make sure that you have installed/compiled EDFLib on your computer, and that it can be found by dylib.
For example, you can set `EDFLIB_PATH` to the full path of the dynamic library (.dll/.so/.dylib), or to the folder where it can be found. (e.g. `EDFLIB_PATH=C:\edflib\edflib.dll`).

Add `dartedflib` to `pubspec.yaml`. Since the package is not yet published, you can do that via a git reference.

```yaml
dependencies:
  dartedflib:
    git:
      url: git@github.com:Praxa-Sense/dartedflib.git
      ref: dev
```

## Usage

```dart
import 'package:edflib/edflib.dart';

final writer = EdfWriter(fileName: filePath, numberOfChannels: 1);
try {
  final channelInfo = {
    'label': 'ECG1',
    'dimension': 'mV',
    'sample_frequency': measurement.deviceConfig!.ecgSampleRate!,
    'physical_max': 10.0,
    'physical_min': -10.0,
    'prefilter': '',
  };
  writer.setSignalHeaders(channelInfo);
  final data = List<num>.filled(500, 0.1);
  writer.writeSamples([data]);
} finally {
  // don't forget to close it!
  writer.close();
}
```

## Additional information

This package is currently developed by Praxa Sense and will eventually become available via pub.

### Tests

To run the unit tests via vs code, add the dynamic library to the root folder of this repo, because `settings.json` contains a reference to `EDFLIB_PATH`:

```json
"dart.env": {
    "EDFLIB_PATH": "."
},
```

The .edf-files found in `test/data` are direct copies from [pyedflib/tests/data](https://github.com/holgern/pyedflib/tree/v0.1.28/pyedflib/tests/data).

### Regenerating bindings.dart

In tasks.json there is a task to generate `bindings.dart`. It's important to notice that the `edflib.h` file in the root folder is taken for that. If you want to upgrade to a later version of EDFLib, replace `edflib.h` with a newer version and run the task.
