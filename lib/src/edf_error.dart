class EdfError extends Error {
  EdfError([this.message = '']);

  final String message;

  @override
  String toString() {
    return 'EdfError: $message';
  }
}
