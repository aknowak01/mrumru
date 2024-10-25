/// Exception thrown when the bytes are too short to be parsed.
class BytesTooShortException implements Exception {
  /// The exception message.
  final String message;

  /// Creates a new instance of [BytesTooShortException] with the given [message].
  BytesTooShortException(this.message);
}
