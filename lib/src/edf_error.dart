import 'dart:io';

class EdfError extends OSError {
  const EdfError([super.message = '', super.errorCode = OSError.noErrorCode]);
}
