import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationNotifier extends StateNotifier<bool> {
  AuthenticationNotifier() : super(false);

  void startAuthentication() {
    state = true;
  }

  void stopAuthentication() {
    state = false;
  }
}

final authenticationProvider =
    StateNotifierProvider<AuthenticationNotifier, bool>(
  (ref) => AuthenticationNotifier(),
);
