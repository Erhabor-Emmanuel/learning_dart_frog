import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:learnfrog_backend/repository/user/user_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async{
  return switch(context.request.method){
    HttpMethod.get => _getUser(context, id),

    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}


Future<Response> _getUser(RequestContext context, String id) async{
  final user = await context.read<UserRepository>().userFromId(id);

  if(user == null){
    return Response(statusCode: HttpStatus.forbidden);
  }else{
    if(user.id != id){
      return Response(statusCode: HttpStatus.forbidden);
    }
    return Response.json(
        body: {
      'id': user.id,
      'name': user.name,
      'username': user.username,
    });
  }


}

// Future<Response>_updateUser(RequestContext context, String id){}
//
// Future<Response>_getUser(RequestContext context, String id){}
//
// Future<Response>_deleteUser(RequestContext context, String id){}
