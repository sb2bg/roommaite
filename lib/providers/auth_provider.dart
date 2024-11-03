import 'package:google_sign_in/google_sign_in.dart';
import 'package:roommaite/util/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  Profile? _cachedProfile;
  DateTime? _lastProfileFetch;

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<Profile> getProfile() async {
    if (_cachedProfile != null &&
        _lastProfileFetch != null &&
        DateTime.now().difference(_lastProfileFetch!) <
            const Duration(minutes: 5)) {
      return _cachedProfile!;
    }

    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', _supabase.auth.currentUser!.id)
        .single();

    final profile = Profile.fromJson(response);

    _cachedProfile = profile;
    _lastProfileFetch = DateTime.now();

    return profile;
  }

  Future<String?> _tryWrapper(Function() function) async {
    try {
      return await function();
    } on AuthException catch (error) {
      return error.message;
    } catch (error) {
      return 'An error occurred. Please try again.';
    }
  }

  Future<String?> signUp(
      {required String email,
      required String name,
      required String username,
      required String password}) async {
    return _tryWrapper(() async {
      final response =
          await _supabase.auth.signUp(email: email, password: password, data: {
        'name': name,
        'username': username,
        'avatar_url': 'https://ui-avatars.com/api/?name=$username&size=128',
      });

      if (response.user == null) {
        return 'An error occurred. Please try again.';
      }

      return null; // No error
    });
  }

  Future<String?> signIn(
      {required String email, required String password}) async {
    return _tryWrapper(() async {
      await _supabase.auth.signInWithPassword(email: email, password: password);

      if (_supabase.auth.currentUser == null) {
        return 'An error occurred. Please try again.';
      }

      return null; // No error
    });
  }

  Future<String?> signInWithGoogle() async {
    return _tryWrapper(() async {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: GoogleClient.iosClientId,
        serverClientId: GoogleClient.webClientId,
      );

      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return "Sign in cancelled.";
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        return 'No access token found.';
      }

      if (idToken == null) {
        return 'No ID token found.';
      }

      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final user = _supabase.auth.currentUser;

      if (user == null) {
        return 'An error occurred. Please try again.';
      }

      return null; // No error
    });
  }

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
