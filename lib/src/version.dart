import 'package:version/version.dart';

import 'dylib.dart';

Version version() {
  final libVersionInt = dylib.version();
  final major = libVersionInt ~/ 100;
  final minor = libVersionInt % 100;

  return Version(major, minor, 0);
}
