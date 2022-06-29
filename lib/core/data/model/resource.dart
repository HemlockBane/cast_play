// NB: data is a shared field because, depending on your requirements,
// you might want to show cached data when your resource is loading, or
// you might want to show cached/previous data when the remote request fails
class Resource<T> {
  Resource._(this.data);

  factory Resource.loading(T? data) = Loading<T>;

  factory Resource.success(T? data) = Success<T>;

  factory Resource.failure({String? errorMessage, T? data}) = Failure<T>;

  final T? data;
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
