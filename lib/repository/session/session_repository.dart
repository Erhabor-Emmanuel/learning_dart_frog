import 'package:equatable/equatable.dart';
import 'package:learnfrog_backend/hash_extension.dart';
import 'package:meta/meta.dart';

/// This Map is going to host the collection of session objects that we will create
@visibleForTesting
/// in memory database
Map<String, Session> sessionDb = {};

/// A Session class
class Session extends Equatable{

  /// Constructor
  const Session({
    required this.token,
    required this.userId,
    required this.expiryDate,
    required this.createdAt,
  });

  /// The session token
  final String token;

  /// User's ID
  final String userId;

  /// When it will expiry
  final DateTime expiryDate;

  /// When it was created
  final DateTime createdAt;

  @override
  List<Object?> get props => [token, userId, expiryDate, createdAt];
}

/// Session Repository
class SessionRepository{

  /// create session
  Session createSession(String userId){
    final session = Session(
        token: generateToken(userId),
        userId: userId, expiryDate: DateTime.now().add(Duration(hours: 24)),
        createdAt: DateTime.now(),
    );

    /// Adding the session object to the sessionDb Map created earlier on
    sessionDb[session.token] = session;
    return session;
  }

  /// generate token
  String generateToken(String userId){
    return '${userId}_${DateTime.now().toIso8601String()}'.hashValue;
  }

  /// Search a session of a particular token
  Session? searchFromToken(String token){
    final session = sessionDb[token];

    if(session != null && session.expiryDate.isAfter(DateTime.now())){
      return session;
    }
    return null;
  }
}