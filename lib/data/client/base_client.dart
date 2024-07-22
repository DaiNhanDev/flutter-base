import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:retry/retry.dart';

import '../../exception/exception.dart';
import '../../models/authorization.dart';

abstract class BaseClient {
  final Client _client;
  final String _host;
  final Authorization? _authorization;

  BaseClient(String host, {Client? client, Authorization? authorization})
      : _client = client ?? Client(),
        _host = host,
        _authorization = authorization;

  Uri _getParsedUrl(String path) {
    print('===> $_host$path');
    return Uri.parse('$_host$path');
  }

  BaseRequest _copyRequest(BaseRequest request) {
    BaseRequest requestCopy;

    if (request is Request) {
      requestCopy = Request(request.method, request.url)
        ..encoding = request.encoding
        ..bodyBytes = request.bodyBytes;
    } else if (request is MultipartRequest) {
      requestCopy = MultipartRequest(request.method, request.url)
        ..fields.addAll(request.fields)
        ..files.addAll(request.files);
    } else if (request is StreamedRequest) {
      throw Exception('copying streamed requests is not supported');
    } else {
      throw Exception('request type is unknown, cannot copy');
    }

    requestCopy
      ..persistentConnection = request.persistentConnection
      ..followRedirects = request.followRedirects
      ..maxRedirects = request.maxRedirects
      ..headers.addAll(request.headers);

    return requestCopy;
  }

  Future<dynamic> _call(String method, String path,
      {Map<String, Object>? data}) async {
    dynamic responseJson;
    try {
      Request request = Request(method, _getParsedUrl(path));
      print('=======> request ${request}');
      print('=======> method ${method}');

      // final token = _authorization ?? Repository().authorization?.accessToken;
      // if (token != null) {
      //   request.headers['Authorization'] = 'Bearer $token';
      // }
      request.headers['Content-Type'] = 'application/json; charset=UTF-8';
      if (data != null) {
        request.body = jsonEncode(data);
        print('=======> request.body ${request.body}');
      }

      responseJson = await retry(
        () async {
          final response = await _client
              .send(request)
              // .timeout(const Duration(seconds: 30))
              .then(Response.fromStream);

          // final response = _client.post(
          //   Uri.parse('http://localhost:8000/api/v1/access/shop/login'),
          //   headers: <String, String>{
          //     'Content-Type': 'application/jsorset=UTF-8',
          //   },
          //   body: jsonEncode(data),
          // );

          return response;
        },
        retryIf: (e) async {
          if (e is UnauthorisedException) {
            request = _copyRequest(request) as Request;
            return true;
          }
          return false;
        },
      );
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(Response response) {
    print('======> responseJson ${response.body.toString()}');

    switch (response.statusCode) {
      case 200:
        final responseJson = jsonDecode(response.body);
        if (responseJson['result'] == false) {
          throw AppException(responseJson);
        }
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      case 501:
        throw ServerErrorException(response.body.toString());
      default:
        throw FetchDataException(
            '''Error occurred while Communication with Server with StatusCode : ${response.statusCode}''');
    }
  }

  Future<dynamic> get(String path) {
    return _call('GET', path);
  }

  Future<dynamic> post(String path, [dynamic data]) async {
    return _call('POST', path, data: data);
  }

  Future<dynamic> put(String path, [dynamic data]) {
    return _call('PUT', path, data: data);
  }

  Future<dynamic> delete(String path, [dynamic data]) {
    return _call('DELETE', path, data: data);
  }
}
