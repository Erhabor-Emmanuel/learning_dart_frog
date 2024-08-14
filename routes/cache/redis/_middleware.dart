import 'package:dart_frog/dart_frog.dart';
import 'package:redis/redis.dart';


///When catching data in dart you can use the middleware and setup a temporary
///storage in form a variable and allow its access to be private so that it can
///only be accessed in the context of the provider created inside this middleware

final conn = RedisConnection();

Handler middleware(Handler handler) {
  return (context) async{
    Response response;

    ///Now we are going to connect to redis i.e the one we have installed in our docker
    ///The connect method connects to the redis server
    try{
      final command = await conn.connect('localhost', 6379);
    }catch(e){
      response = Response.json(body: {'success': false, 'message': e.toString()});
    }
    return response;
  };
}
