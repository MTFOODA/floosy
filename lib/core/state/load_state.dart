enum LoadStatus { loading, success, failure }

/// Immutable asynchronous view state shared by the feature Cubits.
class LoadState<T> {
  final LoadStatus status;
  final T? value;
  final Object? error;
  final StackTrace? stackTrace;

  const LoadState.loading({this.value})
      : status = LoadStatus.loading,
        error = null,
        stackTrace = null;
  const LoadState.data(T data)
      : status = LoadStatus.success,
        value = data,
        error = null,
        stackTrace = null;
  const LoadState.failure(this.error, this.stackTrace, {this.value})
      : status = LoadStatus.failure;

  bool get hasValue => status == LoadStatus.success;
  bool get isLoading => status == LoadStatus.loading;
  bool get hasError => status == LoadStatus.failure;
  T? get valueOrNull => value;

  R when<R>(
      {required R Function() loading,
      required R Function(Object, StackTrace) error,
      required R Function(T) data}) {
    if (isLoading && value != null) return data(value as T);
    return switch (status) {
      LoadStatus.loading => loading(),
      LoadStatus.failure => error(this.error!, stackTrace ?? StackTrace.empty),
      LoadStatus.success => data(value as T),
    };
  }

  LoadState<R> map<R>(R Function(T) transform) => switch (status) {
        LoadStatus.loading => LoadState.loading(
            value: value == null ? null : transform(value as T)),
        LoadStatus.failure => LoadState.failure(error, stackTrace,
            value: value == null ? null : transform(value as T)),
        LoadStatus.success => LoadState.data(transform(value as T)),
      };
}
