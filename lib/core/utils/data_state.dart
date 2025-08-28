/// Represents the state of an asynchronous operation
sealed class DataState<T> {
  const DataState._();

  /// Initial state before any operation
  const factory DataState.idle() = _Idle<T>;

  /// Loading state during operation
  const factory DataState.loading() = _Loading<T>;

  /// Success state with data
  const factory DataState.success(T data) = _Success<T>;

  /// Error state with error message
  const factory DataState.error([String? message]) = _Error<T>;

  /// Check if state is idle
  bool get isIdle => this is _Idle<T>;

  /// Check if state is loading
  bool get isLoading => this is _Loading<T>;

  /// Check if state is success
  bool get isSuccess => this is _Success<T>;

  /// Check if state has error
  bool get hasError => this is _Error<T>;

  /// Get data if in success state, null otherwise
  T? get data => switch (this) {
    _Success(data: final d) => d,
    _ => null,
  };

  /// Get error message if in error state, null otherwise
  String? get errorMessage => switch (this) {
    _Error(message: final m) => m,
    _ => null,
  };
}

class _Idle<T> extends DataState<T> {
  const _Idle() : super._();
}

class _Loading<T> extends DataState<T> {
  const _Loading() : super._();
}

class _Success<T> extends DataState<T> {
  @override
  final T data;
  const _Success(this.data) : super._();
}

class _Error<T> extends DataState<T> {
  final String? message;
  const _Error([this.message]) : super._();
}
