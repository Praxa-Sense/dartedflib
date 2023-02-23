import 'bindings.dart';

enum FileType {
  edf,
  edfPlus,
  bdf,
  bdfPlus;

  static FileType? fromInt(int native) {
    switch (native) {
      case 0:
        return FileType.edf;
      case 1:
        return FileType.edfPlus;
      case 2:
        return FileType.bdf;
      case 3:
        return FileType.bdfPlus;
      default:
        return null;
    }
  }
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
