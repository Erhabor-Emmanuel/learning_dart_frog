import 'dart:io';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) {
  return switch(context.request.method){
    HttpMethod.post => _createUser(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _createUser(RequestContext context){
  final body = context.request.json() as Map<String, dynamic>;
  final name = body['name'] as String?;
}
