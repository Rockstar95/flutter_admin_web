class ApiResponse<T> {
  int status = 0;
  T data;

  ApiResponse({this.status = 0, required this.data});

  @override
  String toString() {
    return "Status : $status \n Data : $data";
  }
}
