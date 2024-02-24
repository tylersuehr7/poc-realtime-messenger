final class InvalidLoginException implements Exception {
  final String reason;
  const InvalidLoginException(this.reason);
}
