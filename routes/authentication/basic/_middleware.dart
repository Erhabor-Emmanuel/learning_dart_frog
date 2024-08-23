import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:learnfrog_backend/repository/user/user_repository.dart';


final userRepository = UserRepository();

Handler middleware(Handler handler) {

  return handler.use(basicAuthentication<User>(
    authenticator: (context, username, password){
    /// This variable gets the injected UserRepository
    /// and can now have access to its functions
    final repository = context.read<UserRepository>();
    return repository.userFromCredentials(username, password);
  },
      /// This authentcation request only applies if the httpMethod is not a
      /// POST request
    applies: (RequestContext context) async =>
      context.request.method != HttpMethod.post
  ),
  ).use(provider<UserRepository>((_) => userRepository));
}
