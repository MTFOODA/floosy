class AccountUser {
  final String id;
  final String? email;
  final Map<String, dynamic> userMetadata;
  const AccountUser(
      {required this.id, this.email, this.userMetadata = const {}});
}

class AccountSession {
  final AccountUser user;
  const AccountSession(this.user);
}

enum AccountEvent {
  initialSession,
  signedIn,
  signedOut,
  passwordRecovery,
  tokenRefreshed,
  userUpdated,
  userDeleted,
  mfaChallengeVerified,
}

class AccountUpdate {
  final AccountEvent event;
  final AccountSession? session;
  const AccountUpdate(this.event, this.session);
}

class AuthenticationFailure implements Exception {
  final String message;
  final String? code;
  const AuthenticationFailure(this.message, {this.code});
  @override
  String toString() => message;
}
