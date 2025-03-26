class AsyncValue<T> {
  final T? data;
  final Object? error;
  final bool isLoading;

  // Private constructor (used internally)
  AsyncValue._({this.data, this.error, this.isLoading = false});
  /// Constructor to create a 'loading' state
  factory AsyncValue.loading() => AsyncValue._(isLoading: true);
  /// Constructor to create a 'success' state with data
  factory AsyncValue.success(T data) => AsyncValue._(data: data);
  /// Constructor to create an 'error' state with an error object
  factory AsyncValue.error(Object error) => AsyncValue._(error: error);
}