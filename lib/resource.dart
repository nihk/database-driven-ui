class Resource<T> {
  final T data;
  final ResourceState state;
  final Exception exception;

  Resource({this.data, this.state, this.exception});

  factory Resource.loading(T data) {
    return Resource<T>(data: data, state: ResourceState.LOADING, exception: null);
  }

  factory Resource.success(T data) {
    return Resource<T>(data: data, state: ResourceState.SUCCESS, exception: null);
  }

  factory Resource.error(T data, Exception exception) {
    return Resource<T>(data: data, state: ResourceState.ERROR, exception: exception);
  }
}

enum ResourceState {
  LOADING,
  SUCCESS,
  ERROR,
}