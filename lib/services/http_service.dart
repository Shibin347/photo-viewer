
import 'package:dio/dio.dart';

class HttpService{
  late Dio _dio;

  HttpService() {
    _dio = Dio(BaseOptions(
      baseUrl: "https://pixabay.com/api/28798678-7baea7484e2a4f81a6a9b2e00/",
    ));
    print("api integration started");
    _dio.interceptors.add(LogInterceptor(requestBody: true));
    _dio.interceptors.add(InterceptorsWrapper(onError: (e, handler){
      Response res = _handlerDioError(e);
      handler.resolve(res);
    },
        onRequest: (response, handler){
          return handler.next(response);
        }
    ));
  }

  Response _handlerDioError(DioError dioError) {
    String message;
    switch (dioError.type) {
      case DioErrorType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioErrorType.connectTimeout:
        message = "Connection timeout with API server";
        break;
      case DioErrorType.other:
        message = "Connection to API server failed due to internet connection";
        break;
      case DioErrorType.receiveTimeout:
        message = "Reciever timeout in connection with API server";
        break;
      case DioErrorType.response:
        switch (dioError.response?.statusCode) {
          case 400:
            message = 'Bad request';
            break;
          case 404:
            message = "404 bad request";
            break;
          case 422:
            message = "422 bad request";
            break;
          case 500:
            message = 'Internal server error';
            break;
          default:
            message = 'Oops something went wrong';
            break;
        }
        break;
      case DioErrorType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      default:
        message = "Something went wrong";
        break;
    }
    return Response(
        requestOptions: RequestOptions(path: ""),
        data: dioError.response?.data,
        statusMessage: message,
        statusCode: dioError.response?.statusCode ?? 500);
  }

  Future<Response> getImage(dynamic searchTerm, dynamic page){
    var params =  {
      "key": "28798678-7baea7484e2a4f81a6a9b2e00",
      "q": searchTerm,
      "page": page
    };
    return _dio.post("https://pixabay.com/api/",queryParameters: params);
  }
}