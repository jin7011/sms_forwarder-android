/// Equivalent to Android's Result class for handling success/error states
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final String message;
  final Exception? exception;
  const Error(this.message, [this.exception]);
}

class Loading<T> extends Result<T> {
  const Loading();
}

extension ResultExtensions<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isError => this is Error<T>;
  bool get isLoading => this is Loading<T>;
  
  T? get dataOrNull => switch (this) {
    Success<T>(data: final data) => data,
    _ => null,
  };
  
  String? get errorMessage => switch (this) {
    Error<T>(message: final message) => message,
    _ => null,
  };
}