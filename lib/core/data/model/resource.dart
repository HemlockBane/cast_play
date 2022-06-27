class Resource<T> {
  Resource._(this.data);

  final T? data;

  factory Resource.loading(T? data) = Loading<T>;

  factory Resource.success(T? data) = Success<T>;

  factory Resource.failure({String? errorMessage, T? data}) = Failure<T>;
}

class Loading<T> extends Resource<T> {
  Loading(T? data) : super._(data);
}

class Success<T> extends Resource<T> {
  Success(T? data) : super._(data);
}

class Failure<T> extends Resource<T> {
  Failure({this.errorMessage, T? data}) : super._(data);

  final String? errorMessage;
}
