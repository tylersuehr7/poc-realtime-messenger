final class Optional<T> {
  final _OptionalResult<T>? _result;

  const Optional._(this._result);

  const Optional.nil(): this._(null);

  Optional.of(final T value): this._(_OptionalResult(value));

  bool get hasValue {
    return _result != null;
  }

  T or(final T defaultValue) {
    final _OptionalResult<T>? result = _result;
    if (result == null) {
      return defaultValue;
    }
    return result.value;
  }
}

final class _OptionalResult<T> {
  final T value;
  const _OptionalResult(this.value);
}
