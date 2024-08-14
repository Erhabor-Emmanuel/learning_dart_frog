import 'package:dart_frog/dart_frog.dart';


///When catching data in dart you can use the middleware and setup a temporary
///storage in form a variable and allow its access to be private so that it can
///only be accessed in the context of the provider created inside this middleware

String? greeting; //private variable - temporary storage - cache

Handler middleware(Handler handler) {
  greeting = 'hi';
  return handler.use(provider<String>((context)=> greeting ??= 'Hello' ));
}
