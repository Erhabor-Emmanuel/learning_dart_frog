import 'package:dart_frog/dart_frog.dart';
import 'package:redis/redis.dart';


///When catching data in dart you can use the middleware and setup a temporary
///storage in form a variable and allow its access to be private so that it can
///only be accessed in the context of the provider created inside this middleware

final conn = RedisConnection();

Handler middleware(Handler handler) {
  return (context) async{
    Response response;

    try{
      ///Now we are going to connect to redis i.e the one we have installed in our docker
      ///The connect method connects to the redis server
      final command = await conn.connect('localhost', 6379);
      ///This is to authenticate our connection
      ///I didn't set password when i was installing redis via command line so i
      ///left this as an example of how it would look like:
      //await command.send_object(['AUTH', 'default', 'password']);
      try{
        response = await handler.use(provider<Command>((_) => command)).call(context);
      }catch(e){
        response = Response.json(body: {'success': false, 'message': e.toString()});
      }

    }catch(e){
      response = Response.json(body: {'success': false, 'message': e.toString()});
    }
    return response;
  };
}
