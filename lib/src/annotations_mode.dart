import 'bindings.dart';

enum AnnotationsMode {
  doNotReadAnnotations,
  readAnnotations,
  readAllAnnotations;

  int toNative() {
    switch (this) {
      case AnnotationsMode.doNotReadAnnotations:
        return EDFLIB_DO_NOT_READ_ANNOTATIONS;
      case AnnotationsMode.readAnnotations:
        return EDFLIB_READ_ANNOTATIONS;
      case AnnotationsMode.readAllAnnotations:
        return EDFLIB_READ_ALL_ANNOTATIONS;
    }
  }
}
