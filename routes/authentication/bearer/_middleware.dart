import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:learnfrog_backend/repository/session/session_repository.dart';
import 'package:learnfrog_backend/repository/user/user_repository.dart';


final userRepository = UserRepository();
final sessionRepository = SessionRepository();

Handler middleware(Handler handler) {

  return handler.use(bearerAuthentication<User>(
      authenticator: (context, token) async{
        /// The sessionRepo variable gets the injected SessionRepository
        /// and can now have access to its functions
        final sessionRepo = context.read<SessionRepository>();
        /// The userRepo variable gets the injected UserRepository
        /// and can now have access to its functions
        final userRepo = context.read<UserRepository>();
        final session = sessionRepo.searchFromToken(token);

        /// If the session is not equal to null, get the userID from the session
        /// that we have created because it is part of what is been returned from
        /// the searchFromToken function and then  use it to validate this user
        return session != null? userRepo.userFromId(session.userId) : null;
      },
      /// This authentcation request only applies if the httpMethod is not a
      /// POST request
      /// Furthermore, we only create a session token at the point of when they're
      /// logging in and when they have it we are only going to be validating it
      /// when they are interacting with the other 2 request which is update and delete
      applies: (RequestContext context) async =>
      context.request.method != HttpMethod.post &&
      context.request.method != HttpMethod.get
  ),
  )
      .use(provider<UserRepository>((_) => userRepository))
      .use(provider<SessionRepository>((_) => sessionRepository));
}
