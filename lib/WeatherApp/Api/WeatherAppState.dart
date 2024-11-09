class WeatherAppState<T> {
  Status status;
  T? data;
  String? message;


  WeatherAppState.initial(this.message) : status = Status.INITIAL;

  WeatherAppState.loading(this.message) : status = Status.LOADING;

  WeatherAppState.completed(this.data) : status = Status.COMPLETED;

  WeatherAppState.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }

}

enum Status  { INITIAL, LOADING, COMPLETED, ERROR }