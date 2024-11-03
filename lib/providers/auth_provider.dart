import 'package:google_sign_in/google_sign_in.dart';
import 'package:roommaite/models/questions.dart';
import 'package:roommaite/util/constants.dart';
import 'package:roommaite/util/vector_data_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  Profile? _cachedProfile;
  DateTime? _lastProfileFetch;

  String get userId => _supabase.auth.currentUser!.id;

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

    final profile = await getProfileById(userId);

    if (profile == null) {
      throw const AuthException('Profile not found.');
    }

    _cachedProfile = profile;
    _lastProfileFetch = DateTime.now();

    return profile;
  }

  Future<bool> addMatch(Profile matchee) async {
    await _supabase.from('matches').upsert({
      'matcher': userId,
      'matchee': matchee.id,
    });

    final matches = await getMatches();

    if (matches.any((p) => p.id == matchee.id)) {
      return true;
    }

    return false;
  }

  Future<void> removeMatch(Profile matchee) async {
    await _supabase
        .from('matches')
        .delete()
        .eq('matcher', userId)
        .eq('matchee', matchee.id);
  }

  Future<Profile?> getProfileById(String uuid) async {
    Profile? profile;

    await _tryWrapper(() async {
      final result =
          await _supabase.from('profiles').select().eq('id', uuid).single();

      profile = Profile.fromJson(result);
    });

    return profile;
  }

  Future<List<Question>> getQuestions() async {
    final questions =
        await _supabase.from('user_questions').select().eq('user_id', userId);

    return questions.map((json) => Question.fromMap(json)).toList();
  }

  Future<List<Question>> getQuestionsFrom(Profile profile) async {
    final questions = await _supabase
        .from('user_questions')
        .select()
        .eq('user_id', profile.id);

    return questions.map((json) => Question.fromMap(json)).toList();
  }

  Future<void> updateLocation(String location) async {
    await _supabase.from('profiles').update({
      'location': location,
    }).eq('id', userId);
  }

  Future<void> answerQuestion(Question question) async {
    try {
      final existingQuestion = await _supabase
          .from('user_questions')
          .select()
          .eq('user_id', userId)
          .eq('question', question.question)
          .single();

      await _supabase.from('user_questions').update({
        'answer': question.answer,
      }).eq('id', existingQuestion['id']);
    } catch (error) {
      // Question doesn't exist
      await _supabase.from('user_questions').upsert({
        'user_id': userId,
        ...question.toMap(),
      });

      return;
    }
  }

  Future<List<Profile>> getMatches() async {
    final sentMatches =
        await _supabase.from('matches').select('matchee').eq('matcher', userId);

    final receivedMatches =
        await _supabase.from('matches').select('matcher').eq('matchee', userId);

    final matches = <Profile>[];

    for (final sentMatch in sentMatches) {
      for (final receivedMatch in receivedMatches) {
        if (sentMatch['matchee'] == receivedMatch['matcher']) {
          final profile = await getProfileById(sentMatch['matchee']);
          if (profile != null && matches.every((p) => p.id != profile.id)) {
            matches.add(profile);
          }
        }
      }
    }

    return matches;
  }

  Future<void> finishProfile() async {
    final questions = await getQuestions();
    final profile = await getProfile();

    await IrisVectorDataHelper.createProfile(
        profile.id, questions, profile.location ?? 'Austin');
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
