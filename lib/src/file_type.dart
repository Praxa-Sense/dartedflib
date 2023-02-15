import 'bindings.dart';

enum FileType {
  edf,
  edfPlus,
  bdf,
  bdfPlus,
}

extension FileTypeExtensions on FileType {
  int toNative() {
    switch (this) {
      case FileType.edf:
        return EDFLIB_FILETYPE_EDF;
      case FileType.edfPlus:
        return EDFLIB_FILETYPE_EDFPLUS;
      case FileType.bdf:
        return EDFLIB_FILETYPE_BDF;
      case FileType.bdfPlus:
        return EDFLIB_FILETYPE_BDFPLUS;
    }
  }

  bool isBdf() => this == FileType.bdf || this == FileType.bdfPlus;

  bool isEdf() => this == FileType.edf || this == FileType.edfPlus;

  bool isPlus() => this == FileType.bdfPlus || this == FileType.edfPlus;
}
