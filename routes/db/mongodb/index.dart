import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:learnfrog_backend/hash_extension.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future<Response> onRequest(RequestContext context) {
  ///We use a switch case to check the http method that is passed
  return switch(context.request.method){
    HttpMethod.get => _getList(context),
    HttpMethod.post => _createList(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _getList(RequestContext context) async{
  final lists = await context.read<Db>().collection('lists').find().toList();
  return Response.json(body: lists.toString());
}

Future<Response> _createList(RequestContext context) async{
  final body = await context.request.json() as Map<String, dynamic>;
  ///We start by first creating the name of the list
  final name = body['name'] as String?;

  final id = name?.hashValue;

  final list = <String, dynamic>{'id': id, 'name' : name};

  final result = await context.read<Db>().collection('lists').insertOne(list);

  return Response.json(body: {'id' : result.id});
} 