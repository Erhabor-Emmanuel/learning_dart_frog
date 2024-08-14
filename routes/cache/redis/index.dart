import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:redis/redis.dart';


//1 - logged in, 0 - logged out
///so if we receive in our temporary cache in redis that our status is 0 that means
///the user should be logged out and vice-versa
Future<Response> onRequest(RequestContext context) {
  return switch(context.request.method){
    HttpMethod.get => _getLoginStatus(context),
    HttpMethod.post => _setLoginStatus(context),
    _=> Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

///I want to use redis cache to handle or store our login status
Future<Response> _getLoginStatus (RequestContext context) async{
  final value = await context.read<Command>().send_object(['GET', 'loggedin'])
      .then((value) => value);

  if(value == null){
    const status = 0;
    await context.read<Command>().send_object(['SET', 'loggedin', status]);
    return Response(statusCode: HttpStatus.noContent);
  }else{
    return Response.json(body: value.toString() );
  }
}

Future<Response> _setLoginStatus (RequestContext context) async{
  final body = await context.request.json() as Map<String, dynamic>;
  final status = body['loggedin'] as int;
  var success = false;

  try{
    ///we set the value of our key to the value that user has passed which in
    /// this case is "status"
    await context.read<Command>().send_object(['SET', 'loggedin', status]);
    success = true;
  }catch(e){
    success = false;
  }

  return Response.json(body: {'success': success});
}


