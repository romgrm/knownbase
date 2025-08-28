/// A functional Result type that represents either a success or failure
sealed class Result<T, E> {
  const Result._();

  /// Create a success result with data
  const factory Result.success(T data) = _Success<T, E>;

  /// Create a failure result with error
  const factory Result.failure(E error) = _Failure<T, E>;

  /// Check if this is a success result
  bool get isSuccess => this is _Success<T, E>;

  /// Check if this is a failure result
  bool get isFailure => this is _Failure<T, E>;

  /// Get the data if this is a success result
  T? get data => switch (this) {
    _Success(data: final d) => d,
    _Failure() => null,
  };

  /// Get the error if this is a failure result
  E? get error => switch (this) {
    _Success() => null,
    _Failure(error: final e) => e,
  };

  /// Map the success value to a new type
  Result<R, E> map<R>(R Function(T) transform) => switch (this) {
    _Success(data: final d) => Result.success(transform(d)),
    _Failure(error: final e) => Result.failure(e),
  };

  /// Map the error value to a new type
  Result<T, R> mapError<R>(R Function(E) transform) => switch (this) {
    _Success(data: final d) => Result.success(d),
    _Failure(error: final e) => Result.failure(transform(e)),
  };

  /// Flat map the success value to a new Result
  Result<R, E> flatMap<R>(Result<R, E> Function(T) transform) => switch (this) {
    _Success(data: final d) => transform(d),
    _Failure(error: final e) => Result.failure(e),
  };

  /// Execute a function based on the result type
  R fold<R>(
    R Function(T) onSuccess,
    R Function(E) onFailure,
  ) => switch (this) {
    _Success(data: final d) => onSuccess(d),
    _Failure(error: final e) => onFailure(e),
  };

  /// Execute a function if this is a success
  Result<T, E> onSuccess(void Function(T) action) {
    if (isSuccess && data != null) {
      action(data as T);
    }
    return this;
  }

  /// Execute a function if this is a failure
  Result<T, E> onFailure(void Function(E) action) {
    if (isFailure && error != null) {
      action(error as E);
    }
    return this;
  }
}

class _Success<T, E> extends Result<T, E> {
  @override
  final T data;
  const _Success(this.data) : super._();
}

class _Failure<T, E> extends Result<T, E> {
  @override
  final E error;
  const _Failure(this.error) : super._();
}
