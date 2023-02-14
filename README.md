# dartEDFLib

## Features

A wrapper library around [EDFLib](https://www.teuniz.net/edflib/) inspired by [pyEDFlib](https://github.com/holgern/pyedflib) to read/write EDF+ files.
The definition of the EDF/EDF+/BDF/BDF+ format can be found under [edfplus.info](https://edfplus.info).

This package uses [dart:ffi](https://dart.dev/guides/libraries/c-interop) to call libEDF's C APIs, which implies that libEDF must be bundled to or deployed with the host application.

## Usage

```dart
import 'package:edflib/edflib.dart';

final file_stream = ; //TODO
final writer = EdfWriter(file_stream, 1, file_type=EDFPLUS);
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
